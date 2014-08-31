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
#import "ShareView.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "RecordComment.h"
#import "DynamicDetailCell.h"
#import "AppMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSStringUtil.h"

@interface DynamicDetailViewController ()

@end

@implementation DynamicDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods
- (void)initUI
{
    isShareViewShown = NO;
    self.title = @"动态详情";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_pinLunListTableView clearSeperateLine];
    [_pinLunListTableView registerNibWithName:@"PinLunCell" reuseIdentifier:@"PinLunCell"];
    [_pinLunListTableView registerNibWithName:@"DynamicDetailCell" reuseIdentifier:@"DynamicDetailCell"];
    UIImageView *scollBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 299, 145)];
    scollBgView.image = [UIImage imageNamed:@"square_pic-3.png"];
   
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"baby_4-bg-2.png"];
    [_pinLunListTableView setBackgroundView:bgImgView];
    
    ShareView *sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    
    sv.deleteButton.hidden = YES;
    
    [sv setDeleteBlock:^(){
        
    }];
    [_shareView addSubview:sv];
    
    pinLunArray = [[NSMutableArray alloc] init];
    
    [_pinLunListTableView addHeaderWithTarget:self action:@selector(refresh)];
    [_pinLunListTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_pinLunListTableView headerBeginRefreshing];

}

//下拉刷新数据
- (void)refresh
{
    [self getComments];
}

//请求评论列表
- (void)getComments
{
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] getCommentList:@{@"rid":_babyRecord.rid,@"offset":@"0",@"pagesize":@"200"} completionBlock:^(id object) {
        //[SVProgressHUD dismiss];
        pinLunArray = object;
        [_pinLunListTableView reloadData];
        [_pinLunListTableView headerEndRefreshing];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"获取评论失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_pinLunListTableView headerEndRefreshing];
    }];
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

- (void)likeAction:(id)sender
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(user == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return ;
    }
    [[HttpService sharedInstance] addLike:@{@"rid":_babyRecord.rid,@"uid":user.uid} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"谢谢您的参与."];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"请求失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)pinLunEvent:(id)sender
{
    [_pinLunContextTextField resignFirstResponder];
    if([_pinLunContextTextField.text length] == 0)
    {
        return ;
    }
    
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] addComment:@{@"rid":_babyRecord.rid,@"uid":users.uid,@"reply_id":@"",@"content":_pinLunContextTextField.text} completionBlock:^(id object) {
        //发布成功
        _pinLunContextTextField.text = @"";
        [SVProgressHUD showSuccessWithStatus:@"评论成功,谢谢您的参与."];
        //重新刷新数据
        [_pinLunListTableView headerBeginRefreshing];
    } failureBlock:^(NSError *error, NSString *responseString) {
         NSString * msg = responseString;
         if (error) {
             msg = @"评论失败";
         }
         [SVProgressHUD showErrorWithStatus:msg];
    }];
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 285.0f;
    }
    return 68.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [pinLunArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicDetailCell"];
        DynamicDetailCell * detailCell = (DynamicDetailCell *)cell;
        [detailCell.avatarImageView setImageWithURL:[NSURL URLWithString:_babyRecord.avatar] placeholderImage:Default_Avatar];
        detailCell.babyNameLabel.text = _babyRecord.baby_name;
        detailCell.addressLabel.text = _babyRecord.address;
        detailCell.contentTextView.attributedText = [NSStringUtil makeTopicString:_babyRecord.content];

        [detailCell.likeBtn setTitle:_babyRecord.like_count forState:UIControlStateNormal];
        [detailCell.commentBtn setTitle:_babyRecord.comment_count forState:UIControlStateNormal];
        
        [detailCell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if([_babyRecord.top_3_likes count] > 0)
        {
            detailCell.likeView.hidden = NO;
            NSDictionary * userDic = _babyRecord.top_3_likes[0];
            [detailCell.praiseUserFirstBtn setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] forState:UIControlStateNormal];
            if([_babyRecord.top_3_likes count] > 1)
            {
                userDic = _babyRecord.top_3_likes[1];
                [detailCell.praiseUserSecondBtn setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] forState:UIControlStateNormal];
            }
            
            if([_babyRecord.top_3_likes count] > 2)
            {
                userDic = _babyRecord.top_3_likes[2];
                [detailCell.praiseUserThirdBtn setImageWithURL:[NSURL URLWithString:userDic[@"avatar"]] forState:UIControlStateNormal];
            }
        }
        else
        {
            detailCell.likeView.hidden = YES;
        }

        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PinLunCell"];
        RecordComment * comment = pinLunArray[indexPath.row];
        PinLunCell * pinLunCell = (PinLunCell *)cell;
        pinLunCell.usernameLabel.text = comment.username;
        pinLunCell.contentLabel.text = comment.content;
        pinLunCell.addTimeLabel.text = [NSString stringWithFormat:@"(%@)",[[NSDate dateWithTimeIntervalSince1970:[comment.add_time intValue]] formatDateString:@"yyyy-MM-dd"]];
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}






#pragma mark - UITextFieldDelegate Methods
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


@end
