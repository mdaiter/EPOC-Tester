//
//  GraphDisplay.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/2/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "GraphDisplay.h"

@implementation GraphDisplay

-(id)init{
    if ([super init]) {
        graphView = [[NSPopover alloc] init];
        graphView.appearance = NSPopoverAppearanceMinimal;
        graphView.animates = TRUE;
        [graphView setContentViewController:self];
        graphView.behavior = NSPopoverBehaviorTransient;
        graphView.delegate = self;
        [graphView setContentSize:NSMakeSize(400.0f, 400.0f)];
        firstTime = FALSE;
        
        //Instantiate other objects necessary
        s = [[SystemMonitor alloc] init];
        
        dicHand = [[DicHandler alloc] init];
        
    }
    return self;
}

-(NSPopover*)getPopover{
    return graphView;
}

-(void)setCurrentRect{
    //Get rect inside popover
    graphRect = graphView.contentViewController.view.bounds;
    NSLog(@"Current rect is: %f, %f, %f, %f", graphRect.origin.x, graphRect.origin.y, graphRect.size.width, graphRect.size.height);
    [self initGraph];
    if (firstTime == FALSE){
        firstTime = TRUE;
    }
}

-(void)initGraph{
    if (firstTime == FALSE){
        //Create host part
        NSLog(@"Starting to create graph");
        hostView = [(CPTGraphHostingView*) [CPTGraphHostingView alloc] initWithFrame:graphRect];
        [graphView.contentViewController.view addSubview:hostView];
    
        //Create actual graph foundation
        graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
        hostView.hostedGraph = graph;
        graph.paddingBottom = 10.0f;
        graph.paddingLeft = 10.0f;
        graph.paddingRight = 10.0f;
        graph.paddingTop = 10.0f;
        graph.title = @"Brainwave Measure";
    
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.color  = [CPTColor grayColor];
        textStyle.fontName = @"Helvetica-Bold";
        textStyle.fontSize = 16.0f;
    
        graph.titleTextStyle = textStyle;
        graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
        graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
            
        //Create plot space
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*) graph.defaultPlotSpace;
        plotSpace.allowsUserInteraction = YES;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(100)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(100)];
        
        CPTXYAxisSet *axisSet = (CPTXYAxisSet*)graph.axisSet;
        
        axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(10);
        axisSet.xAxis.minorTicksPerInterval = 1;
        axisSet.xAxis.title = @"Time";
        //axisSet.xAxis.titleOffset = 40.0f;
        
        axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(10);
        axisSet.yAxis.minorTicksPerInterval = 1;
        axisSet.yAxis.title = @"Happiness";
        //axisSet.xAxis.titleOffset = 30.0f;
        
        [self addDataToGraph];
                        
        //[plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSource]];
    }
}

-(CPTScatterPlot*)createScatterPlotWithId:(NSString*)str{
    CPTScatterPlot *data = [[CPTScatterPlot alloc] init];
    data.dataSource = self;
    data.identifier = str;
    
    return data;
}

//Add each plot to the graphspace
-(void)addDataToGraph{
    for (NSString* st in [dicHand getEmotionsKeys]) {
        if (![st isEqualToString:@"Time"]){
            CPTScatterPlot *tempData = [self createScatterPlotWithId:st];
            [graph addPlot:tempData];
        }
    }
}

//Amount of points to be plotted in graph
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    NSLog(@"Count of records to be graphed: %lu \n for this plot: %@", [[[dicHand getDicHandler] objectForKey:[plot identifier]] count], [plot identifier]);
    return [[[dicHand getDicHandler] objectForKey:[plot identifier]] count];
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    
    if (fieldEnum == CPTScatterPlotFieldX){
        NSLog(@"Time coord: %@", [[[dicHand getDicHandler] objectForKey:@"Time"] objectAtIndex:index]);
        return  [[[dicHand getDicHandler] objectForKey:@"Time"] objectAtIndex:index];
    }
    else{
        NSLog(@"%@ coord is: %@",[plot identifier], [[[dicHand getDicHandler] objectForKey:[plot identifier]] objectAtIndex:index]);
        return [[[dicHand getDicHandler] objectForKey:[plot identifier]] objectAtIndex:index];
    }
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point{
    NSLog(@"Can touch down");
    return YES;
}

@end
