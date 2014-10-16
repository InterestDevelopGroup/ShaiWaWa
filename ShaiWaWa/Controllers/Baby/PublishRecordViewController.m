//
//  PublishRecordViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PublishRecordViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "AddBabyInfoViewController.h"
#import "MybabyListViewController.h"
#import "LocationsViewController.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "BabyInfo.h"
#import "PublishImageView.h"
#import "UIImageView+WebCache.h"
#import "VideoConvertHelper.h"
#import "AppMacros.h"
#import "InputHelper.h"
#import "QNUploadHelper.h"
#import "TopicViewController.h"
#import "ChooseFriendViewController.h"
#import "NSStringUtil.h"
#import "ImageDisplayView.h"
#import "Setting.h"
#import "Friend.h"
#import "AudioView.h"
#import "Mp3RecordWriter.h"
#import "MLAudioMeterObserver.h"
#import "MLAudioRecorder.h"
#import "ChooseModeViewController.h"
#import "ELCImagePickerController.H"
#import <MobileCoreServices/UTCoreTypes.h>

@import AVFoundation;
@import MediaPlayer;
#define PlaceHolder @"关于宝宝的开心事情..."
@interface PublishRecordViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,ELCImagePickerControllerDelegate>
{
    AudioView *_audioView;
}
@property (nonatomic,strong) BabyInfo * babyInfo;
@property (nonatomic,strong) UserInfo * userInfo;
@property (nonatomic,strong) Setting * setting;
@property (nonatomic,strong) NSDictionary * placemark; //位置
@property (nonatomic,strong) NSString * visibility; //可见性
@property (nonatomic,strong) NSMutableArray * images; //图片路径数组
@property (nonatomic,strong) NSMutableArray * imageViews;  //图片对应的imageview数组
@property (nonatomic,strong) NSMutableArray * uploadedImages;  //上传成功图片队列
@property (nonatomic,strong) NSMutableArray * uploadFailImages; //上传失败图片队列
@property (nonatomic,strong) NSString * videoPath;  //本地视频路径
@property (nonatomic,strong) NSString * uploadedVideoPath;  //上传成功后视频路径
@property (nonatomic,strong) NSString * audioPath;  //本地音频路径
@property (nonatomic,strong) NSString * uploadedAudioPath;  //上传成功后音频路径
@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,strong) AVAudioRecorder * audioRecord;
@property (nonatomic,strong) NSTimer * recordTimer;
@property (nonatomic,assign) int recordSecond;
@property (nonatomic,assign) BOOL isOffset;
@property (nonatomic,strong) NSMutableArray * selectedFriends;
@property (nonatomic, strong) Mp3RecordWriter *mp3Writer;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (nonatomic, strong) MLAudioRecorder *recorder;
@end

@implementation PublishRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _setting = [[UserDefault sharedInstance] set];
        _userInfo = [[UserDefault sharedInstance] userInfo];
        _images = [@[] mutableCopy];
        _imageViews = [@[] mutableCopy];
        _uploadedImages = [@[] mutableCopy];
        _uploadFailImages = [@[] mutableCopy];
        _visibility = @"2";
        _isOffset = NO;
        _recordSecond = 0;
        _selectedFriends = [@[] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil]; //设置音频类别，这里表示当应用启动，停掉后台其他音频
    [audioSession setActive:YES error:nil];//设置当前应用音频活跃性
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods
- (void)initUI
{
    self.title = NSLocalizedString(@"PublishVCTitle", nil);
    [self setLeftCusBarItem:@"square_back" action:@selector(backUp:)];
    self.navigationItem.rightBarButtonItem = [self customBarItem:@"pb_fabu" action:@selector(publishAction:) size:CGSizeMake(57, 27)];
    
    _textView.allowsEditingTextAttributes = YES;
    
    //添加按钮到视图中
    _button3View.frame = _scrollView.frame;
    [self.view addSubview:_button3View];
    
    //添加底部按钮到视图中
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_bottomView.frame), CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame));
    [self.view addSubview:_bottomView];
    
    [_textView setPlaceholder:PlaceHolder];
    _textView.inputAccessoryView = _toolbar;
    
    //获取宝宝列表
    [self getBabys];
    
    
    //判断是否自动定位
    if([_setting.show_position isEqualToString:@"1"])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
    
    //设置可见性
    if([_setting.visibility isEqualToString:@"1"])
    {
        _visibilityLabel.text = @"公开";
        _visibility = @"1";
    }
    else if([_setting.visibility isEqualToString:@"2"])
    {
        _visibilityLabel.text = @"仅好友可见";
        _visibility = @"2";
    }
    else if ([_setting.visibility isEqualToString:@"3"])
    {
        _visibilityLabel.text = @"仅父母可见";
        _visibility = @"3";
    }
    
    //设置分享平台
    if([_setting.is_share isEqualToString:@"1"])
    {
        if(_userInfo.tecent_openId != nil)
        {
            _tecentWeiboBtn.selected = YES;
            _qqSpaceBtn.selected = YES;
        }
        
        if(_userInfo.sina_openId != nil)
        {
            _sinaWeiboBtn.selected = YES;
        }
        
    }
}

