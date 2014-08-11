//
//  PersonCenterViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "ControlCenter.h"
#import "PlatformBindViewController.h"
#import "MyGoodFriendsListViewController.h"
#import "MybabyListViewController.h"
#import "QRCodeCardViewController.h"

#import "UserDefault.h"
#import "HttpService.h"
#import "SVProgressHUD.h"

@interface PersonCenterViewController ()
{
    NSMutableArray *myBabyList;
}
@end

@implementation PersonCenterViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    users = [[UserDefault sharedInstance] userInfo];
    self.title = users.username;
    [self topViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initUI
{
    users = [[UserDefault sharedInstance] userInfo];
    self.title = users.username;
    [self setLeftCusBarItem:@"square_back" action:nil];
    [self babyCell];
    [self dynamicCell];
    [self goodFriendCell];
    [self twoDimensionCodeCell];
    [self myCollectionCell];
    [self socialPlatformBindCell];
    [self createFolder];
    [self topViewData];
}

- (void)topViewData
{
    _acountName.text = users.username;
    _wawaNum.text = users.sww_number;
    if (users.avatar!=nil) {
        _touXiangView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:users.avatar]]];
//        [UIImage imageWithContentsOfFile:users.avatar];
    }
    else
    {
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Avatar"] stringByAppendingPathComponent:@"avatar_DefaultPic.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        _touXiangView.image = savedImage;
    }
    UITapGestureRecognizer *touXiangImgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheetView)];
    [_touXiangView addGestureRecognizer:touXiangImgViewTap];
}
- (void)showActionSheetView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showFromRect:CGRectMake(0, 0, 320, 100) inView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 判断是否支持相机
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    switch (buttonIndex) {
        case 0:
            // 相机
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            // 相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            // 取消
            return;
    }
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
    
    [self getRandPictureName];
    
    [self saveImage:image withName:[NSString stringWithFormat:@"User_avatar_NumPic%i.png",randNum]];
     [_touXiangView setImage:image];
    NSString *fullPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/Avatar"] stringByAppendingPathComponent:[NSString stringWithFormat:@"User_avatar_NumPic%i.png",randNum]];
    users.avatar = fullPath;
    [[HttpService sharedInstance] updateUserInfo:@{@"user_id":users.uid,@"username":users.username,@"avatar":users.avatar,@"sex":users.sex,@"qq":[NSNull null],@"weibo":[NSNull null],@"wechat":[NSNull null]} completionBlock:^(id object) {
//        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        //[self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
   
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
//判断图片文件名字是否存在，是再随机，否直接跳出
- (void)getRandPictureName
{
    randNum = rand()/10000;
    NSString *dirName = @"Avatar";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir ;
    imageDir = [[NSString stringWithFormat:@"%@/%@", fullPath,dirName]stringByAppendingPathComponent:[NSString stringWithFormat:@"User_avatar_NumPic%i.png",randNum]];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed;
    existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    while (existed == YES && !isDir)
    {
        randNum = rand()/10000;
        imageDir = [[NSString stringWithFormat:@"%@/%@", fullPath,dirName]stringByAppendingPathComponent:[NSString stringWithFormat:@"User_avatar_NumPic%i.png",randNum]];
        existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    }
}
- (void)babyCell
{
    UILabel *babyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _babyButton.bounds.size.height-10)];
    babyLabel.backgroundColor = [UIColor clearColor];
    babyLabel.font = [UIFont systemFontOfSize:15];
    babyLabel.textColor = [UIColor darkGrayColor];
    [_babyButton addSubview:babyLabel];
    
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":users.uid}
                              completionBlock:^(id object) {
                                  
                                  myBabyList = [object objectForKey:@"result"];
                                babyLabel.text = [NSString stringWithFormat:@"宝宝 (%i)",[myBabyList count]];
                                  [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                              } failureBlock:^(NSError *error, NSString *responseString) {
                                  [SVProgressHUD showErrorWithStatus:responseString];
                              }];
    
    
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_babyButton.bounds.size.width-18, 15, 7, 11);
    [_babyButton addSubview:jianTou];
}

- (void)dynamicCell
{
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _dynamicButton.bounds.size.height-10)];
    dynamicLabel.backgroundColor = [UIColor clearColor];
    
    dynamicLabel.font = [UIFont systemFontOfSize:15];
    dynamicLabel.textColor = [UIColor darkGrayColor];
    [_dynamicButton addSubview:dynamicLabel];
    
    
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
        
        dynamicLabel.text = [NSString stringWithFormat:@"动态 (%i)",[object count]];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_dynamicButton.bounds.size.width-18, 15, 7, 11);
    [_dynamicButton addSubview:jianTou];
}

