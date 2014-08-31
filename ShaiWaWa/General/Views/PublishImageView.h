//
//  PublishImageView.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeleteBlock)(NSString * path);
typedef void (^TapBlock)(NSString * path);
@interface PublishImageView : UIView

@property (nonatomic,strong) NSString * path;
@property (nonatomic,copy) DeleteBlock deleteBlock;
@property (nonatomic,copy) TapBlock tapBlock;

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path;

@end