//获取宝宝列表
- (void)getBabys
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",@"pagesize":@"1000",@"uid":user.uid}completionBlock:^(id object) {
        [SVProgressHUD dismiss];
        if([object count] == 0)
        {
            _moreButton.hidden = YES;
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"HaveNotBaby", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Back", nil) otherButtonTitles:NSLocalizedString(@"Add", nil),nil];
            alertView.tag = 1;
            [alertView show];
            alertView = nil;
            return ;
        }
        
        
        if([object count] > 1)
        {
            _moreButton.hidden = NO;
            NSString * defaultBabyID = [[NSUserDefaults standardUserDefaults] objectForKey:Default_Baby_ID];
            
            if(defaultBabyID == nil)
            {
                _babyInfo = object[0];
            }
            else
            {
                for(BabyInfo * babyInfo in object)
                {
                    if([babyInfo.baby_id isEqualToString:defaultBabyID])
                    {
                        _babyInfo = babyInfo;
                        break ;
                    }
                }

            }
            
            [self updateBabyInfo:_babyInfo];
            [[NSUserDefaults standardUserDefaults] setObject:_babyInfo.baby_id forKey:Default_Baby_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            _moreButton.hidden = YES;
            _babyInfo = object[0];
            [self updateBabyInfo:_babyInfo];
            [[NSUserDefaults standardUserDefaults] setObject:_babyInfo.baby_id forKey:Default_Baby_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD dismiss];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"GetBabyError", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Back", nil) otherButtonTitles:NSLocalizedString(@"TryAgain", nil),nil];
        alertView.tag = 2;
        [alertView show];
        alertView = nil;
        
        _moreButton.hidden = YES;
        
    }];
}


//更新当前宝宝的头像和名称
- (void)updateBabyInfo:(BabyInfo *)babyInfo
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:babyInfo.avatar] placeholderImage:Default_Avatar];
    _babyNameLabel.text = babyInfo.nickname;
}


- (void)backUp:(id)sender
{
    self.parentCtrl.isNeedRefresh = NO;
    [self popVIewController];
}

//提交方法
- (void)publishAction:(id)sender
{
    
    /**
     1.先检查是否有图片和视频
     2.检查内容是否为空
     3.如果是图片则循环上传；如果是视频则单个上传，不需要上传图片
     */
    
    [_textView resignFirstResponder];
    
    //判断是否有选择宝宝
    if(_babyInfo == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择宝宝."];
        return ;
    }
    
    //判断是否有添加图片
    //判断内容是否为空
    NSString * content = [InputHelper trim:_textView.text];
    if([_images count] == 0 && _videoPath == nil && ([InputHelper isEmpty:content] || [content isEqualToString:PlaceHolder]) && _audioPath == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请添加内容."];
        return ;
    }
    
    
    [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeGradient];
    
    _uploadedImages = [@[] mutableCopy];
    _uploadFailImages = [@[] mutableCopy];
    //上传成功回调
    [[QNUploadHelper sharedHelper] setUploadSuccess:^(NSString * str){
        
        //判断是上传视频还是图片
        if([str hasSuffix:@"png"] || [str hasSuffix:@"jpg"])
        {
            //将上传成功的图片添加到数组中,用于记录上传成功的个数
            [_uploadedImages addObject:str];
            if([_uploadedImages count] == [_images count])
            {
                //检查是否图片全部上传完毕
                [self checkUploadIsComplete];
                return ;
                
            }
        }
        else if([str hasSuffix:@"mp4"] || [str hasSuffix:@"mov"])
        {
            //上传视频成功，将内容提交到服务器
            self.uploadedVideoPath =[NSString stringWithFormat:@"%@%@",QN_URL,[_videoPath lastPathComponent]];
            [self uploadVideoFinish];
        }
        else if([str hasSuffix:@"wav"] || [str hasSuffix:@"mp3"])
        {
            self.uploadedAudioPath = [NSString stringWithFormat:@"%@%@",QN_URL,[_audioPath lastPathComponent]];
            if([_images count] != 0)
            {
                [self checkUploadIsComplete];
            }
            else
            {
                [self uploadVideoFinish];
            }
        }
        
    }];
    //上传失败回调
    [[QNUploadHelper sharedHelper] setUploadFailure:^(NSString * str){
        [SVProgressHUD dismiss];
        //判断是上传视频还是图片
        if([str hasSuffix:@"png"] || [str hasSuffix:@"jpg"])
        {
            //将上传失败的图片添加到失败队列中
            [_uploadFailImages addObject:str];
            //检查是否全部上传完毕
            [self checkUploadIsComplete];

        }
        else if([str hasSuffix:@"mp4"] || [str hasSuffix:@"mov"])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"上传视频失败." delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重试", nil];
            [alertView show];
            alertView = nil;
            _uploadedVideoPath = nil;
        }
        else if([str hasSuffix:@"wav"] || [str hasSuffix:@"mp3"])
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"上传音频失败." delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重试", nil];
            [alertView show];
            alertView = nil;
            _uploadedAudioPath = nil;
        }


    }];
    
    //如果有音频则上传
    if(_audioPath != nil)
    {
        [[QNUploadHelper sharedHelper] uploadFile:_audioPath];
    }
    
    //如果有视频则上传,然后返回，不需要上传图片
    if(_videoPath != nil)
    {
        [[QNUploadHelper sharedHelper] uploadFile:_videoPath];
        return ;
    }
    
    if([_images count] > 0)
    {
        for(NSString * path in _images)
        {
            [[QNUploadHelper sharedHelper] uploadFile:path];
        }
        
        return ;
    }
    
    //只发布内容不发布多媒体
    [self uploadVideoFinish];
    
    
}


