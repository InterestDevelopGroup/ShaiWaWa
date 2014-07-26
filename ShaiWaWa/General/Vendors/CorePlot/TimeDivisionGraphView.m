//
//  TimeDivisionGraphView.m
//  ZTFinance
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TimeDivisionGraphView.h"
#import "CorePlot-CocoaTouch.h"
//#import "Min1QuoteData.h"
//#import "AppThemeManager.h"
//#import "TimeDivisionGraphTouchLayer.h"
@interface TimeDivisionGraphView()<CPTPlotDataSource>//,TimeDivisionGraphTouchLayerDelegate>
@property (nonatomic,strong) CPTXYGraph * graph;
@property (nonatomic,strong) NSArray * allDatas;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) UILabel * startTimeLabel , * endTimeLabel;
//@property (nonatomic,strong) TimeDivisionGraphTouchLayer * touchLayer;
@property (nonatomic,strong) CPTScatterPlot *dataSourceLinePlot;
@property (nonatomic,assign) int showLocation;
@property (nonatomic,assign) int showCount;
@end

@implementation TimeDivisionGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _graph = [self createGraph];
        [self configGraphHost];
        [self createTimeLabel];
        [self createTouchLayer];
        _showCount = 50;
        _showLocation = 0;
    }
    return self;
}

- (void)dealloc
{
    _graph = nil;
    _dataSource = nil;
    _startTimeLabel = nil;
    _endTimeLabel = nil;
}


#pragma mark - Instance Methods
- (void)reloadData:(NSArray *)data
{
    [_touchLayer drawCrossShapedAtPoint:CGPointMake(0, 0) showCrossShaped:NO pointInfo:nil isKLine:NO];
    //返回的数据是按时间倒序的，从大到小，转换为从小到大
    self.allDatas = (NSMutableArray *)[[data reverseObjectEnumerator] allObjects];
    if([self.allDatas count] <= _showCount)
    {
        _showLocation = 0;
        _showCount = [self.allDatas count];
    }
    else
    {
        _showLocation = [self.allDatas count] - _showCount;
    }
    
    self.dataSource = (NSMutableArray *)[self.allDatas subarrayWithRange:NSMakeRange(_showLocation, _showCount)];
    [self configXYAxisWhitData:self.dataSource];
    
}

- (void)updateUI
{
    if(_graph == nil)
        return ;
//    [_graph applyTheme:[[AppThemeManager sharedManager] graphTheme]];
    CPTMutableLineStyle *lineStyle = [_dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 1.0;
    lineStyle.miterLimit = 0.1f;
//    lineStyle.lineColor              = [[AppThemeManager sharedManager]timeDivisionGraphLineColor];
    _dataSourceLinePlot.dataLineStyle = lineStyle;
    [self configXYAxisWhitData:_dataSource];
}

- (void)createTimeLabel
{
    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 30, 90, 22)];
    _startTimeLabel.textAlignment = NSTextAlignmentCenter;
    _startTimeLabel.font = [UIFont systemFontOfSize:13];
    _startTimeLabel.textColor = [UIColor grayColor];
    _startTimeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_startTimeLabel];
    
    _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 90 - _graph.paddingRight, CGRectGetHeight(self.bounds) - 30, 90, 22)];
    _endTimeLabel.textAlignment = NSTextAlignmentCenter;
    _endTimeLabel.font = [UIFont systemFontOfSize:13];
    _endTimeLabel.textColor = [UIColor grayColor];
    _endTimeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_endTimeLabel];
    
}

- (void)createTouchLayer
{
    CGRect rect = self.graph.hostingView.frame;
    rect.origin.x += self.graph.paddingLeft;
    rect.origin.y += self.graph.paddingTop;
    rect.size.width = rect.size.width - self.graph.paddingLeft - self.graph.paddingRight;
    rect.size.height = rect.size.height - self.graph.paddingTop - self.graph.paddingBottom;
    _touchLayer = [[TimeDivisionGraphTouchLayer alloc] initWithFrame:rect];
    _touchLayer.delegate = self;
    [self addSubview:_touchLayer];
}


