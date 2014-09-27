//
//  AudioView.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeleteBlock)(NSString * path);

@interface AudioView : UIView
@property (nonatomic,copy) DeleteBlock deleteBlock;
@property (nonatomic,strong) NSString * path;
- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path;
- (void)setCloseHidden;
@end
