//
//  GraphDisplay.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/2/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "SystemMonitor.h"
#import "DicHandler.h"
#import "SettingsDisplay.h"

@interface GraphDisplay : NSViewController <NSPopoverDelegate, CPTScatterPlotDataSource, CPTScatterPlotDelegate, CPTPlotDataSource, CPTPlotSpaceDelegate>{
@private
    NSPopover *graphView;
    CPTGraphHostingView* hostView;
    CPTGraph* graph;
    CPTTheme* theme;
    NSButton* settingsButton;
    CGRect graphRect;
    BOOL firstTime;
    CPTPlot* plotData;
    SystemMonitor* sys;
    DicHandler *dicHand;
    SettingsDisplay* settings;
    
    NSThread *updateDicThread;
    
    CPTPlotSpaceAnnotation *annotation;
}

-(NSPopover*)getPopover;

-(void)setCurrentRect;

-(void)initGraph;

@end