- (CPTXYGraph *)createGraph
{
    CPTXYGraph * graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
//    CPTTheme *theme = [[AppThemeManager sharedManager] graphTheme];
//    [graph applyTheme:theme];
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
//    lineStyle.lineColor              = [[AppThemeManager sharedManager]timeDivisionGraphLineColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.dataSource = self;
    //添加渐变
    CPTGradient * gradient = [CPTGradient gradientWithBeginningColor:[[CPTColor colorWithGenericGray:0.55] colorWithAlphaComponent:0.55] endingColor:[[CPTColor colorWithGenericGray:0.55] colorWithAlphaComponent:0.55]];
    gradient.angle = - 90.0f;
    CPTFill * fill = [CPTFill fillWithGradient:gradient];
    dataSourceLinePlot.areaFill = fill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromFloat(0.0);
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear;
    [graph addPlot:dataSourceLinePlot];
    _dataSourceLinePlot = dataSourceLinePlot;
    dataSourceLinePlot = nil;
    return graph;
}

- (void)configGraphHost
{
    CPTGraphHostingView * graphHost = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    graphHost.hostedGraph = _graph;
    [self addSubview:graphHost];
    graphHost = nil;
}



- (void)configXYAxisWhitData:(NSArray *)dataSource
{
    //最大时间和最小时间
    int64_t minTime = [(Min1QuoteData *)[dataSource firstObject] lastTime];
    int64_t maxTime = [(Min1QuoteData *)[dataSource lastObject] lastTime];
    //获取最大价格和最小价格
    float max = 0.0;
    float min = 0.0;
    for(Min1QuoteData * data in dataSource)
    {
        if(max == 0.0 || max < (data.lastPrice/10000.0))
        {
            max = data.lastPrice/10000.0;
        }
        
        if(min == 0.0 || min > (data.lastPrice/10000.0))
        {
            min = data.lastPrice/10000.0;
        }
    }
    
    if(max == min)
    {
        max += 0.001;
        min -= 0.001;
    }

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    NSDecimalNumber * high = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromFloat(max)];
    NSDecimalNumber * low = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromFloat(min)];
    NSDecimalNumber *length = [high decimalNumberBySubtracting:low];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromUnsignedInteger([_dataSource count])];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[low decimalValue] length:[length decimalValue]];
    //plotSpace.allowsUserInteraction = YES;
    //line style
    CPTMutableLineStyle * majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    majorGridLineStyle.lineWidth = 0.75;
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    float xdiv = [_dataSource count]/4.0;
    x.majorIntervalLength         = CPTDecimalFromDouble(xdiv);
    x.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
    x.majorGridLineStyle = majorGridLineStyle;
    x.majorTickLocations = [NSSet setWithObjects:[NSNumber numberWithLongLong:0],[NSNumber numberWithLongLong:(xdiv)],[NSNumber numberWithLongLong:(2 * xdiv)],[NSNumber numberWithLongLong:(3 * xdiv)],[NSNumber numberWithLongLong:_dataSource.count],nil];
    x.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    NSString * text_1 = [[NSDate dateFromString:[NSString stringWithFormat:@"%lli",minTime] withFormat:@"yyyyMMddHHmmss"] formatDateString:@"mm:ss"];
    NSString * text_2 = [[NSDate dateFromString:[NSString stringWithFormat:@"%lli",maxTime] withFormat:@"yyyyMMddHHmmss"] formatDateString:@"mm:ss"];
    _startTimeLabel.text = text_1;
    _endTimeLabel.text = text_2;
    /*
    NSString * text_1 = [[NSDate dateFromString:[NSString stringWithFormat:@"%lli",minTime] withFormat:@"yyyyMMddHHmmss"] formatDateString:@"mm:ss"];
    CPTAxisLabel * label_1 = [[CPTAxisLabel alloc] initWithText:text_1 textStyle:[CPTTextStyle textStyle]];
    label_1.tickLocation = CPTDecimalFromInt(0);
    NSString * text_2 = [[NSDate dateFromString:[NSString stringWithFormat:@"%lli",maxTime] withFormat:@"yyyyMMddHHmmss"] formatDateString:@"mm:ss"];
    CPTAxisLabel * label_2 = [[CPTAxisLabel alloc] initWithText:text_2 textStyle:[CPTTextStyle textStyle]];
    label_1.tickLocation = CPTDecimalFromInt([_dataSource count]);
    //空坐标
    CPTAxisLabel * xEemptyLabel = [[CPTAxisLabel alloc] initWithText:@"" textStyle:[CPTTextStyle textStyle]];
    xEemptyLabel.tickLocation = CPTDecimalFromLongLong(xdiv);
    CPTAxisLabel * xEmptyLabel_1 = [[CPTAxisLabel alloc] initWithText:@"" textStyle:[CPTTextStyle textStyle]];
    xEmptyLabel_1.tickLocation = CPTDecimalFromLongLong(2 * xdiv);
    CPTAxisLabel * xEmptyLabel_2 = [[CPTAxisLabel alloc] initWithText:@"" textStyle:[CPTTextStyle textStyle]];
    xEmptyLabel_2.tickLocation = CPTDecimalFromLongLong(3 * xdiv);
    x.axisLabels = [NSSet setWithObjects:label_1,xEemptyLabel,xEmptyLabel_1,xEmptyLabel_2,label_2, nil];
    */
    
    CPTXYAxis *y  = axisSet.yAxis;
    NSDecimal four = CPTDecimalFromInteger(4);
    NSDecimal div = CPTDecimalDivide([length decimalValue], four);
    y.majorIntervalLength         = div;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
    y.majorGridLineStyle = majorGridLineStyle;
    y.majorTickLocations = [NSSet setWithObjects:low,[low decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:div]],[low decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalMultiply(div, CPTDecimalFromInt(2))]],[low decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalMultiply(div, CPTDecimalFromInt(3))]],high, nil];
    y.axisConstraints = [CPTConstraints constraintWithUpperOffset:0];
    y.tickDirection = CPTSignPositive;
    y.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
    NSNumberFormatter * yFormatter = [[NSNumberFormatter alloc] init];
    yFormatter.maximumFractionDigits = 4;
    y.labelFormatter = yFormatter;
    [_graph reloadData];
}