//检测是否上传完毕，以及是否上传出错
- (void)checkUploadIsComplete
{
    if([_uploadedImages count] + [_uploadFailImages count] != [_images count])
    {
        return ;
    }
    
    if(_audioPath != nil && _uploadedAudioPath == nil)
    {
        return ;
    }
    
    if([_uploadFailImages count] > 0)
    {
        DDLogCInfo(@"Some images upload failed.");
        [SVProgressHUD dismiss];
        NSString * msg = [NSString stringWithFormat:@"有%i张图片上传失败",[_uploadFailImages count]];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新提交", nil];
        alertView.tag = 3;
        [alertView show];
        alertView = nil;
        return ;
    }
    
    DDLogCInfo(@"Upload images complete.");
    [SVProgressHUD showSuccessWithStatus:@"上传成功."];
    
    //上传图片完毕，提交到服务器
    NSMutableArray * tmpImageURLS = [@[] mutableCopy];
    for (NSString * path in _uploadedImages)
    {
        [tmpImageURLS addObject:[NSString stringWithFormat:@"%@%@",QN_URL,[path lastPathComponent]]];
    }
    [_uploadedImages removeAllObjects];
    //NSString * content = [InputHelper trim:_textView.text];
    NSString * content = [_textView.text isEqualToString:PlaceHolder] ? @"" : _textView.text;
    //将@用户替换成特殊字符，{uid}
    content = [self processTuiFriends:content];
    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"baby_id"] = _babyInfo.baby_id;
    params[@"uid"] =  _userInfo.uid;
    params[@"visibility"] = _visibility;
    params[@"content"] = content;
    params[@"address"] = @"";
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:_babyInfo.baby_id forKey:Default_Baby_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(_placemark != nil)
    {
        params[@"address"] = _placemark[@"address"];
        params[@"longitude"] = _placemark[@"longitude"];
        params[@"latitude"] = _placemark[@"latitude"];
    }
    
    //params[@"video"] = _videoPath != nil ? _videoPath : @"";
    params[@"video"] = self.uploadedVideoPath == nil ? @"" : self.uploadedVideoPath;
    params[@"audio"] = self.uploadedAudioPath == nil ? @"" : self.uploadedAudioPath;
    params[@"images"] = tmpImageURLS;
    [[HttpService sharedInstance] publishRecord:params completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功."];
        //清楚数据
        [self cleanUp];
        //需要刷新页面
        self.parentCtrl.isNeedRefresh = YES;
        //返回上个页面
        [self popVIewController];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
              msg = @"提交失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


//视频上传7牛后调用的函数
- (void)uploadVideoFinish
{
    
    if((_videoPath != nil && _uploadedVideoPath == nil) || (_audioPath != nil && _uploadedAudioPath == nil))
    {
        return ;
    }
    //NSString * content = [InputHelper trim:_textView.text];
    
    NSString * content = [_textView.text isEqualToString:PlaceHolder] ? @"" : _textView.text;
    //将@用户替换成特殊字符，{uid}
    content = [self processTuiFriends:content];
    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"baby_id"] = _babyInfo.baby_id;
    params[@"uid"] =  _userInfo.uid;
    params[@"visibility"] = _visibility;
    params[@"content"] = content;
    params[@"address"] = @"";
    params[@"longitude"] = @"";
    params[@"latitude"] = @"";
    if(_placemark != nil)
    {
        params[@"address"] = _placemark[@"address"];
        params[@"longitude"] = _placemark[@"longitude"];
        params[@"latitude"] = _placemark[@"latitude"];
    }
    //params[@"video"] = _videoPath != nil ? [NSString stringWithFormat:@"%@%@",QN_URL,[_videoPath lastPathComponent]] : @"";
    params[@"video"] = self.uploadedVideoPath == nil ? @"" : self.uploadedVideoPath;
    params[@"audio"] = self.uploadedAudioPath == nil ? @"" : self.uploadedAudioPath;
    params[@"images"] = @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:_babyInfo.baby_id forKey:Default_Baby_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[HttpService sharedInstance] publishRecord:params completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功."];
        //清楚数据
        [self cleanUp];
        self.parentCtrl.isNeedRefresh =YES;
        //返回上个页面
        [self popVIewController];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"提交失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


//将@用户替换成特殊字符，{uid}
- (NSString *)processTuiFriends:(NSString *)content
{
    //将@用户替换成特殊字符，{uid}
    if([content length] > 0)
    {
        if([_selectedFriends count] > 0)
        {
            NSArray * arr = [NSStringUtil getUserStringRangeArray:content];
            for(NSString * rangeString in arr)
            {
                NSRange range = NSRangeFromString(rangeString);
                NSString * username = [[content substringWithRange:range] stringByReplacingOccurrencesOfString:@"@" withString:@""];
                for(Friend * friend in _selectedFriends)
                {
                    if([friend.username isEqualToString:username])
                    {
                        content = [content stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"{@%@} ",friend.friend_id]];
                        break ;
                    }
                }
            }
        }
    }
    
    return content;
}



