//
//  DynamicDetailViewController.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-17.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "BabyRecord.h"
typedef void (^DeleteRecord)(BabyRecord * record);
@interface DynamicDetailViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
//    BOOL isShareViewShown;
    UITextField *temp_txt;
    NSMutableArray *pinLunArray;
}
@property (strong, nonatomic) IBOutlet UITableView *pinLunListTableView;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextField *pinLunContextTextField;
@property (strong,nonatomic) BabyRecord * babyRecord;
@property (assign, nonatomic) BOOL isShareViewShown;
@property (nonatomic,copy) DeleteRecord deleteBlock;
- (IBAction)hideGrayShareV:(id)sender;
- (IBAction)pinLunEvent:(id)sender;

@end
