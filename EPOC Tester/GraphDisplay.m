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
        
        s = [[SystemMonitor alloc] init];
        dataPoints = [[NSMutableArray alloc] init];
        [self generatePoints];
        
        date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    }
    return self;
}

-(void)generatePoints{
    NSDateFormatter* formatter;
    NSString* timeString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm, MM-dd-yyyy"];
    
    timeString = [formatter stringFromDate:[NSDate date]];
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSinceDate: date];
    
    NSNumber *timeStampNum = [NSNumber numberWithDouble:timeStamp];
    
    NSDictionary* newVal = [NSDictionary dictionaryWithObjectsAndKeys:[[s getMood] objectForKey:@"Angry"], @"Anger", [NSNumber numberWithDouble:2.0f], @"Time", nil];
    [dataPoints addObject:newVal];
    
    NSDictionary* newVal2 = [NSDictionary dictionaryWithObjectsAndKeys:[[s getMood] objectForKey:@"Happy"], @"Anger", [NSNumber numberWithDouble:3.0f], @"Time", nil];
    [dataPoints addObject:newVal2];
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
        
        axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(1);
        axisSet.xAxis.minorTicksPerInterval = 1;
        axisSet.xAxis.title = @"Time";
        //axisSet.xAxis.titleOffset = 40.0f;
        
        axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(1);
        axisSet.yAxis.minorTicksPerInterval = 1;
        axisSet.yAxis.title = @"Happiness";
        //axisSet.xAxis.titleOffset = 30.0f;
        
        CPTScatterPlot *dataSource = [[CPTScatterPlot alloc] init];
        dataSource.dataSource = self;
        dataSource.identifier = @"Happiness";
        
        [graph addPlot:dataSource];
        
        //[plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSource]];
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    NSLog(@"%lu", [[s getMood] count]);
    return [[s getMood] count];
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    NSDictionary* sample = [dataPoints objectAtIndex:index];
    NSLog(@"Being asked for %@", sample);
    
    if (fieldEnum == CPTScatterPlotFieldX){
        return [sample valueForKey:@"Time"];
    }
    else{
        return [sample valueForKey:@"Anger"];
    }
}

@end