//清楚数据
- (void)cleanUp
{
    _videoPath = nil;
    _addressLabel.text = @"添加位置";
    _placemark = nil;
    _textView.text = PlaceHolder;
    [_images removeAllObjects];
    [_imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageViews removeAllObjects];
    [_uploadedImages removeAllObjects];
    [_uploadFailImages removeAllObjects];
    [self.view addSubview:_button3View];
    _addMoreButton.hidden = YES;
}

#pragma mark - 监听选择宝宝
- (IBAction)showMoreBaby:(id)sender
{
    MybabyListViewController * vc = [[MybabyListViewController alloc] initWithNibName:nil bundle:nil];
    vc.didSelectBaby = ^(BabyInfo * babyInfo){
        _babyInfo = babyInfo;
        [self updateBabyInfo:_babyInfo];
    };
    [self push:vc];
    vc = nil;
}


#pragma mark 添加更多图片
- (IBAction)showButtonsAction:(id)sender
{
    _overlayView.frame = self.view.bounds;
    [self.view addSubview:_overlayView];
    
}

- (IBAction)hideOverlay:(id)sender
{
    [_overlayView removeFromSuperview];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [_textView resignFirstResponder];
}



#pragma -开始拍照按钮监听
- (IBAction)openPictureAction:(id)sender
{
    [_overlayView removeFromSuperview];
    
//    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];
//    picker = nil;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 9 - _images.count;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
    
	elcPicker.imagePickerDelegate = self;

    [self presentViewController:elcPicker animated:YES completion:nil];

}

#pragma mark --多选照片选择器代理放法
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_overlayView removeFromSuperview];
    
	//初始化数组存放图片
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    //遍历，拿出图片
    for (NSDictionary *dict in info) {
        
        if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
            UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
            [images addObject:image];
            
            UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
            [imageview setContentMode:UIViewContentModeScaleAspectFit];
            
        } else {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
        }
    }
   //图片后续处理
    [self pickPictureProcess:images];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate Methods
//点击相册中的图片 或照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"])
        {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            [self pickPictureProcess:@[image]];
        }
        else if([mediaType isEqualToString:@"public.movie"])
        {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            //DDLogVerbose(@"%@",videoURL);
            [self pickVideoProcess:videoURL];
        }
        
    }];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//显示拍照控制器
- (IBAction)takePictureAction:(id)sender
{
    [_overlayView removeFromSuperview];
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray * avaibleSourcType = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.mediaTypes = [avaibleSourcType subarrayWithRange:NSMakeRange(0, 1)];
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    picker = nil;
}

//显示录像控制器
- (IBAction)takeMovieAction:(id)sender
{
    UIImagePickerController * pickerCamerView = [[UIImagePickerController alloc] init];
    pickerCamerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerCamerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    pickerCamerView.videoMaximumDuration = 15;
    pickerCamerView.videoQuality = UIImagePickerControllerQualityTypeMedium;
    pickerCamerView.delegate = self;
    [pickerCamerView setShowsCameraControls:YES];
    [self presentViewController:pickerCamerView animated:YES completion:^{}];
    pickerCamerView = nil;

}

//显示定位
- (IBAction)showAddressAction:(id)sender
{
    //__weak PublishRecordViewController *rself = self;
    LocationsViewController *locationVC = [[LocationsViewController alloc] init];
    locationVC.didSelectPlacemark = ^(NSDictionary * placemark){
        _placemark = placemark;
        if(_placemark != nil)
        {
            _addressLabel.text = placemark[@"address"];
        }
        else
        {
            _addressLabel.text = @"添加位置";
        }
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

//选择可见性
- (IBAction)setVisibilityAction:(id)sender
{
    NSString *strOne = @"公开";
    NSString *strTwo = @"仅好友可见";
    NSString *strThree = @"仅父母可见";
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:strOne,strTwo,strThree, nil];
    [actionSheet showInView:self.view];
    actionSheet = nil;
}

//选择话题页面
- (IBAction)showTopicAction:(id)sender
{
    TopicViewController * topicVC = [[TopicViewController alloc] initWithNibName:nil bundle:nil];
    topicVC.didSelectTopic = ^(NSString * topic){
        
        if([_textView.text isEqualToString:PlaceHolder])
        {
            _textView.text = @"";
        }
        
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"#%@#",topic] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:131.0/255.0f green:169.0/255.0f blue:88.0/255.0f alpha:1.0]}]];
        
        if([text length] > 140)
        {
            [SVProgressHUD showErrorWithStatus:@"不能超出140个字."];
            return ;
        }
        
        _textView.attributedText = text;

        
    };
    [self.navigationController pushViewController:topicVC animated:YES];
    topicVC = nil;
}

//选择好友页面
- (IBAction)showFriendAction:(id)sender
{
    ChooseFriendViewController *chooseFriendsVC = [[ChooseFriendViewController alloc] initWithNibName:nil bundle:nil];
    chooseFriendsVC.finishSelectedBlock = ^(NSArray * friends){
        
        if(friends == nil || [friends count] == 0)
        {
            return ;
        }
        
        
        
        if([_textView.text isEqualToString:PlaceHolder])
        {
            _textView.text = @"";
        }
        
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
        
        for(Friend * friend in friends)
        {
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@ ",friend.username] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:131.0/255.0f green:169.0/255.0f blue:88.0/255.0f alpha:1.0]}]];

        }
        
        
        [_selectedFriends addObjectsFromArray:friends];
        
        if([text length] > 140)
        {
            [SVProgressHUD showErrorWithStatus:@"内容不能超出140个字符."];
            return ;
        }
        
        _textView.attributedText = text;
        
    };
    [self.navigationController pushViewController:chooseFriendsVC animated:YES];
    chooseFriendsVC = nil;
}

