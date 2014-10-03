//
//  LocationsViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
@import CoreLocation;
typedef void(^LocationInfoBlock)(NSString *);
typedef void(^DidSelectPlacemark)(NSDictionary * info);
@interface LocationsViewController : CommonViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *addrTableView;
@property (strong, nonatomic) IBOutlet UITextField *addrField;
@property (strong, nonatomic) LocationInfoBlock addressStrBlock;
@property (strong, nonatomic) LocationInfoBlock latitudeStrBlock;
@property (strong, nonatomic) LocationInfoBlock longitudeStrBlock;
@property (copy,nonatomic) DidSelectPlacemark didSelectPlacemark;
- (IBAction)finishEvent:(id)sender;
@end
