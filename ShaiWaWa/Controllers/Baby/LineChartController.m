//
//  LineChartController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-10-2.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "LineChartController.h"
#import "CorePlot-CocoaTouch.h"

@interface LineChartController () <CPTPlotDataSource>
{
    CPTXYGraph *graph;
    NSMutableArray* points;
}
@end

@implementation LineChartController


- (void)viewDidLoad
{
    [super viewDidLoad];
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    
    [graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)self.view;
    
    hostingView.hostedGraph = graph;
    /**
     *  Description
     */
    points=[[NSMutableArray alloc] init];
    
    NSUInteger i;
    
    for ( i = 0; i < 60; i++ ) {
        
        id x = [NSNumber numberWithFloat:1 +i * 0.05];
        
        id y = [NSNumber numberWithFloat:1.2* rand() / (float)RAND_MAX + 1.2];
        
        [points addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x",y, @"y", nil]];
        
    }
    
    /**
     *  Description
     */
    CPTXYPlotSpace *plotSpace =(CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction= YES;
    
    // 设置x,y坐标范围
    
    plotSpace.xRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(18)];
    
    plotSpace.yRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(100)];
    
    /**
     *  Description
     */
    CPTScatterPlot *boundLinePlot  = [[CPTScatterPlot alloc] init];
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    lineStyle.miterLimit = 1.0f;
    
    lineStyle.lineWidth = 3.0f;
    
    lineStyle.lineColor = [CPTColor blueColor];
    
    /**
     *  Description
     */
    
    boundLinePlot.dataLineStyle= lineStyle;
    
    boundLinePlot.identifier = @"Blue Plot";
    
    boundLinePlot.dataSource = self;
    
    [graph addPlot:boundLinePlot];
    
   // //////
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet; //1
    
    CPTXYAxis*x   = axisSet.xAxis; //2
    x.majorIntervalLength=CPTDecimalFromString(@"2"); //3
    
    x.orthogonalCoordinateDecimal= CPTDecimalFromString(@"5"); //4
    
    x.minorTicksPerInterval   = 2; //5
    
//    NSArray *exclusionRanges = [NSArray arrayWithObjects:
//                               
//                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99)length:CPTDecimalFromFloat(0.02)],
//                               
//                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99)length:CPTDecimalFromFloat(0.02)],
//                               
//                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99)length:CPTDecimalFromFloat(0.02)], nil]; //6
//    
//    x.labelExclusionRanges= exclusionRanges; //7
    
    //y轴
    CPTXYAxis *y =axisSet.yAxis;
    //y轴：不显示小刻度线
    y.minorTickLineStyle = nil;
    //大刻度线间距：10单位
    y.majorIntervalLength = CPTDecimalFromString(@"10");
    //坐标原点：0.25
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2");
    y.titleOffset = 4.5f;
    y.titleLocation = CPTDecimalFromFloat(1.5f);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot

{
    
    return[points count];
    
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index

{
    
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    
    NSNumber *num = [[points objectAtIndex:index] valueForKey:key];
    
    return num;
    
}


@end
/*
#define  num 20
@interface LineChartController()<CPTPlotDataSource>
{
    CPTXYGraph *graph;
    double x[num] ;//散点的x坐标
    double y1[num] ;//第1个散点图的y坐标
    double y2[num];//第2个散点图的y坐标
}
@end

@implementation LineChartController

- (void)viewDidLoad
{
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];

    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)self.view;

    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius = 0.0f;
    
    hostingView.hostedGraph = graph;
    //绘图空间 plotspace
    CPTXYPlotSpace *plotSpace =(CPTXYPlotSpace *)graph.defaultPlotSpace;

    plotSpace.allowsUserInteraction= YES;

    // 设置x,y坐标范围

    plotSpace.xRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(200.0f)];

    plotSpace.yRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(num)];
    
    // CPGraph四边不留白
    graph.paddingLeft = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    //绘图区4边留白
    graph.plotAreaFrame.paddingLeft = 45.0;
    graph.plotAreaFrame.paddingTop = 40.0;
    graph.plotAreaFrame.paddingRight = 5.0;
    graph.plotAreaFrame.paddingBottom = 80.0;
    
    //坐标系
    CPTXYAxisSet *axisSet =(CPTXYAxisSet *)graph.axisSet;
    //x轴：为坐标系的x轴
    CPTXYAxis *X =axisSet.xAxis;
    //清除默认的轴标签,使用自定义的轴标签
    X.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:num];
    
    static CPTTextStyle *labelTextStyle=nil;
    labelTextStyle=[[CPTTextStyle alloc]init];
//    labelTextStyle.color = [CPTColor whiteColor];
//    labelTextStyle.fontSize=10.0f;
    
    for (int i=0;i<num;i++) {
        CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText: [NSString stringWithFormat:@"第%d个数据点",(i+1)] textStyle:labelTextStyle];
        newLabel.tickLocation = CPTDecimalFromInt(i);
        newLabel.offset = X.labelOffset + X.majorTickLength;
        newLabel.rotation = M_PI/2;
        [customLabels addObject:newLabel];
    }
    X.axisLabels = [NSSet setWithArray:customLabels];
    
    //y轴
    CPTXYAxis *y =axisSet.yAxis;
    //y轴：不显示小刻度线
    y.minorTickLineStyle = nil;
    //大刻度线间距：50单位
    y.majorIntervalLength = CPTDecimalFromString(@"50");
    //坐标原点：0
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.titleOffset = 45.0f;
    y.titleLocation = CPTDecimalFromFloat(150.0f);
    
    
    // 第1个散点图：蓝色
    CPTScatterPlot *boundLinePlot = [[CPTScatterPlot alloc] init];
    //id，用于识别该散点图
    boundLinePlot.identifier = @"BluePlot";
    
    //线型设置
    CPTLineStyle *lineStyle= [[CPTLineStyle alloc]init];
//    lineStyle.lineWidth = 1.0f;
//    lineStyle.lineColor = [CPColor blueColor];
    boundLinePlot.dataLineStyle =lineStyle;
    
    //设置数据源,必须实现CPPlotDataSource协议
    boundLinePlot.dataSource = self;
    [graph addPlot:boundLinePlot];
    
    // 在图形上添加一些小圆点符号（节点）
    CPTLineStyle *symbolLineStyle = [[CPTLineStyle alloc ]init];
    //描边：黑色
//    symbolLineStyle.lineColor = [CPTColor blackColor];
    //符号类型：椭圆
    CPTPlotSymbol *plotSymbol= [CPTPlotSymbol ellipsePlotSymbol];
    //填充色：蓝色
//    plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
    //描边
//    plotSymbol.lineStyle =symbolLineStyle;
    //符号大小：10*10
    plotSymbol.size = CGSizeMake(6.0, 6.0);
    //向图形上加入符号
    boundLinePlot.plotSymbol = plotSymbol;
    // 创建渐变区
    //渐变色1
    CPTColor *areaColor= [CPTColor colorWithComponentRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    //创建一个颜色渐变：从 建变色1 渐变到 无色
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    //渐变角度： -90度（顺时针旋转）
    areaGradient.angle = -90.0f;
    //创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    //为图形1设置渐变区
    boundLinePlot.areaFill =areaGradientFill;
    //渐变区起始值，小于这个值的图形区域不再填充渐变色
    boundLinePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
    //interpolation值为CPScatterPlotInterpolation枚举类型，该枚举有3个值：
    //CPScatterPlotInterpolationLinear,线性插补——折线图.
    //CPScatterPlotInterpolationStepped,在后方进行插补——直方图
    //CPScatterPlotInterpolationHistogram,以散点为中心进行插补——直方图
    boundLinePlot.interpolation = CPTScatterPlotInterpolationHistogram;
    
    // 第2个散点图：绿色
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"GreenPlot";
    //线型设置
    lineStyle = [[CPTLineStyle alloc]init];
//    lineStyle.lineWidth = 1.0f;
//    lineStyle.lineColor = [CPColor greenColor];
    dataSourceLinePlot.dataLineStyle =lineStyle;
    //设置数据源,必须实现CPPlotDataSource协议
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    //随机产生散点数据
    NSUInteger i;
    for ( i = 0; i < num; i++ ) {
        x[i] = i ;
        y1[i] = (num*10)*(rand()/(float)RAND_MAX);
        y2[i] = (num*10)*(rand()/(float)RAND_MAX);
    }
}

#pragma mark Plot Data Source Methods
//返回散点数
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return num ;
}
//根据参数返回数据（一个C数组）
- (double*)doublesForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
    //返回类型：一个double指针（数组）
    double *values;
    NSString *identifier=(NSString*)[plot identifier];
    
    switch (fieldEnum){
            //如果请求的数据是散点x坐标,直接返回x坐标（两个图形是一样的），否则还要进一步判断是那个图形
        case CPTScatterPlotFieldX:
            values=x;
            break;
        case CPTScatterPlotFieldY:
            //如果请求的数据是散点y坐标，则对于图形1，使用y1数组，对于图形2，使用y2数组
            if([identifier isEqualToString:@"BluePlot"]) {
                values=y1;
            }else
                values=y2;
            break;
    }
    //数组指针右移个indexRage.location单位，则数组截去indexRage.location个元素
    return values +indexRange.location ;
}
//添加数据标签
- (CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    //定义一个白色的TextStyle
    static CPTTextStyle *whiteText= nil;
    if (!whiteText ) {
        whiteText= [[CPTTextStyle alloc] init];
//        whiteText.color = [CPTColor whiteColor];
    }
    //定义一个TextLayer
    CPTTextLayer *newLayer =nil;
    NSString*identifier=(NSString*)[plot identifier];
    if([identifier isEqualToString:@"BluePlot"]) {
        newLayer= [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.0f", y1[index]] style:whiteText];
    }
    return newLayer;
}

@end*/

