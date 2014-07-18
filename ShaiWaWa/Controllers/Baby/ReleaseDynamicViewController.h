//
//  ReleaseDynamicViewController.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ReleaseDynamicViewController : CommonViewController

- (IBAction)showTopicVC:(id)sender;
- (IBAction)showChooseFriendVC:(id)sender;

- (IBAction)showDroSoundBar:(id)sender;

- (IBAction)showSynShareBar:(id)sender;
- (IBAction)showLocationVC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *letPersonSawLabel;

@end
