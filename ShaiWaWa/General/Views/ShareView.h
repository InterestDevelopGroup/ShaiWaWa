//
//  ShareView.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WeiXinBlock)(void);
typedef void(^WeiXinCycleBlock)(void);
typedef void(^XinLanWbBlock)(void);
typedef void(^QzoneBlock)(void);
typedef void(^CollectionBlock)(void);
typedef void(^ReportBlock)(void);
typedef void(^DeleteBlock)(NSString *);


@interface ShareView : UIView

@property (nonatomic,retain) UILabel *shareToLabel;
@property (nonatomic,retain) UIButton *weiXinButton;
@property (nonatomic,retain) UIButton *weiXinCycleButton;
@property (nonatomic,retain) UIButton *xinLanWbButton;
@property (nonatomic,retain) UIButton *qzoneButton;
@property (nonatomic,retain) UIButton *collectionButton;
@property (nonatomic,retain) UIButton *reportButton;
@property (nonatomic,retain) UIButton *deleteButton;

@property (nonatomic,strong) WeiXinBlock weiXinBlock;
@property (nonatomic,strong) WeiXinCycleBlock weiXinCycleBlock;
@property (nonatomic,strong) XinLanWbBlock xinLanWbBlock;
@property (nonatomic,strong) QzoneBlock qzoneBlock;
@property (nonatomic,strong) CollectionBlock collectionBlock;
@property (nonatomic,strong) ReportBlock reportBlock;
@property (nonatomic,strong) DeleteBlock deleteBlock;


@property (nonatomic,retain) NSString *name;
@end
