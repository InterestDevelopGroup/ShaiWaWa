//
//  AddHeightAndWeightViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AddHeightAndWeightViewController.h"
#import "UIViewController+BarItemAdapt.h"
@interface AddHeightAndWeightViewController ()

@end

@implementation AddHeightAndWeightViewController

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
    self.title = @"添加身高体重";
    [self setLeftCusBarItem:@"square_back" action:nil];
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _heightField) {
        [_weightField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)timeSelected:(id)sender {
}

- (IBAction)add_OK:(id)sender {
}
@end