- (IBAction)showRecord:(id)sender
{
    //判断是否录音按钮显示中
    if(_isOffset)
    {
        //如果父视图存在则说明当前是显示状态
        if(_recrodView.superview)
        {
            //从视图中移除
            CGRect recordRect = _recrodView.frame;
            CGRect containRect = _containView.frame;
            CGRect bottomRect = _bottomView.frame;
            _isOffset = NO;
            [_recrodView removeFromSuperview];
            containRect.size.height = containRect.size.height + recordRect.size.height - 15;
            bottomRect.origin.y = bottomRect.origin.y + recordRect.size.height - 15;
            _containView.frame = containRect;
            _bottomView.frame = bottomRect;
        }
        else
        {
            //当前不在显示状态,先删除分享按钮
            [_shareView removeFromSuperview];
            CGRect recordRect = _recrodView.frame;
            recordRect.origin.y = CGRectGetHeight(self.view.frame) - recordRect.size.height;
            [self.view addSubview:_recrodView];
        }
    }
    else
    {
        //显示录音按钮，并调整位置
        CGRect recordRect = _recrodView.frame;
        CGRect containRect = _containView.frame;
        CGRect bottomRect = _bottomView.frame;
        containRect.size.height = containRect.size.height - recordRect.size.height + 15;
        bottomRect.origin.y = bottomRect.origin.y - recordRect.size.height + 15;
        recordRect.origin.y = CGRectGetHeight(self.view.frame) - recordRect.size.height;
        _containView.frame = containRect;
        _bottomView.frame = bottomRect;
        _recrodView.frame = recordRect;
        [self.view addSubview:_recrodView];
        _isOffset = YES;
    }
}

- (IBAction)showShare:(id)sender
{
    //判断是否分享按钮显示中
    if(_isOffset)
    {
        //如果父视图存在则说明当前是显示状态
        if(_shareView.superview)
        {
            //从视图中移除
            CGRect shareRect = _shareView.frame;
            CGRect containRect = _containView.frame;
            CGRect bottomRect = _bottomView.frame;
            _isOffset = NO;
            [_shareView removeFromSuperview];
            containRect.size.height = containRect.size.height + shareRect.size.height - 15;
            bottomRect.origin.y = bottomRect.origin.y + shareRect.size.height - 15;
            _containView.frame = containRect;
            _bottomView.frame = bottomRect;
        }
        else
        {
            //当前不在显示状态,先删除录音按钮
            [_recrodView removeFromSuperview];
            CGRect shareRect = _shareView.frame;
            shareRect.origin.y = CGRectGetHeight(self.view.frame) - shareRect.size.height;
            [self.view addSubview:_shareView];
        }
    }
    else
    {
        
        //显示分享按钮，并调整位置
        _isOffset = YES;
        CGRect shareRect = _shareView.frame;
        CGRect containRect = _containView.frame;
        CGRect bottomRect = _bottomView.frame;
        containRect.size.height = containRect.size.height - shareRect.size.height + 15;
        bottomRect.origin.y = bottomRect.origin.y - shareRect.size.height + 15;
        shareRect.origin.y = CGRectGetHeight(self.view.frame) - shareRect.size.height;
        _containView.frame = containRect;
        _bottomView.frame = bottomRect;
        _shareView.frame = shareRect;
        [self.view addSubview:_shareView];

    }

}

#pragma mark - 开始录音
- (IBAction)startRecord:(id)sender
{
    if (_voiceImageView.superview)
    {
        [_voiceImageView removeFromSuperview];
    }
    
    _voiceImageView.center = self.navigationController.view.center;
    [self.view addSubview:_voiceImageView];
    
    /*
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数,默认 16
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端是内存的组织方式
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];//采样信号是整数还是浮点数
    NSString * fileName = [[IO generateRndString] stringByAppendingPathExtension:@"wav"];
    NSURL * url = [IO URLForResource:fileName inDirectory:Publish_Audio_Folder];
    self.audioPath = [url path];
    NSError * error;
    _audioRecord = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    
    if(error)
    {
        [SVProgressHUD showErrorWithStatus:@"录音失败."];
        return ;
    }
    
    [_audioRecord prepareToRecord];
    [_audioRecord record];
    */
    
    NSString * fileName = [[IO generateRndString] stringByAppendingPathExtension:@"mp3"];
    NSString * path = [IO pathForResource:fileName inDirectory:Publish_Audio_Folder];
    Mp3RecordWriter *mp3Writer = [[Mp3RecordWriter alloc]init];
    mp3Writer.filePath = path;
    mp3Writer.maxSecondCount = 60;
    mp3Writer.maxFileSize = 1024*256;
    self.mp3Writer = mp3Writer;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        NSLog(@"volume:%f",[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]);
    };
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
        
        if (_voiceImageView.superview)
        {
            [_voiceImageView removeFromSuperview];
        }

        self.audioPath = nil;
    };
    self.meterObserver = meterObserver;
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakSelf = self;
    recorder.receiveStoppedBlock = ^{
        weakSelf.meterObserver.audioQueue = nil;
        [self addAudioView];
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        
        if (_voiceImageView.superview)
        {
            [_voiceImageView removeFromSuperview];
        }

        weakSelf.meterObserver.audioQueue = nil;
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    
    self.recorder = recorder;
    
    recorder.fileWriterDelegate = mp3Writer;
    self.audioPath = path;
    //开始录音
    [self.recorder startRecording];
    self.meterObserver.audioQueue = self.recorder->_audioQueue;
    
}

