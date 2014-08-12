//
//  ReleaseDynamicViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ReleaseDynamic.h"
#import "UIViewController+BarItemAdapt.h"
#import "TopicViewController.h"
#import "LocationsViewController.h"
#import "ChooseFriendViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "DynamicRecord.h"

#import "BabySelectListViewController.h"

#import "VoiceConverter.h"

@interface ReleaseDynamic ()
{
    UIImageView *record_iconImgView;
    UILabel *timerLabel;
    NSTimer *timer;
    int times;
    NSString *visible;
    NSString *dyLatitude;
    NSString *dyLongitude;
    NSString *babyID;
    UIImagePickerController *pickerPhotoView;
    UIImagePickerController *pickerCamerView;
    AVAudioRecorder *recorder;
    NSURL *recordedFile;
    AVAudioPlayer *player;
    NSArray *imgArray;
    NSMutableArray *imagesArray;
    NSMutableArray *imageViewArray;
    
}
@property (nonatomic, strong) NSString *babyID;
@end

@implementation ReleaseDynamic
@synthesize babyID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initUI
{
    
    
    self.title = @"发表动态";
    [self setLeftCusBarItem:@"square_back" action:nil];
    self.navigationItem.rightBarButtonItem = [self customBarItem:@"pb_fabu" action:@selector(releaseDy) size:CGSizeMake(57, 27)];
     [self labelUnderLine];
    
    isSoundBar = NO;
    isShareBar = NO;
    _dy_contextTextField.delegate = self;
    [self copyOfWeb];
    times = 1;
    
    imgArray = [[NSArray alloc] init];
    imagesArray = [[NSMutableArray alloc] init];
    imageViewArray = [[NSMutableArray alloc] init];
    [self getBabyView];
    NSString *temp = [NSTemporaryDirectory() stringByAppendingString:@"RecordedFile.wav"];
    
    recordedFile = [NSURL fileURLWithPath:temp];
    
//    recordedFile = [NSURL fileURLWithPath:[VoiceConverter wavToAmr:temp]];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
}




- (IBAction)showTopicVC:(id)sender
{
    
    TopicViewController *topicVC = [[TopicViewController alloc] init];
    [self.navigationController pushViewController:topicVC animated:YES];
}

- (IBAction)showChooseFriendVC:(id)sender
{
    ChooseFriendViewController *chooseFriendsVC = [[ChooseFriendViewController alloc] init];
    [self.navigationController pushViewController:chooseFriendsVC animated:YES];
}
- (IBAction)showDroSoundBar:(id)sender
{
    if (!isSoundBar) {
        
        if (isShareBar) {
            _topView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 34);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 46);
            _xialaGrayV.hidden = NO;
            _soundXiaView.hidden = NO;
            _shareXiaView.hidden = YES;
            isShareBar = NO;
            isSoundBar = YES;
        }
        else
        {
            _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height - 34);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 46);
            _xialaGrayV.hidden = NO;
            _soundXiaView.hidden = NO;
            isSoundBar = YES;
        }
       
    }
    else
    {
        _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 46);
        _xialaGrayV.hidden = YES;
        _soundXiaView.hidden = YES;
        isSoundBar = NO;
    }
}

- (IBAction)showSynShareBar:(id)sender
{
    
    if (!isShareBar) {
        
        if (isSoundBar) {
            _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height - 34);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 46);
            _xialaGrayV.hidden = NO;
            _soundXiaView.hidden = YES;
            _shareXiaView.hidden = NO;
            isShareBar = YES;
            isSoundBar = NO;
        }
        else
        {
            _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height - 34);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 46);
            _xialaGrayV.hidden = NO;
            _shareXiaView.hidden = NO;
            isShareBar = YES;
        }
        
    }
    else
    {
        _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 46);
        _xialaGrayV.hidden = YES;
        _shareXiaView.hidden = YES;
        isShareBar = NO;
    }
    
   
}

