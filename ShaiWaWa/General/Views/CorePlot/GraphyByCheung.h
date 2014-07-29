//
//  GraphyByCheung.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GraphyByCheung : UIView<CPTAxisDelegate,CPTPlotDataSource>
@property (nonatomic,strong) CPTXYGraph *graph;
@property (nonatomic,strong) NSMutableArray *_dataForPlot;
-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length;
@end