#pragma mark - 停止录音
- (IBAction)stopRecord:(id)sender
{
    
    /*
    if([_audioRecord isRecording])
    {
        [_audioRecord stop];
    }
    */

    if([_recorder isRecording])
    {
        [_recorder stopRecording];
    }
    
    //计算录音时间长度是否大于两秒,否则不允许提交
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_audioPath] error:nil];
    if (player.duration < 2.0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"AudioRecord cann't less than 2 seconds，please try again", nil)];
        _recordBtn.enabled = YES;
        _uploadedAudioPath = nil;
        _audioPath = nil;
        [_audioView removeFromSuperview];
    }
}

- (IBAction)shareToQQSpace:(id)sender
{
    if(_qqSpaceBtn.selected)
    {
        _qqSpaceBtn.selected = NO;
        return ;
    }
    
    if(_userInfo.tecent_openId == nil)
    {
        [self showAlertViewWithMessage:@"还没有绑定QQ空间,现在绑定?"];
        return ;
    }
    
    _qqSpaceBtn.selected = YES;
}

- (IBAction)shareToSinaWeibo:(id)sender
{
    if(_sinaWeiboBtn.selected)
    {
        _sinaWeiboBtn.selected = NO;
        return ;
    }
    
    if(_userInfo.sina_openId == nil)
    {
        [self showAlertViewWithMessage:@"还没有绑定新浪微博,现在绑定?"];
        return ;
    }
    
    _sinaWeiboBtn.selected = YES;
}

- (IBAction)shareToTecentWeibo:(id)sender
{
    if(_tecentWeiboBtn.selected)
    {
        _tecentWeiboBtn.selected = NO;
        return ;
    }
    
    if(_userInfo.tecent_openId == nil)
    {
        [self showAlertViewWithMessage:@"你还没有绑定腾讯微博,现在绑定?"];
        return ;
    }
    
    _tecentWeiboBtn.selected = YES;
}


- (void)addAudioView
{
    
    
    if (_voiceImageView.superview)
    {
        [_voiceImageView removeFromSuperview];
    }

    _recordBtn.enabled = NO;
    [self showRecord:nil];
    
    AudioView * audio = [[AudioView alloc] initWithFrame:CGRectMake(123, 160, 82, 50) withPath:self.audioPath];
    _audioView = audio;
    audio.deleteBlock = ^(NSString * path){
        
        _recordBtn.enabled = YES;
        _uploadedAudioPath = nil;
        _audioPath = nil;
    };
    
    [self.view addSubview:audio];
    [self.view bringSubviewToFront:audio];

}


- (void)startTimer
{
    _recordSecond = 0;
    if(_recordTimer == nil)
    {
        NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
            _recordTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(checkoutRecordTime:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_recordTimer forMode:NSRunLoopCommonModes];
            [_recordTimer fire];
        }];
        [operation start];
    }
    else
    {
        [_recordTimer setFireDate:[NSDate date]];
        [_recordTimer fire];
    }
}

- (void)stopTimer
{
    if(![_recordTimer isValid])
    {
        [_recordTimer setFireDate:[NSDate distantFuture]];
        [_recordTimer invalidate];
    }
}

- (void)checkoutRecordTime:(NSTimer *)timer
{
    if(_recordSecond >= 10)
    {
        [self stopTimer];
        [self stopRecord:nil];
        return ;
    }
    
    _recordSecond += 1;
    
}