- (IBAction)showLocationVC:(id)sender
{
    
    __block __weak ReleaseDynamic *rself = self;
    LocationsViewController *locationVC = [[LocationsViewController alloc] init];
    
    [locationVC setAddressStrBlock:^(NSString *address)
     {
         [rself.addr_Label setText:address];
     }];
    
    [locationVC setLatitudeStrBlock:^(NSString *latitude)
     {
         dyLatitude = latitude;
     }];
    [locationVC setLongitudeStrBlock:^(NSString *longitude)
     {
         dyLongitude = longitude;
     }];
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)releaseDy
{
//    __block __weak ReleaseDynamic *rself = self;
     visible = [_letPersonSawLabel.text isEqualToString:@"仅父母可见"] ? @"1" : ([_letPersonSawLabel.text isEqualToString:@"仅朋友可见"] ? @"2" : @"3");
    
    __block NSString *dyAdress;
    if ([_addr_Label.text isEqualToString:@"添加位置"]) {
        dyAdress = @"";
    }
    else
    {
        dyAdress =_addr_Label.text;
    }
    [[HttpService sharedInstance] publishRecord:@{@"baby_id":babyID.length > 0 ? babyID : @"2",
                                                  @"uid":@"2",
                                                  @"visibility":visible,
                                                  @"content":_dyContextTextView.text,
                                                  @"address":dyAdress,
                                                  @"longitude":[_addr_Label.text isEqualToString:@"添加位置"] ? @"" : dyLongitude,
                                                  @"latitude":[_addr_Label.text isEqualToString:@"添加位置"] ? @"" : dyLatitude,
                                                  @"video":@"",
                                                  @"audio":@"",
                                                  @"image":@""} completionBlock:^(id object) {
                                                      [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}
- (IBAction)showLocalPhoto:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self showLocalPhotoAndOther:sourceType];
}

- (IBAction)showLocalCamer:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    sourceType = UIImagePickerControllerSourceTypeCamera;
    [self showLocalPhotoAndOther:sourceType];
}

- (IBAction)showLocalFilm:(id)sender
{
    pickerCamerView = [[UIImagePickerController alloc] init];
    pickerCamerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerCamerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    [self presentViewController:pickerCamerView animated:YES completion:^{}];
    pickerCamerView.videoMaximumDuration = 20;
    pickerCamerView.delegate = self;
    [pickerCamerView setShowsCameraControls:NO];
    
    //[pickerCamerView.view addSubview:];
    
}

- (void)showLocalPhotoAndOther:(UIImagePickerControllerSourceType)sourceType
{
    // 判断是否支持相机
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库

    pickerPhotoView =[[UIImagePickerController alloc] init];
    
    pickerPhotoView.delegate = self;
    
    pickerPhotoView.allowsEditing = YES;
    
    pickerPhotoView.sourceType = sourceType;
    [self presentViewController:pickerPhotoView animated:YES completion:^{}];
    [self hideGrayTwoView:nil];
}

//点击相册中的图片 或照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 保存图片至本地，方法见下文
        //    [self getRandPictureName];
        //获得系统时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        //    [dateformatter setDateFormat:@"HH:mm"];
        //    NSString *  locationString=[dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
        NSString *  morelocationString=[dateformatter stringFromDate:senddate];
        
        [imagesArray addObject:image];
        //    [imageViewArray removeAllObjects];
        for(int i=[imageViewArray count]; i<[imagesArray count]; i++)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[imagesArray objectAtIndex:i]];
            [imageViewArray addObject:imgView];
        }
        
        [self showImageViewToScrollView];
        
        [self saveImage:image withName:[NSString stringWithFormat:@"User_avatar_NumPic_%@.png",morelocationString]];
        //[_touXiangView setImage:image];
        //    NSString *fullPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/Avatar"] stringByAppendingPathComponent:[NSString stringWithFormat:@"User_avatar_NumPic_%@.png",morelocationString]];
    
        [picker setShowsCameraControls:NO];
        NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
        //    [info objectForKey:UIImagePickerControllerMediaURL] == info[UIImagePickerControllerMediaURL];
        //    [info valueForKey:UIImagePickerControllerMediaURL];
        NSLog(@"%@",[videoUrl absoluteString]);
    

       [picker dismissViewControllerAnimated:YES completion:^{}];

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Avatar"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
//NSData * UIImageJPEGRepresentation ( UIImage *image, CGFloat compressionQuality
//创建沙盒下文件夹
- (void)createFolder
{
    NSString *dirName = @"Avatar";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [NSString stringWithFormat:@"%@/%@", fullPath,dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)delImage:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    [self removeImgView:button.tag];
  
}

