//
//  LocationsViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
typedef void(^LocationInfoBlock)(NSString *);
@interface LocationsViewController : CommonViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *addrNames, *addrDetails;
}
@property (strong, nonatomic) IBOutlet UITableView *addrTableView;
@property (strong, nonatomic) IBOutlet UITextField *addrField;
@property (strong, nonatomic) LocationInfoBlock addressStrBlock;
@property (strong, nonatomic) LocationInfoBlock latitudeStrBlock;
@property (strong, nonatomic) LocationInfoBlock longitudeStrBlock;

- (IBAction)finishEvent:(id)sender;
@end
