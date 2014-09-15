//
//  SearchDynamicViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
typedef void(^SearchRSBlock) (NSString * keyword);
@interface SearchDynamicViewController : CommonViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (strong, nonatomic) SearchRSBlock searchBlock;
@end
