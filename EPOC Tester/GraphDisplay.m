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
        graph.paddingBottom = 0.0f;
        graph.paddingLeft = 0.0f;
        graph.paddingRight = 0.0f;
        graph.paddingTop = 0.0f;
        graph.axisSet = nil;
        graph.title = @"Brainwave Measure";
    
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.color  = [CPTColor grayColor];
        textStyle.fontName = @"Helvetica-Bold";
        textStyle.fontSize = 16.0f;
    
        graph.titleTextStyle = textStyle;
        graph.titlePlotAreaFrameAnchor =CPTRectAnchorTop;
        graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    
        theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
        [graph applyTheme:theme];
        
        //Create plot space
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*) graph.defaultPlotSpace;
        plotSpace.allowsUserInteraction = YES;
        
        
        CPTScatterPlot *dataSource = [[CPTScatterPlot alloc] init];
        dataSource.dataSource = self;
        
        [graph addPlot:dataSource toPlotSpace:plotSpace];
        
        [plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSource]];
        
        
        
    }
}

-(void)drawLines{
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return 12;
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    return [NSNumber numberWithInt:3];
}

@end
