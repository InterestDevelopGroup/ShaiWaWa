//
//  GraphyByCheung.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "GraphyByCheung.h"

@implementation GraphyByCheung
@synthesize _dataForPlot;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupCPTXYGraphViews];
        //_graph = [self createGraph];
        [self configGraphHost];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

//First Step:在CPTGraphHostingView 上放置一个xy轴图CPTXYGraph
- (void)configGraphHost
{
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    hostingView.hostedGraph = _graph;
    [self addSubview:hostingView];
    hostingView = nil;
}

//Second Step:然后对xy轴图进行设置，设置其主题，可视空间CPTPlotSpace(CPTXYPlotSpace的 xRange and yRange 可显示的x,y量度)，以及两个轴CPTXYAxis
- (void)setupCPTXYGraphViews
{
    //首先，创建了一个可编辑的线条风格 lineStyle，用来描述描绘线条的宽度，颜色和样式;
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    //然后，创建基于 xy 轴的图：CPTXYGraph，并设置其主题 CPTTheme(主题和软件的换肤概念差不多)目前支持五种主题：kCPTDarkGradientTheme, kCPTPlainBlackTheme, kCPTPlainWhiteTheme, kCPTSlateTheme,kCPTStocksTheme
    // Create graph from theme: 设置主题
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [_graph applyTheme:theme];
    _graph.plotAreaFrame.masksToBorder = NO;
    
    //接着: 设置一屏内可显示的x,y量度范围
    //设置x，y轴上的起点都是1.0，然后长度分别为2个和3个单位(allowsUserInteraction 为 YES 起点非1.0)
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(1.0)];
    
    _graph.paddingLeft = 30.0;
    _graph.paddingRight = 20.0;
    _graph.paddingTop = _graph.paddingBottom = 40.0;
    
    
    // 有了 xy 轴图对象，我们可以来对 xy 轴的显示属性进行设置了。通过获取 XYGraph 的 axisSet 来获取轴的集合，集合中就包含了 x,y 轴对象 CPTXYAxis。在这里，设置 x 轴的原点为 2，主刻度的量度间隔为 0.5，每一个主刻度内显示细分刻度的个数为 2 个，并用白色宽度为2的线条来描绘 x 轴。如果有一些刻度的标签我们不想让它显示那该如何呢？很简单，设置轴的排除标签范围 labelExclusionRanges 即可。
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.lineWidth  = 1.0;
    lineStyle.miterLimit = 1.0/12.0f;
    lineStyle.lineColor = [CPTColor blackColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1/12");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 12;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.0 length:0.0],
                                 //[self CPTPlotRangeFromFloat:4.0 length:3.0],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
   
    //同样，我们设置 y 轴的显示属性：
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"0.5");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       //[self CPTPlotRangeFromFloat:0.0 length:0.0],
                       //[self CPTPlotRangeFromFloat:4.0 length:4.0],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    
    //至此，xy轴部分的描绘设置完成。 下面我们向图中添加曲线的描绘：
    
    //首先，添加一个由红到蓝渐变的曲线图 CPTScatterPlot，设置该曲线图的曲线线条颜色为蓝色，宽度为3，标识为 @"Blue Plot"，数据源 datasource 为自身。注意：一个图中可以有多个曲线图，每个曲线图通过其 identifier 进行唯一标识。 数据源将在后面介绍。如果我们不仅仅是描绘曲线，还想描绘曲线覆盖的区域，那么就要设置曲线图的区域填充颜色 areaFill，并设置 areaBaseValue。areaBaseValue就是设置该填充颜色从哪个值开始描述
    
    // 对于曲线上的数值点用什么样的符号来表示呢？这就是CPTPlotSymbol 发挥作用的时候了，在这里是用蓝色的实心圆点来表示具体的数值。
    
    // Create a red-blue plot area
    //
    lineStyle.lineWidth  = 1.0;
    lineStyle.miterLimit = 0.1f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = @"blue";//BLUE_PLOT_IDENTIFIER
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:1.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    //有了蓝红曲线图的介绍，下面再来添加一个破折线风格的绿色曲线图：
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    CPTScatterPlot * dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.identifier = @"green";//GREEN_PLOT_IDENTIFIER
    dataSourceLinePlot.dataSource = self;
    
    // Put an area gradient under the plot above
    //
    CPTColor * areaColor            = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient      = [CPTGradient gradientWithBeginningColor:areaColor
                                                                  endingColor:[CPTColor clearColor]];
    areaGradient.angle              = -90.0f;
    areaGradientFill                = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill     = areaGradientFill;
    dataSourceLinePlot.areaBaseValue= CPTDecimalFromString(@"1.75");
    
    // Animate in the new plot: 淡入动画
    dataSourceLinePlot.opacity = 0.0f;
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 3.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    [_graph addPlot:dataSourceLinePlot];
}


-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 10;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
   
    return NULL;
}

/*
- (CPTXYGraph *)createGraph
{
    CPTXYGraph * graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    graph.paddingTop    = 15.0;
    graph.paddingBottom = 30.0;
    graph.paddingLeft   = 15.0;
    graph.paddingRight  = 65.0;
    graph.plotAreaFrame.masksToBorder = NO;
    //    if([OSHelper iOS7])
    //    {
    //        graph.plotAreaFrame.borderLineStyle = nil;
    //    }
    
    //折线
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
    dataSourceLinePlot.identifier = @"TimeDivision";
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 1.0;
    lineStyle.miterLimit = 0.1f;
    //lineStyle.lineColor              = [UIColor blackColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    //dataSourceLinePlot.dataSource = self;
    //添加渐变
    CPTGradient * gradient = [CPTGradient gradientWithBeginningColor:[[CPTColor colorWithGenericGray:0.55] colorWithAlphaComponent:0.55] endingColor:[[CPTColor colorWithGenericGray:0.55] colorWithAlphaComponent:0.55]];
    gradient.angle = - 90.0f;
    CPTFill * fill = [CPTFill fillWithGradient:gradient];
    dataSourceLinePlot.areaFill = fill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromFloat(0.0);
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear;
    [graph addPlot:dataSourceLinePlot];
    //_dataSourceLinePlot = dataSourceLinePlot;
    dataSourceLinePlot = nil;
    return graph;
}
*/
@end
