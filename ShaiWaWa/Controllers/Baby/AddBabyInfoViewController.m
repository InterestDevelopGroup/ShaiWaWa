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
