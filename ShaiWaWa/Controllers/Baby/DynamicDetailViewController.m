//
//  DynamicDetailViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-17.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "PinLunCell.h"
#import "DynamicHeadView.h"

#import "ShareView.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "DynamicRecord.h"
#import "RecordComment.h"

@interface DynamicDetailViewController ()

@end

@implementation DynamicDetailViewController
@synthesize r_id;
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
    isShareViewShown = NO;
    self.title = @"动态详情";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_pinLunListTableView clearSeperateLine];
    [_pinLunListTableView registerNibWithName:@"PinLunCell" reuseIdentifier:@"Cell"];
    UIImageView *scollBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 299, 145)];
    scollBgView.image = [UIImage imageNamed:@"square_pic-3.png"];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"baby_4-bg-2.png"];
    [_pinLunListTableView setBackgroundView:bgImgView];
    DynamicHeadView *dynamicHeadView = [[DynamicHeadView alloc] initWithFrame:CGRectMake(0, 0, _pinLunListTableView.bounds.size.width, 360)];
    [dynamicHeadView.imgOrVideoScrollView addSubview:scollBgView];
    [dynamicHeadView.moreButton addTarget:self action:@selector(showShareGrayView) forControlEvents:UIControlEventTouchUpInside];
    [_pinLunListTableView setTableHeaderView:dynamicHeadView];
    
    ShareView *sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    
    sv.deleteButton.hidden = YES;
    
    [sv setDeleteBlock:^(NSString *name){
        
    }];
    [_shareView addSubview:sv];
    
    pinLunArray = [[NSMutableArray alloc] init];

}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pinLunArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PinLunCell * pinLunListCell = (PinLunCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    /*
     // 取当前section，设置单元格显示内容。
     NSInteger section = indexPath.section;
     // 获取这个分组的省份名称，再根据省份名称获得这个省份的城市列表。
     NSString *sectionType = [sectionArr objectAtIndex:section];
     NSArray *list = [babyList objectForKey:sectionType];
     [list objectAtIndex:indexPath.row];
     */
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    //    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    
    return pinLunListCell;
    
}
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [textField becomeFirstResponder];
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
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 解决虚拟键盘挡住UITextField的方法
- (void)keyboardWillShow:(NSNotification *)noti
{
 //键盘输入的界面调整
 //键盘的高度
 float height = 216.0;
 CGRect frame = self.view.frame;
 frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
 [UIView beginAnimations:@"Curl"context:nil];//动画开始
 [UIView setAnimationDuration:0.30];
 [UIView setAnimationDelegate:self];
 [self.view setFrame:frame];
 [UIView commitAnimations];
     
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset;
        if (self.view.bounds.size.height > 490.0)
        {
            offset = frame.origin.y + 428 - self.view.frame.size.height - 216;
        }
        else
        {
            offset = frame.origin.y + 500 - self.view.frame.size.height - 216;
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
}
- (void)showShareGrayView
{
    if (!isShareViewShown) {
        _grayShareView.hidden = NO;
        isShareViewShown = YES;
    }
    else
    {
        _grayShareView.hidden = YES;
        isShareViewShown = NO;
    }
}
- (IBAction)hideGrayShareV:(id)sender
{
    _grayShareView.hidden = YES;
    isShareViewShown = NO;
}
- (IBAction)pinLunEvent:(id)sender
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] addComment:@{@"rid":r_id,
                                               @"uid":users.uid,
                                               @"reply_id":@"",
                                               @"content":_pinLunContextTextField.text}
                             completionBlock:^(id object) {
                                 NSLog(@"object:%@",object);
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}
@end
