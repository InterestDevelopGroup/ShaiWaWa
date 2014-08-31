//
//  AddBabyInfoViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AddBabyInfoViewController.h"
#import "UIViewController+BarItemAdapt.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "AppMacros.h"
#import "QNUploadHelper.h"
#import "InputHelper.h"
@interface AddBabyInfoViewController ()<UIAlertViewDelegate>
{
    BabyInfo *baby;
    TSLocateView *locateView;
    TSLocation *location;
    NSString *imageFullUrlStr;
}
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [addButton addTarget:self action:@selector(addBaby) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right_add = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = right_add;
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_cityButton.bounds.size.width-18, 15, 7, 11);
    [_cityButton addSubview:jianTou];
    
    

    

}



- (void)addBaby
{
    
    NSString * babyName = [InputHelper trim:_babyNicknameField.text];
    NSString * birthday = [InputHelper trim:_birthDayField.text];
    
    if([InputHelper isEmpty:babyName])
    {
        [SVProgressHUD showErrorWithStatus:@"宝宝名称不能为空."];
        return ;
    }
    
    if([InputHelper isEmpty:birthday])
    {
        [SVProgressHUD showErrorWithStatus:@"出生日期不能为空."];
        return ;
    }
    
    
    //先判断是否有头像，如果有先上传到七牛.
    if(imageFullUrlStr != nil)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[QNUploadHelper sharedHelper] setUploadFailure:^(NSString * path){
        
            [SVProgressHUD dismiss];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片上传失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            [alertView show];
            alertView = nil;
        }];
        
        [[QNUploadHelper sharedHelper] setUploadSuccess:^(NSString * path){
            imageFullUrlStr = [NSString stringWithFormat:@"%@%@",QN_URL,[path lastPathComponent]];
            [self submitBabyInfo];
        }];
        
        [[QNUploadHelper sharedHelper] uploadFile:imageFullUrlStr];
        return ;
    }
    
    [self submitBabyInfo];
    
    /*
    @{@"uid":user.uid,@"fid":isDad ? user.uid : @"",@"mid":isMon ? user.uid : @"",@"baby_name":_babyNameField.text,@"avatar":![imageFullUrlStr isEqual:[NSNull null]] ? imageFullUrlStr : @"",@"sex":isBoy ? @"1" : @"0",@"birthday":_birthDayField.text,
      @"nickname":_babyNicknameField.text,
      @"birth_height":_birthStatureField.text,
      @"birth_weight":_birthWeightField.text,
      @"country":@"中国",
      @"province":location.state,
      @"city":location.city}
     */

}

- (void)submitBabyInfo
{
    NSString * babyName = [InputHelper trim:_babyNicknameField.text];
    NSString * birthday = [InputHelper trim:_birthDayField.text];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"uid"] = user.uid;
    params[@"fid"] = isDad ? user.uid : @"";
    params[@"mid"] = isMon ? user.uid : @"";
    params[@"baby_name"] = _babyNameField.text != nil ? _babyNameField.text : @"";
    params[@"avatar"] = imageFullUrlStr != nil ? imageFullUrlStr : @"";
    params[@"sex"] = isBoy? @"1" : @"0";
    params[@"nickname"] = babyName;
    params[@"birthday"] = birthday;
    params[@"birth_height"] = _birthStatureField.text != nil ? _birthStatureField.text : @"";
    params[@"birth_weight"] = _birthWeightField.text != nil ? _birthWeightField.text : @"";
    params[@"country"] = @"中国";
    params[@"province"] = location.state != nil ? location.state : @"";
    params[@"city"] =  location.city != nil ? location.city : @"";
    [[HttpService sharedInstance] addBaby:params completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self clearTextField];
        [self resetStatus];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];

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
    
    locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
    locateView.tag = 11111;
    [locateView showInView:self.view];
}

- (IBAction)touXiangSelectEvent:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showFromRect:CGRectMake(0, 0, 320, 100) inView:self.view animated:YES];
}

- (void)clearTextField
{
    imageFullUrlStr = nil;
    _babyNameField.text = nil;
    _birthDayField.text = nil;
    _babyNicknameField.text = nil;
    _birthStatureField.text = nil;
    _birthWeightField.text = nil;
    _cityValueTextField.text = nil;
}

- (void)resetStatus
{
    [self boySelected:nil];
    [self monSelected:nil];
    [_touXiangButton setImage:[UIImage imageNamed:@"main_baobaotouxiang.png"] forState:UIControlStateNormal];
}



#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 11111)
    {
       locateView  = (TSLocateView *)actionSheet;
        location = locateView.locate;
        
        _cityValueTextField.text = [[location.state stringByAppendingString:@" "] stringByAppendingString:location.city];
        NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
        
        //You can uses location to your application.
        if(buttonIndex == 0) {
            NSLog(@"Cancel");
        }else {
            NSLog(@"Select");
        }
    }
    else
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
}

//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString * fileName = [[IO generateRndString] stringByAppendingPathExtension:@"png"];
    NSString *fullPath = [IO pathForResource:fileName inDirectory:Avatar_Folder];
    if(![IO writeFileToPath:fullPath withData:UIImagePNGRepresentation(image)])
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败."];
        return ;
    }

    [_touXiangButton setImage:[image ellipseImageWithDefaultSetting] forState:UIControlStateNormal];
    imageFullUrlStr = fullPath;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


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

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return ;
    }
    
    [self addBaby];
}

@end