#pragma mark - CPTScatterPlotDataSource Methods
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_dataSource count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    
    NSNumber *num = @0;
    if ( fieldEnum == CPTScatterPlotFieldX ) {
        num = @(idx);
    }
    else if ( fieldEnum == CPTScatterPlotFieldY ) {
        //Min1QuoteData * data = _dataSource[[_dataSource count] - idx - 1];
        Min1QuoteData * data = _dataSource[idx];
        num = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromFloat(data.lastPrice/10000.0)];
    }
    
    return num;

}

#pragma mark - TimeDivisionGraphTouchLayerDelegate
- (void)tapEventHandle:(UIGestureRecognizer *)sender
{
    [self drawNoticeWithGesture:sender];
}

- (void)panEventHandle:(UIGestureRecognizer *)sender
{
    [self drawNoticeWithGesture:sender];
}


#pragma mark -

- (void)drawNoticeWithGesture:(UIGestureRecognizer *)sender
{
    
    CGPoint currentPoint = [sender locationInView:_touchLayer];
    if(currentPoint.x <= 5 )
    {
        if(_showLocation - 10 >= 0)
        {
            _showLocation -= 10;
            self.dataSource = (NSMutableArray *)[self.allDatas subarrayWithRange:NSMakeRange(_showLocation, _showCount)];
            [self configXYAxisWhitData:self.dataSource];
            currentPoint.x = 15;
        }
        else
        {
            currentPoint.x = 5;
        }
        
    }
    
    if(currentPoint.x >= CGRectGetWidth(_touchLayer.bounds) - 5)
    {
        if(_showLocation + _showCount + 10 < [self.allDatas count])
        {
            _showLocation += 10;
            self.dataSource = (NSMutableArray *)[self.allDatas subarrayWithRange:NSMakeRange(_showLocation, _showCount)];
            [self configXYAxisWhitData:self.dataSource];
            currentPoint.x = CGRectGetWidth(_touchLayer.bounds) - 15;
        }
        else
        {
            currentPoint.x = CGRectGetWidth(_touchLayer.bounds) - 5;
        }
        
    }
    
    int count = [_dataSource count];
    
    if(count == 0)
    {
        return ;
    }
    int dataIndex = (count / CGRectGetWidth(_touchLayer.bounds)) * currentPoint.x;
    if(dataIndex >= count)
    {
        dataIndex -= 1;
    }
    
    if(dataIndex < 0)
    {
        dataIndex = 0;
    }
    
    Min1QuoteData * data = _dataSource[dataIndex];
    NSString * timeText = [NSString stringWithFormat:@"时间:%@",[[NSDate dateFromString:[NSString stringWithFormat:@"%lli",data.lastTime] withFormat:@"yyyyMMddHHmmss"] formatDateString:@"HH:mm:ss"]];
    NSString * priceText = [NSString stringWithFormat:@"价格:%@",data.lastPriceStr];
    NSDictionary * pointInfo = @{@"time":timeText,@"price":priceText};
    [_touchLayer drawCrossShapedAtPoint:currentPoint showCrossShaped:YES pointInfo:pointInfo isKLine:NO];
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_touchLayer drawCrossShapedAtPoint:CGPointMake(0, 0) showCrossShaped:NO pointInfo:nil isKLine:NO];
        });
    }

    
}


@end
