//
//  GraphDisplay.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/2/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "GraphDisplay.h"

@implementation GraphDisplay

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index{
    NSLog(@"scatterPlotSymbolMethodSelected");
    NSLog(@"Touched by me: index = %ld", index);
    
    //Remove current annotation if there is one
    if (annotation){
        [[[graph plotAreaFrame] plotArea] removeAnnotation:annotation];
        annotation = NULL;
    }
    
    //Create text style
    CPTMutableTextStyle *annotationStyle = [CPTMutableTextStyle textStyle];
    annotationStyle.color = [CPTColor blackColor];
    annotationStyle.fontSize = 12.0f;
    annotationStyle.fontName = @"Arial";
    
    //Log the right name
    NSLog(@"%@", [plot identifier]);
    
    //Get cords for annotation
    NSNumber *x = [[[dicHand getDicHandler] objectForKey:@"Time"] objectAtIndex:index];
    NSNumber* y = [[[dicHand getDicHandler] objectForKey:[plot identifier]] objectAtIndex:index];
    NSArray* arr = [NSArray arrayWithObjects:x, y, nil];
    
    
    //Make string for annotation
    //Get the name of our plot's identifier (need to do it this way. Getting errors the other way.)
    NSString* plotName = [[NSString alloc] initWithString:[plot identifier]];
    //Get level measurment of emotion
    NSString* level = [[NSString alloc] initWithFormat:@"%@", y];
    
    NSString* appName;
    int time = 0;
    for (int i = 0; i < [[s getAppLog] count]; i++){
        time += [[[s getAppLog] objectAtIndex:i] getTime];
        if (time >= [x intValue]){
            appName = [[[s getAppLog] objectAtIndex:i] getNameOfApp];
            break;
        }
    }
    
    NSString* valueAnnotContent = [[NSString alloc] initWithFormat:@"%@\n%@\n%@", plotName, level, appName];
    
    //Make annotation and add to graph
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:valueAnnotContent style:annotationStyle];
    annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:[graph defaultPlotSpace] anchorPlotPoint:arr];
    annotation.contentLayer = textLayer;
    annotation.displacement = CGPointMake(0.0f, 20.0f);
    
    [[[graph plotAreaFrame] plotArea] addAnnotation:annotation];
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point{
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point{
    return YES;
}

-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point{
    return YES;
}

-(id)init{
    if ([super init]) {
        //NSPopover allocatd space and initiated
        graphView = [[NSPopover alloc] init];
        graphView.appearance = NSPopoverAppearanceMinimal;
        graphView.animates = TRUE;
        [graphView setContentViewController:self];
        graphView.behavior = NSPopoverBehaviorTransient;
        graphView.delegate = self;
        [graphView setContentSize:NSMakeSize(400.0f, 450.0f)];
        firstTime = FALSE;
        
        //Instantiate other objects necessary
        s = [[SystemMonitor alloc] init];
        
        dicHand = [[DicHandler alloc] init];
        
        //Reload graph data every second
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(graphReloadData) userInfo:nil repeats:YES];
        
        [self createSettings];
    }
    return self;
}

-(void)launchSettings:(id)sender{
    
}

-(void)createSettings{
    settingsButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 50)];
    [[[graphView contentViewController] view] addSubview:settingsButton];
    [settingsButton setTitle:@"Settings"];
    [settingsButton setTarget:self];
    [settingsButton setButtonType:NSMomentaryLightButton];
    [settingsButton setBezelStyle:NSTexturedSquareBezelStyle];
    [settingsButton setAction:@selector(launchSettings:)];

    settings = [[SettingsDisplay alloc] initWithNibName:@"Settings" bundle:nil];
}

-(void)graphReloadData{
    //Reload the graph data
    [graph reloadData];
    //Reload the buttons
    NSLog(@"Reloading data");
}

-(NSPopover*)getPopover{
    return graphView;
}

-(void)setCurrentRect{
    //Get rect inside popover
    graphRect = graphView.contentViewController.view.bounds;
    graphRect.size.height = graphRect.size.height - 50.0f;
    graphRect.origin.y = 50;
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
        textStyle.fontName = @"Arial";
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
        axisSet.xAxis.minorTicksPerInterval = 5;
        axisSet.xAxis.title = @"Time";
        //axisSet.xAxis.titleOffset = 40.0f;
        
        axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(10);
        axisSet.yAxis.minorTicksPerInterval = 1;
        axisSet.yAxis.title = @"Emotions";
        //axisSet.xAxis.titleOffset = 30.0f;
        
        graph.delegate = self;
        graph.drawsAsynchronously = YES;
        
        [self addDataToGraph];
    }
}

-(CPTScatterPlot*)createScatterPlotWithId:(NSString*)str{
    CPTScatterPlot *data = [[CPTScatterPlot alloc] init];
    data.dataSource = self;
    data.delegate = self;
    data.identifier = str;
    data.plotSymbolMarginForHitDetection = 10.0f;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor redColor];
    
    data.dataLineStyle = lineStyle;
    
    //[[graph defaultPlotSpace] scaleToFitPlots:[NSArray arrayWithObject:data]];
    
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
        //Make sure we have the right coordinate
        NSLog(@"%@ coord is: %@",[plot identifier], [[[dicHand getDicHandler] objectForKey:[plot identifier]] objectAtIndex:index]);
        
        //Computate average levels of irritation after adding plot
        for (AppLogItem* item in [s getAppLog]) {
            NSLog(@"Current app id:%@\nCurrent localized name:%@", [item getNameOfApp], [[s app] localizedName]);
            if ([[[s app] localizedName] isEqualToString:[item getNameOfApp]]){
                NSLog(@"Hit this point!! Updating the dic");
                //Update the dictionary for the right app with the given key and value
                [item updateDic:[dicHand getDicHandler] WithKey:[NSString stringWithFormat:@"%@", [plot identifier]]];
            }
        }
        
        //Return the coordinate
        return [[[dicHand getDicHandler] objectForKey:[plot identifier]] objectAtIndex:index];
    }
}

@end
