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

@interface ReleaseDynamic ()
{
    UIImageView *record_iconImgView;
    UILabel *timerLabel;
    NSTimer *timer;
    int times;
}
@end

@implementation ReleaseDynamic

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
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:_letPersonSawLabel.text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrString.length)];
    _letPersonSawLabel.attributedText = attrString;
    isSoundBar = NO;
    isShareBar = NO;
    _dy_contextTextField.delegate = self;
    [self copyOfWeb];
    times = 1;
    
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
    LocationsViewController *locationVC = [[LocationsViewController alloc] init];
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)releaseDy
{
    
    [[HttpService sharedInstance] publishRecord:@{@"baby_id":@"2",
                                                  @"uid":@"2",
                                                  @"visibility":@"1",
                                                  @"content":@"小猫小狗",
                                                  @"address":@"北京",
                                                  @"longitude":@"120",
                                                  @"latitude":@"30",
                                                  @"video":@"",
                                                  @"audio":@"",
                                                  @"image":@""} completionBlock:^(id object) {
                                                      [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
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

- (IBAction)showLocalFilm:(id)sender {
}

- (void)showLocalPhotoAndOther:(UIImagePickerControllerSourceType)sourceType
{
    // 判断是否支持相机
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库

    UIImagePickerController *imagePickerController =[[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
    [self saveImage:image withName:[NSString stringWithFormat:@"User_avatar_NumPic_%@.png",morelocationString]];
    //[_touXiangView setImage:image];
//    NSString *fullPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/Avatar"] stringByAppendingPathComponent:[NSString stringWithFormat:@"User_avatar_NumPic_%@.png",morelocationString]];
    
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

- (IBAction)showGrayTwoBtnView:(id)sender
{
    NSLog(@"呵呵");
    _grayTwoView.hidden = NO;
}
- (IBAction)hideGrayTwoView:(id)sender
{
    _grayTwoView.hidden = YES;
     NSLog(@"呵呵1");
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
}

- (IBAction)onlyFriendClick:(id)sender
{
    [self hideCanSeeView:nil];
}

- (IBAction)allPublicClick:(id)sender
{
    [self hideCanSeeView:nil];
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
}

- (IBAction)recordBtnUpEvent:(id)sender
{
    NSLog(@"松开了");
    [self hideXialaView:nil];
    [_huaTongButton setImage:[UIImage imageNamed:@"pd_xiaohuatong.png"] forState:UIControlStateNormal];
    [_huaTongButton setEnabled:NO];
    [record_iconImgView removeFromSuperview];
    [timer invalidate];
    NSLog(@"stopAtTime:%d",times);
    
    //pb_shanchu@2x.png
}

- (void)timerSecondAdd
{
   
    times ++;
    timerLabel.text = [NSString stringWithFormat:@"%d 秒",times];
    if (times == 16) {
        [timer invalidate];
        [self recordBtnUpEvent:nil];
    }
    
}
@end