- (void)goodFriendCell
{
    UILabel *goodFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _goodFriendButton.bounds.size.height-10)];
    goodFriendLabel.backgroundColor = [UIColor clearColor];
    goodFriendLabel.text = [NSString stringWithFormat:@"好友 (%i)",32];
    goodFriendLabel.font = [UIFont systemFontOfSize:15];
    goodFriendLabel.textColor = [UIColor darkGrayColor];
    [_goodFriendButton addSubview:goodFriendLabel];
    
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_goodFriendButton.bounds.size.width-18, 15, 7, 11);
    [_goodFriendButton addSubview:jianTou];
}

- (void)twoDimensionCodeCell
{
    UILabel *twoDimensionCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _twoDimensionCodeButton.bounds.size.height-10)];
    twoDimensionCodeLabel.backgroundColor = [UIColor clearColor];
    twoDimensionCodeLabel.text = [NSString stringWithFormat:@"二维码名片"];
    twoDimensionCodeLabel.font = [UIFont systemFontOfSize:15];
    twoDimensionCodeLabel.textColor = [UIColor darkGrayColor];
    [_twoDimensionCodeButton addSubview:twoDimensionCodeLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_twoDimensionCodeButton.bounds.size.width-18, 15, 7, 11);
    [_twoDimensionCodeButton addSubview:jianTou];
}

- (void)myCollectionCell
{
 
    UILabel *myCollectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _myCollectionButton.bounds.size.height-10)];
    myCollectionLabel.backgroundColor = [UIColor clearColor];
    myCollectionLabel.text = [NSString stringWithFormat:@"我的收藏 (%i)",21];
    myCollectionLabel.font = [UIFont systemFontOfSize:15];
    myCollectionLabel.textColor = [UIColor darkGrayColor];
    [_myCollectionButton addSubview:myCollectionLabel];
    
    
    //获取收藏的宝宝动态
    [[HttpService sharedInstance] getFavorite:@{@"uid":users.uid,@"offset":@"0",@"pagesize":@"10"} completionBlock:^(id object) {
        myCollectionLabel.text = [NSString stringWithFormat:@"我的收藏 (%i)",[[object objectForKey:@"result"] count]];
        [SVProgressHUD showSuccessWithStatus:@"获取收藏成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_myCollectionButton.bounds.size.width-18, 15, 7, 11);
    [_myCollectionButton addSubview:jianTou];
}

- (void)socialPlatformBindCell
{
    UILabel *socialPlatformBindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _sheJianBar.bounds.size.height-10)];
    socialPlatformBindLabel.backgroundColor = [UIColor clearColor];
    socialPlatformBindLabel.text = [NSString stringWithFormat:@"社交平台绑定"];
    socialPlatformBindLabel.font = [UIFont systemFontOfSize:15];
    socialPlatformBindLabel.textColor = [UIColor darkGrayColor];
    [_sheJianBar addSubview:socialPlatformBindLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_sheJianBar.bounds.size.width-18, 15, 7, 11);
    [_sheJianBar addSubview:jianTou];
}

- (IBAction)showUserInfoPageVC:(id)sender
{
    [ControlCenter pushToUserInfoPageVC];
}

- (IBAction)showPlatformBind:(id)sender
{
    PlatformBindViewController *platformVC = [[PlatformBindViewController alloc] init];
    [self.navigationController pushViewController:platformVC animated:YES];
}
- (IBAction)changeImg:(id)sender {
}

- (IBAction)showGoodFriendListVC:(id)sender
{
    MyGoodFriendsListViewController *myGoodFriendListVC = [[MyGoodFriendsListViewController alloc] init];
    [self.navigationController pushViewController:myGoodFriendListVC animated:YES];
}

- (IBAction)showMyBabyListVC:(id)sender
{
    MybabyListViewController *myBabyListVC = [[MybabyListViewController alloc] init];
    [self.navigationController pushViewController:myBabyListVC animated:YES];
}

- (IBAction)showMyQRCardVC:(id)sender
{
    QRCodeCardViewController *qrCodeCardVC = [[QRCodeCardViewController alloc] init];
    [self.navigationController pushViewController:qrCodeCardVC animated:YES];
}

- (IBAction)showMyCollectionVC:(id)sender
{
    [ControlCenter pushToMyCollectionVC];
}
@end