//显示添加宝宝页面
- (void)showAddBaby
{
    AddBabyInfoViewController * vc = [[AddBabyInfoViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}
/*
//选择图片后的处理
- (void)pickPictureProcess:(UIImage *)image
{
    //先保存
    NSString * fileName = [[IO generateRndString] stringByAppendingPathExtension:@"png"];
    NSString * path = [IO pathForResource:fileName inDirectory:Publish_Image_Folder];
    if(![IO writeFileToPath:path withData:UIImageJPEGRepresentation(image, 0.6)])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SaveError", nil)];
        return ;
    }
    
    int offx = 5;
    __weak PublishImageView * imageView = [self generateImageViewWithPath:path];
    imageView.frame = CGRectMake(offx * ([_images count] + 1) + [_images count] * CGRectGetWidth(imageView.frame), 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame));
    imageView.deleteBlock = ^(NSString * path){
        [_images removeObject:path];
        [_imageViews removeObject:imageView];
        if([_imageViews count] > 0)
        {
            [self reRangeImageView];
        }
        [_scrollView setContentSize:CGSizeMake(([_images count] + 1) * offx + [_images count] * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [_addMoreButton setTitle:[NSString stringWithFormat:@"添加更多(%i/9)",[_images count]] forState:UIControlStateNormal];
        if([_images count] == 0)
        {

            _addMoreButton.hidden = YES;
            [self.view addSubview:_button3View];
            
        }
    };
    [_images addObject:path];
    [_imageViews addObject:imageView];
    [_scrollView addSubview:imageView];
    [_scrollView setContentSize:CGSizeMake(([_images count] + 1) * offx + [_images count] * CGRectGetWidth(imageView.frame), CGRectGetHeight(_scrollView.frame))];
    //隐藏按钮
    [_button3View removeFromSuperview];
    
    if([_images count] < 9)
    {
        //显示添加按钮，设置标题
        _addMoreButton.hidden = NO;
        [_addMoreButton setTitle:[NSString stringWithFormat:@"添加更多(%i/9)",[_images count]] forState:UIControlStateNormal];
    }
    else
    {
        //9个图片，隐藏按钮
        _addMoreButton.hidden = YES;
    }

}
*/

- (void)pickPictureProcess:(NSArray *)images
{
    int offx = 5;
    
    for (int i = 0; i< images.count; i++) {
        UIImage *image = images[i];
        //先保存图片
        NSString * fileName = [[IO generateRndString] stringByAppendingPathExtension:@"png"];
        NSString * path = [IO pathForResource:fileName inDirectory:Publish_Image_Folder];
        if(![IO writeFileToPath:path withData:UIImageJPEGRepresentation(image, 0.6)])
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SaveError", nil)];
            return ;
        }
        
        //设置生产imageView的宽高
         __weak PublishImageView * imageView = [self generateImageViewWithPath:path];
        imageView.frame = CGRectMake(offx * (i + 1) + i * CGRectGetWidth(imageView.frame), 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame));
        //删除按钮的block
        imageView.deleteBlock = ^(NSString * path){
            [_images removeObject:path];
            [_imageViews removeObject:imageView];
            if([_imageViews count] > 0)
            {
                [self reRangeImageView];
            }
            [_scrollView setContentSize:CGSizeMake(([_images count] + 1) * offx + [_images count] * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            [_addMoreButton setTitle:[NSString stringWithFormat:@"添加更多(%i/9)",[_images count]] forState:UIControlStateNormal];
            if([_images count] == 0)
            {
                
                _addMoreButton.hidden = YES;
                [self.view addSubview:_button3View];
                
            }
        };
        
        [_images addObject:path];
        [_imageViews addObject:imageView];
        [_scrollView addSubview:imageView];
        [_scrollView setContentSize:CGSizeMake(([_images count] + 1) * offx + [_images count] * CGRectGetWidth(imageView.frame), CGRectGetHeight(_scrollView.frame))];
        [self reRangeImageView];
        //隐藏按钮
        [_button3View removeFromSuperview];
        
        if([_images count] < 9)
        {
            //显示添加按钮，设置标题
            _addMoreButton.hidden = NO;
            [_addMoreButton setTitle:[NSString stringWithFormat:@"添加更多(%i/9)",[_images count]] forState:UIControlStateNormal];
        }
        else
        {
            //9个图片，隐藏按钮
            _addMoreButton.hidden = YES;
        }
    }
    
    
    
}

//选择视频后的处理
- (void)pickVideoProcess:(NSURL *)videoURL
{
    if(videoURL == nil)
    {
        DDLogWarn(@"The video url is nil.");
        return ;
    }
    
    //文件名和保存路径
    NSString * fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingPathExtension:@"mov"];
    NSString * path = [IO pathForResource:fileName inDirectory:Publish_Video_Folder];
    //保存
    NSData * videoData = [NSData dataWithContentsOfURL:videoURL];
    if(![IO writeFileToPath:path withData:videoData])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SaveError", nil)];
        return ;
    }
    NSString * mp4Name = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingPathExtension:@"mp4"];
    [SVProgressHUD showWithStatus:@"处理中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString * mp4Path = [IO pathForResource:mp4Name inDirectory:Publish_Video_Folder];
    [[VideoConvertHelper sharedHelper] setFinishBlock:^(){
        
        _videoPath = mp4Path;
        [SVProgressHUD dismiss];
        
        PublishImageView * imageView = [self generateImageViewWithPath:mp4Path];
        imageView.frame = CGRectMake(5,5,CGRectGetWidth(_scrollView.frame) - 10,CGRectGetHeight(_scrollView.frame) - 10);
        __weak PublishImageView * weakImageView = imageView;
        imageView.deleteBlock = ^(NSString * path){
            _videoPath = nil;
            _uploadedVideoPath = nil;
            [_imageViews removeObject:weakImageView];
            _addMoreButton.hidden = YES;
            [self.view addSubview:_button3View];
        };

        [_imageViews addObject:imageView];
        [_scrollView addSubview:imageView];
        [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollView.frame),CGRectGetHeight(_scrollView.frame))];
        //隐藏按钮
        [_button3View removeFromSuperview];
        _addMoreButton.hidden = YES;
        
        
        
    }];
    [[VideoConvertHelper sharedHelper] convertMov:path toMP4:mp4Path];
    
    
}

