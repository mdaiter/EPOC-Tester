//
//  GraphDisplay.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/2/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface GraphDisplay : NSViewController <NSPopoverDelegate, CPTPlotDataSource>{
@private
    NSPopover *graphView;
    CPTGraphHostingView* hostView;
    CPTGraph* graph;
    CPTTheme* theme;
    CGRect graphRect;
    BOOL firstTime;
    CPTPlot* plotData;
}

-(NSPopover*)getPopover;

-(void)setCurrentRect;

-(void)initGraph;

@end
