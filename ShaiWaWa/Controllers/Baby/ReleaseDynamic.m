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
- (IBAction)showDroSoundBar:(id)sender {
}

- (IBAction)showSynShareBar:(id)sender {
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

- (IBAction)showGrayTwoBtnView:(id)sender {
}
- (IBAction)hideGrayTwoView:(id)sender {
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
@end
