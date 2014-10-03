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
    points=[[NSMutableArray alloc]init];
    
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
    
    plotSpace.xRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(2.0)];
    
    plotSpace.yRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(3.0)];
    
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
    x.majorIntervalLength=CPTDecimalFromString(@"0.5"); //3
    
    x.orthogonalCoordinateDecimal= CPTDecimalFromString(@"2"); //4
    
    x.minorTicksPerInterval   = 2; //5
    
    NSArray *exclusionRanges = [NSArray arrayWithObjects:
                               
                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99)length:CPTDecimalFromFloat(0.02)],
                               
                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99)length:CPTDecimalFromFloat(0.02)],
                               
                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99)length:CPTDecimalFromFloat(0.02)], nil]; //6
    
    x.labelExclusionRanges= exclusionRanges; //7
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
