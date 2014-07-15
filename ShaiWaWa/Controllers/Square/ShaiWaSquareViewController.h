//
//  ShaiWaSquareViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ShaiWaSquareViewController : CommonViewController
{
    BOOL isHot, isNew;
}
@property (strong, nonatomic) IBOutlet UIButton *theHotButton;
@property (strong, nonatomic) IBOutlet UIButton *theNewButton;
- (IBAction)hotSelected:(id)sender;
- (IBAction)newSelected:(id)sender;


@end
