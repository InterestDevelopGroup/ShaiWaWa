//
//  SearchDynamicViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SearchDynamicViewController : CommonViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;

@end