- (void)removeImgView:(int)num
{
    [[imageViewArray objectAtIndex:num] removeFromSuperview];
    [imageViewArray removeObjectAtIndex:num];
    [imagesArray removeObjectAtIndex:num];
    
    NSString *fontStr = @"添加更多 (";
    NSString *midStr = [NSString stringWithFormat:@"%d",[imageViewArray count]];
    NSString *lastStr = @"/9)";
    if ([imageViewArray count] == 0 || [imageViewArray count] == 9) {
        _addMoreMediaButton.hidden = YES;
        _scrollSubView.hidden = NO;
        [imageViewArray removeAllObjects];
        [imagesArray removeAllObjects];
    }
    else
    {
        _addMoreMediaButton.hidden = NO;
        _scrollSubView.hidden = YES;
    }
    [_addMoreMediaButton setTitle:[[fontStr stringByAppendingString:midStr] stringByAppendingString:lastStr] forState:UIControlStateNormal];
    for (int k=0; k<[imageViewArray count]; k++) {
        [[imageViewArray objectAtIndex:k] setUserInteractionEnabled:YES];
        _scrollViewForMedia.contentSize = CGSizeMake(298*(k+1), 123);
        [[imageViewArray objectAtIndex:k] setFrame:CGRectMake(120*k+5, 10, 100, _scrollViewForMedia.bounds.size.height-20)];
        [_scrollViewForMedia addSubview:[imageViewArray objectAtIndex:k]];
        UIButton *delButton= [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.frame = CGRectMake([[imageViewArray objectAtIndex:k] bounds].size.width-15, -8, 25, 26);
        [delButton addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
        [[imageViewArray objectAtIndex:k] addSubview:delButton];
        delButton.tag = k;
        [delButton setImage:[UIImage imageNamed:@"pb_shanchu.png"] forState:UIControlStateNormal];
    }
    
    /*
    NSLog(@"按钮tag:%d",num);
    NSLog(@"图片个数：%d",[imagesArray count]);
    for (int j=0; j<[imagesArray count]; j++) {
        UIImageView *imgView = (UIImageView *)[_scrollViewForMedia viewWithTag:j+2999];
        [imgView removeFromSuperview];
        if (j == [imagesArray count]-1) {
            [_scrollViewForMedia setContentSize:CGSizeMake(298, 123)];
            _scrollSubView.hidden = NO;
            _addMoreMediaButton.hidden = YES;
        }
        
    }
    
     */
//    
//     [[imageViewArray objectAtIndex:num] removeFromSuperview];
//     [imagesArray removeObjectAtIndex:num];
}

- (void)showImageViewToScrollView
{
    for (int j=0; j<[imageViewArray count]; j++) {
        [[imageViewArray objectAtIndex:j] removeFromSuperview];
        if (j == [imagesArray count]-1) {
            [_scrollViewForMedia setContentSize:CGSizeMake(298, 123)];
            _scrollSubView.hidden = NO;
            _addMoreMediaButton.hidden = YES;
        }
        
    }
    
    
    for (int k=0; k<[imageViewArray count]; k++) {
        [[imageViewArray objectAtIndex:k] setUserInteractionEnabled:YES];
    _scrollViewForMedia.contentSize = CGSizeMake(298*(k+1), 123);
        [[imageViewArray objectAtIndex:k] setFrame:CGRectMake(120*k+5, 10, 100, _scrollViewForMedia.bounds.size.height-20)];
    [_scrollViewForMedia addSubview:[imageViewArray objectAtIndex:k]];
        UIButton *delButton= [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.frame = CGRectMake([[imageViewArray objectAtIndex:k] bounds].size.width-15, -8, 25, 26);
        [delButton addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
        [[imageViewArray objectAtIndex:k] addSubview:delButton];
        delButton.tag = k;
        [delButton setImage:[UIImage imageNamed:@"pb_shanchu.png"] forState:UIControlStateNormal];
    }
    
    
    
    NSString *fontStr = @"添加更多 (";
    NSString *midStr = [NSString stringWithFormat:@"%d",[imagesArray count]];
    NSString *lastStr = @"/9)";
    if ([imageViewArray count] == 0 || [imageViewArray count] == 9) {
        _addMoreMediaButton.hidden = YES;
        _scrollSubView.hidden = NO;
    }
    else
    {
        _addMoreMediaButton.hidden = NO;
        _scrollSubView.hidden = YES;
    }
    [_addMoreMediaButton setTitle:[[fontStr stringByAppendingString:midStr] stringByAppendingString:lastStr] forState:UIControlStateNormal];
}
- (void)getImageFromPublic
{
    for (int k=0; k<[imagesArray count]; k++) {
        _scrollViewForMedia.contentSize = CGSizeMake(298*(k+1), 123);
        UIImageView *imgOne = [[UIImageView alloc] init];
        [imgOne setUserInteractionEnabled:YES];
        
        UIButton *delButton= [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.frame = CGRectMake(imgOne.bounds.size.width-15, -8, 25, 26);
        [delButton addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
        [imgOne addSubview:delButton];
        delButton.tag = k;
        [delButton setImage:[UIImage imageNamed:@"pb_shanchu.png"] forState:UIControlStateNormal];
        imgOne.image = [imagesArray objectAtIndex:k];
        [imageViewArray addObject:imgOne];
        
        [[imageViewArray objectAtIndex:k] setFrame:CGRectMake(120*k+5, 10, 100, _scrollViewForMedia.bounds.size.height-20)];
        [_scrollViewForMedia addSubview:[imageViewArray objectAtIndex:k]];
    }
    NSString *fontStr = @"添加更多 (";
    NSString *midStr = [NSString stringWithFormat:@"%d",[imagesArray count]];
    NSString *lastStr = @"/9)";
    if ([imagesArray count] == 0 || [imagesArray count] == 9) {
        _addMoreMediaButton.hidden = YES;
        _scrollSubView.hidden = NO;
    }
    else
    {
        _addMoreMediaButton.hidden = NO;
        _scrollSubView.hidden = YES;
    }
    [_addMoreMediaButton setTitle:[[fontStr stringByAppendingString:midStr] stringByAppendingString:lastStr] forState:UIControlStateNormal];
    
    /*
  
    
    for (int i=0; i<[imagesArray count]; i++) {
        _scrollViewForMedia.contentSize = CGSizeMake(298*(i+1), 123);
        UIImageView *imgOne = [[UIImageView alloc] initWithFrame:CGRectMake(120*i+5, 10, 100, _scrollViewForMedia.bounds.size.height-20)];
        imgOne.tag = 2999+i;
        [imgOne setUserInteractionEnabled:YES];
        UIButton *delButton= [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.frame = CGRectMake(imgOne.bounds.size.width-15, -8, 25, 26);
        delButton.tag = 1999+i;
        [delButton addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
        [imgOne addSubview:delButton];
        [delButton setImage:[UIImage imageNamed:@"pb_shanchu.png"] forState:UIControlStateNormal];
        imgOne.image = [imagesArray objectAtIndex:i];
        
        NSString *fontStr = @"添加更多 (";
        NSString *midStr = [NSString stringWithFormat:@"%d",[imagesArray count]];
        NSString *lastStr = @"/9)";
        if ([imagesArray count] == 0 || [imagesArray count] == 9) {
            _addMoreMediaButton.hidden = YES;
            _scrollSubView.hidden = NO;
        }
        else
        {
            _addMoreMediaButton.hidden = NO;
            _scrollSubView.hidden = YES;
        }
        [_addMoreMediaButton setTitle:[[fontStr stringByAppendingString:midStr] stringByAppendingString:lastStr] forState:UIControlStateNormal];
        [_scrollViewForMedia addSubview:imgOne];
    }
     */
}

- (IBAction)showGrayTwoBtnView:(id)sender
{
    
    _grayTwoView.hidden = NO;
}
- (IBAction)hideGrayTwoView:(id)sender
{
    _grayTwoView.hidden = YES;
}
- (IBAction)hideCanSeeView:(id)sender
{
    _canSeeView.hidden = YES;
    _canSeeView_4s.hidden = YES;
}

- (IBAction)showCanSeeView:(id)sender
{
    _canSeeView.hidden = NO;
    _canSeeView_4s.hidden = NO;
}

- (IBAction)onlyParentClick:(id)sender
{
    [self hideCanSeeView:nil];
    _letPersonSawLabel.text = @"仅父母可见";
     [self labelUnderLine];
}

- (IBAction)onlyFriendClick:(id)sender
{
    [self hideCanSeeView:nil];
    _letPersonSawLabel.text = @"仅朋友可见";
    [self labelUnderLine];
}

- (IBAction)allPublicClick:(id)sender
{
    [self hideCanSeeView:nil];
    _letPersonSawLabel.text = @"所有人公开";
     [self labelUnderLine];
}
- (IBAction)hideXialaView:(id)sender
{
    if (isSoundBar) {
        _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
        _xialaGrayV.hidden = YES;
        _soundXiaView.hidden = YES;
        isSoundBar = NO;
    }
    if (isShareBar) {
        _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
        _xialaGrayV.hidden = YES;
        _shareXiaView.hidden = YES;
        isShareBar = NO;
    }
}

#pragma mark -- textView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect frame = _dy_contextTextField.frame;
    
    int offset;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        if (self.view.bounds.size.height > 480.0) {
            offset = frame.origin.y + 342 - (self.view.frame.size.height - 216.0);//键盘高度216
        }else
        {
            offset = frame.origin.y + 282 - (self.view.frame.size.height - 216.0);//键盘高度216
            
        }
    }
    else
    {
        if (self.view.bounds.size.height < 480.0) {
            offset = frame.origin.y + 342 - (self.view.frame.size.height - 216.0);//键盘高度216
        }else
        {
            offset = frame.origin.y + 362 - (self.view.frame.size.height - 216.0);//键盘高度216
            
        }
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    CGRect rect;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect = CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
    
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}
- (void)copyOfWeb
{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UITextField *temp_txt = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
    temp_txt.hidden = YES;
    UIBarButtonItem * txtItem =[[UIBarButtonItem  alloc] initWithCustomView:temp_txt];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:txtItem,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    //    [textView setInputView:topView];
    
    [_dy_contextTextField setInputAccessoryView:topView];
//    topView.hidden = YES;
}


//隐藏键盘
-(void)resignKeyboard
{
    [_dy_contextTextField resignFirstResponder];
}

- (IBAction)recordBtnDownEvent:(id)sender
{

    record_iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 90, 151, 150)];
    [record_iconImgView setImage:[UIImage imageNamed:@"pd_huatong.png"]];
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 50, 30)];
    timerLabel.text = [NSString stringWithFormat:@"%d 秒",times];
    timerLabel.textColor = [UIColor colorWithRed:104/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
    timerLabel.backgroundColor = [UIColor clearColor];
    [record_iconImgView addSubview:timerLabel];
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:times target:self selector:@selector(timerSecondAdd) userInfo:nil repeats:YES];
    [_xialaGrayV addSubview:record_iconImgView];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
    [recorder prepareToRecord];
    [recorder record];
    
}

- (IBAction)recordBtnUpEvent:(id)sender
{
    NSLog(@"松开了");
    [self hideXialaView:nil];
    [_huaTongButton setImage:[UIImage imageNamed:@"pd_xiaohuatong.png"] forState:UIControlStateNormal];
    [_huaTongButton setEnabled:NO];
    [record_iconImgView removeFromSuperview];
    [timer invalidate];
    
    _playButton.hidden = NO;
    [_playButton setTitle:[NSString stringWithFormat:@" %d''",times] forState:UIControlStateNormal];
    _deleteVoiceButton.hidden = NO;
    
    [recorder stop];
    recorder = nil;
    
    NSError *playerError;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
    
    if (player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    player.delegate = self;
    
}

- (void)timerSecondAdd
{
   
    times ++;
    timerLabel.text = [NSString stringWithFormat:@"%d 秒",times];
    if (times == 60) {
        [timer invalidate];
        [self recordBtnUpEvent:nil];
    }
    
}

- (IBAction)playVoiceEvent:(id)sender
{
    NSLog(@"点播放啦");
    [player play];
}

- (IBAction)deleteVoiceEvent:(id)sender
{
    
    _playButton.hidden = YES;
    
    _deleteVoiceButton.hidden = YES;
    _huaTongButton.enabled = YES;
    [_huaTongButton setImage:[UIImage imageNamed:@"pb_logo-3.png"] forState:UIControlStateNormal];
    times = 1;
}

#pragma mark -- Label下划线
- (void)labelUnderLine
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:_letPersonSawLabel.text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrString.length)];
    _letPersonSawLabel.attributedText = attrString;
}
- (IBAction)changeAnotherBaby:(id)sender
{
    if (_babySelectJianTouImgView.hidden) {
        return;
    }
    else
    {
    __block __weak ReleaseDynamic *rself = self;
    BabySelectListViewController *babySelectVC = [[BabySelectListViewController alloc] init];
    [babySelectVC setBabyAvatarBlock:^(NSString *babyAvatar){
        _babyAvatarImgView.image = [UIImage imageWithContentsOfFile:babyAvatar];
    }];
    [babySelectVC setBabyIdBlock:^(NSString *babyId){
        rself.babyID = babyId;
    }];
    [babySelectVC setBabyNameBlock:^(NSString *babyName){
        _babyNameLabel.text = babyName;
    }];
    [self.navigationController pushViewController:babySelectVC animated:NO];
    }
}

#pragma mark -- 获取宝宝列表（如果宝宝个数为1时，不显示箭头,且点击视图手势没反应）
- (void)getBabyView
{
    __block __weak ReleaseDynamic *rself = self;
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":user.uid}
                              completionBlock:^(id object) {
                                  if ([[object objectForKey:@"result"] count] > 1) {
                                      _babySelectJianTouImgView.hidden = NO;
                                      
                                  }
                                  else
                                  {
                                      _babySelectJianTouImgView.hidden = YES;
                                  }
                                  rself.babyID = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"baby_id"];
                                  rself.babyAvatarImgView.image = [UIImage imageWithContentsOfFile: [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]];
                                  rself.babyNameLabel.text = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"baby_name"];
                              } failureBlock:^(NSError *error, NSString *responseString) {
                                  NSString * msg = responseString;
                                  if (error) {
                                      msg = @"加载失败";
                                  }
                                  [SVProgressHUD showErrorWithStatus:msg];
                              }];
}

@end
