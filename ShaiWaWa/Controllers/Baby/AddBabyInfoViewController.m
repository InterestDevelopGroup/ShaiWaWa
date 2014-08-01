//
//  AddBabyInfoViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AddBabyInfoViewController.h"
#import "UIViewController+BarItemAdapt.h"

@interface AddBabyInfoViewController ()

@end

@implementation AddBabyInfoViewController

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
    self.title = @"添加宝宝";
    [self setLeftCusBarItem:@"square_back" action:nil];
    isBoy = YES;
    isMon = YES;
    isGirl = NO;
    isDad = NO;
    _scrollView.contentSize = CGSizeMake(_addView.bounds.size.width, _addView.bounds.size.height);
    [_scrollView addSubview:_addView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.frame = CGRectMake(0, 0, 40, 30);
    [addButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *right_add = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = right_add;
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_cityButton.bounds.size.width-18, 15, 7, 11);
    [_cityButton addSubview:jianTou];
    
    [self createFolder];
}

- (IBAction)boySelected:(id)sender
{
    isBoy = YES;
    [_boyRadioButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
    isGirl = NO;
    [_girlRadioButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
}

- (IBAction)girlSelected:(id)sender
{
    isBoy = NO;
    [_boyRadioButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    isGirl = YES;
    [_girlRadioButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
}

- (IBAction)monSelected:(id)sender
{
    isMon = YES;
    [_monRadioButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
    isDad = NO;
    [_dadRadioButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
}

- (IBAction)dadSelected:(id)sender
{
    isMon = NO;
    [_monRadioButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    isDad = YES;
    [_dadRadioButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
}

- (IBAction)openCitiesSelectView:(id)sender
{
}

- (IBAction)touXiangSelectEvent:(id)sender
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
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cheung"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [_touXiangButton setImage:savedImage forState:UIControlStateNormal];
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
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cheung"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
//NSData * UIImageJPEGRepresentation ( UIImage *image, CGFloat compressionQuality
//创建沙盒下文件夹
- (void)createFolder
{
    NSString *dirName = @"Cheung";
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
//删除文件夹及文件级内的文件：
//NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/%@", NSHomeDirectory(), dirName];
//NSFileManager *fileManager = [NSFileManager defaultManager];
//[fileManager removeItemAtPath:imageDir error:nil];
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _babyNicknameField) {
    [_birthDayField becomeFirstResponder];
        return NO;
    }
    if (textField == _babyNameField) {
        [_birthStatureField becomeFirstResponder];
        return NO;
    }
    if (textField == _birthStatureField) {
        [_birthWeightField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _birthWeightField) {
        _scrollView.contentOffset = CGPointMake(0, 296);
    }
    if (textField == _birthStatureField) {
         _scrollView.contentOffset = CGPointMake(0, 246);
    }
    if (textField == _babyNameField) {
        _scrollView.contentOffset = CGPointMake(0, 246);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _birthWeightField) {
        _scrollView.contentOffset = CGPointMake(0, 58);
    }
    else
    {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_babyNicknameField resignFirstResponder];
    [_birthDayField resignFirstResponder];
    [_babyNameField resignFirstResponder];
    [_birthStatureField resignFirstResponder];
    [_birthWeightField resignFirstResponder];
}
@end
