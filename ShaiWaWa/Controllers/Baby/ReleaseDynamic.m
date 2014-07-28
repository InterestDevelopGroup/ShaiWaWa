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

@interface ReleaseDynamic ()

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
            _topView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 26);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
            _xialaGrayV.hidden = NO;
            _soundXiaView.hidden = NO;
            _shareXiaView.hidden = YES;
            isShareBar = NO;
            isSoundBar = YES;
        }
        else
        {
            _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height - 26);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
            _xialaGrayV.hidden = NO;
            _soundXiaView.hidden = NO;
            isSoundBar = YES;
        }
       
    }
    else
    {
        _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
        _xialaGrayV.hidden = YES;
        _soundXiaView.hidden = YES;
        isSoundBar = NO;
    }
}

- (IBAction)showSynShareBar:(id)sender
{
    
    if (!isShareBar) {
        
        if (isSoundBar) {
            _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height - 26);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
            _xialaGrayV.hidden = NO;
            _soundXiaView.hidden = YES;
            _shareXiaView.hidden = NO;
            isShareBar = YES;
            isSoundBar = NO;
        }
        else
        {
            _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height - 26);
            _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
            _xialaGrayV.hidden = NO;
            _shareXiaView.hidden = NO;
            isShareBar = YES;
        }
        
    }
    else
    {
        _topView.frame =CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _xialaGrayV.frame = CGRectMake(0, 0, 320, _topView.bounds.size.height - 36);
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

}
- (IBAction)showLocalPhoto:(id)sender {
}

- (IBAction)showLocalCamer:(id)sender {
}

- (IBAction)showLocalFilm:(id)sender {
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
@end
