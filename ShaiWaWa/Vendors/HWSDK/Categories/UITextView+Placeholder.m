//
//  UITextView+Placeholder.m
//  LingTong
//
//  Created by Carl on 14-3-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>

@implementation UITextView (Placeholder)

- (void)setPlaceholder:(NSString *)placeholder
{

    self.text = placeholder;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMySelf:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    objc_setAssociatedObject(self, &@selector(tapMySelf:), placeholder,OBJC_ASSOCIATION_RETAIN);
    
    tap = nil;
}


- (void)tapMySelf:(UITapGestureRecognizer *)tap
{
    id holder = objc_getAssociatedObject(self, &@selector(tapMySelf:));
    if([self.text isEqualToString:holder] || [self.text length] == 0)
    {
        [self becomeFirstResponder];
        self.text = nil;
    }
}
@end
