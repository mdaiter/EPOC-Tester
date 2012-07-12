//
//  SystemMonitor.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/3/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Handler.h"
#import "appLogItem.h"

@interface SystemMonitor : Handler{
    NSRunningApplication *app;
    NSDate* date;
    int appRunTime;
    int prevTimeElapsed;
    
    NSMutableArray* appLog;
}

-(void)getCurrApp:(NSTimer*)theTimer;
-(id)init;
-(AXUIElementRef)frontMostApp;
-(NSRunningApplication*)app;
-(NSMutableArray*)getAppLog;

@end