//生成imageview
- (PublishImageView *)generateImageViewWithPath:(NSString *)path
{
    PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108) withPath:path];
    imageView.tapBlock = ^(NSString * path){
        
        if([path hasSuffix:@"png"] || [path hasSuffix:@"jpg"])
        {
            ImageDisplayView * displayView = [[ImageDisplayView alloc] initWithFrame:self.navigationController.view.bounds withPath:path withAllImages:_images];
            [self.navigationController.view addSubview:displayView];
            [displayView show];
        }
        else if([path hasSuffix:@"mp4"] || [path hasSuffix:@"mov"])
        {
            MPMoviePlayerViewController * player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
            player.moviePlayer.shouldAutoplay = YES;
            [player.moviePlayer prepareToPlay];
            [player.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            [self presentViewController:player animated:YES completion:nil];
        }
    };
    return imageView;
}

//重新排列图片
- (void)reRangeImageView
{
    int offx = 5;
    for (int i = 0; i < [_imageViews count]; i++) {
        PublishImageView * imageView = _imageViews[i];
        imageView.frame = CGRectMake((i + 1) * offx + i * CGRectGetWidth(imageView.frame), 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame));
    }
}

- (void)keyboardShow:(NSNotification *)notification
{
    
    if(_isOffset && _recrodView.superview)
    {
        [self showRecord:nil];
    }
    
    if(_isOffset && _shareView.superview)
    {
        [self showShare:nil];
    }
    
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //NSLog(@"%@",[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]);
    CGRect beginRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //NSLog(@"%f",self.view.frame.origin.y);
    
    [UIView animateWithDuration:duration animations:^{
        
        float offset ;
        if(beginRect.size.height == endRect.size.height)
        {
            offset = - beginRect.size.height + 65;
        }
        else
        {
            offset = beginRect.size.height - endRect.size.height;
        }
        self.view.frame = CGRectOffset(self.view.frame, 0,offset);
    }];
    
}

- (void)keyboardHide:(NSNotification *)notification
{
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0,  [OSHelper iOS7]?64:0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];

}






#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error)
        {
            /*
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"定位失败!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];
            alertView = nil;
            */
            [_locationManager stopUpdatingLocation];
           
            DDLogError(@"定位失败");
            return ;
        }
        
        if([placemarks count] > 0)
        {
            [_locationManager stopUpdatingLocation];
            CLPlacemark * placemark = placemarks[0];
            _addressLabel.text = placemark.name;
            
            NSMutableDictionary * addressInfo = [@{} mutableCopy];
            addressInfo[@"name"] = placemark.name;
            addressInfo[@"address"] = placemark.name;
            addressInfo[@"latitude"] = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
            addressInfo[@"longitude"] = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
            _placemark = (NSDictionary *)addressInfo;
        }
        
    }];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    /*
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"定位失败!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alertView show];
    alertView = nil;
    */
}



#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 3) {
        return ;
    }
    
    if(buttonIndex == 0)
    {
        self.visibility = @"1";
    }
    else if(buttonIndex == 1)
    {
        self.visibility = @"2";
    }
    else if(buttonIndex == 2)
    {
        self.visibility = @"3";
    }
    
    _visibilityLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
}

#pragma mark - UITextViewDelegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.location > 140)
    {
        return NO;
    }
    
    //判断是否删除字符
    if([text isEqualToString:@""])
    {
        //匹配话题字符串#...#
        NSString * regex = @"#([^\\#|.]+)#";
        NSRegularExpression * regularExpress = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
        //获取正则匹配的结果
        NSArray * arr = [regularExpress matchesInString:textView.text options:0 range:NSMakeRange(0, [textView.text length])];
        //如果匹配结果个数大于0，则计算当前删除的是不是话题
        if([arr count] > 0)
        {
            NSTextCheckingResult * last = [arr lastObject];
            NSRange lastRange = last.range;
            if(lastRange.location + lastRange.length >= range.location)
            {
                NSString * text = [textView.text substringToIndex:lastRange.location];
                textView.attributedText = [NSStringUtil makeTopicString:text];
            }
        }
        
        //匹配@用户
        regex = @"@[\\u4e00-\\u9fa5\\w\\-]+";
        regularExpress = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
        arr = [regularExpress matchesInString:textView.text options:0 range:NSMakeRange(0, [textView.text length])];
        if([arr count] > 0)
        {
            NSTextCheckingResult * last = [arr lastObject];
            NSRange lastRange = last.range;
            if(lastRange.location + lastRange.length >= range.location)
            {
                NSString * text = [textView.text substringToIndex:lastRange.location];
                textView.attributedText = [NSStringUtil makeTopicString:text];
            }
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.attributedText = [NSStringUtil makeTopicString:textView.text];
}


#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
    if(buttonIndex == 0)
    {
        self.parentCtrl.isNeedRefresh = YES;
        [self popVIewController];
        return ;
    }
    
    
    if(buttonIndex == 1)
    {
        if(alertView.tag == 1)
        {
            [self showAddBaby];
        }
        else if(alertView.tag == 2)
        {
            [self getBabys];
        }
        else if (alertView.tag == 3)
        {
            //将上传失败的图片重新上传
            if([_uploadFailImages count] > 0)
            {
                NSArray * tmp = [_uploadFailImages copy];
                for(NSString * path in tmp)
                {
                    [[QNUploadHelper sharedHelper] uploadFile:path];
                    [_uploadFailImages removeObject:path];
                }
                tmp = nil;
            }
        }
    }
}

@end
