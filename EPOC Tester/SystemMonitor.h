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
#import <Growl/Growl.h>

@interface SystemMonitor : Handler <GrowlApplicationBridgeDelegate>{
    NSRunningApplication *app;
    NSDate* date;
    int appRunTime;
    int prevTimeElapsed;
    
    NSMutableDictionary* appLog;
    NSMutableDictionary* prevAppLog;
    BOOL updatingDics;
}

-(void)saveData;
-(void)getCurrApp:(NSTimer*)theTimer;
-(id)init;
-(AXUIElementRef)frontMostApp;
-(NSRunningApplication*)app;
-(NSMutableDictionary*)getAppLog;
-(NSMutableDictionary*)getPrevAppLog;
-(BOOL)updatingDics;

@end
