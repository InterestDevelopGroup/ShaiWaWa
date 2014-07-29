//
//  MonthDataGraphView.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

//CPTPlotDataSource(用过NSTableView)为 CorePlot 提供数据源
//实现了 CPTAxisDelegate 协议，当我们想要对轴刻度的标签进行一定的定制时，需要实现该协议
@interface MonthDataGraphView : UIView<CPTPlotDataSource,CPTAxisDelegate>

//描绘基于 xy 轴的图形，因此，声明了 CPTXYGraph 对象 _graph
@property (nonatomic,strong) CPTXYGraph *graph;

//声明一个可变数字 _dataForPlot 为 Core Plot 提供数据
@property (nonatomic,strong) NSMutableArray *dataForPlot;

//本类重点
- (void)setupCoreplotViews;
@end
