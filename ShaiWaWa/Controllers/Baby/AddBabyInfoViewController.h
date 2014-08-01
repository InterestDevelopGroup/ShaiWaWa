//
//  AddBabyInfoViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface AddBabyInfoViewController : CommonViewController<UITextFieldDelegate, UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL isBoy, isGirl, isDad, isMon;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UIButton *cityButton;
@property (strong, nonatomic) IBOutlet UIButton *showSelectCityVC;
@property (strong, nonatomic) IBOutlet UIButton *boyRadioButton;
@property (strong, nonatomic) IBOutlet UIButton *girlRadioButton;
@property (strong, nonatomic) IBOutlet UIButton *monRadioButton;
@property (strong, nonatomic) IBOutlet UIButton *dadRadioButton;
@property (strong, nonatomic) IBOutlet UITextField *babyNicknameField;
@property (strong, nonatomic) IBOutlet UITextField *birthDayField;
@property (strong, nonatomic) IBOutlet UITextField *babyNameField;
@property (strong, nonatomic) IBOutlet UITextField *birthStatureField;
@property (strong, nonatomic) IBOutlet UITextField *birthWeightField;

- (IBAction)boySelected:(id)sender;
- (IBAction)girlSelected:(id)sender;
- (IBAction)monSelected:(id)sender;
- (IBAction)dadSelected:(id)sender;
- (IBAction)openCitiesSelectView:(id)sender;
- (IBAction)touXiangSelectEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *touXiangButton;

@end
