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
#import "SystemResponder.h"
#import <Growl/Growl.h>

@interface SystemMonitor : Handler <GrowlApplicationBridgeDelegate>{
@private
    NSRunningApplication *app;
    NSDate* date;
    int appRunTime;
    int prevTimeElapsed;
    
    NSMutableDictionary* appLog;
    BOOL updatingDics;
    SystemResponder* sysResponder;
}

-(void)saveData;
-(void)getCurrApp:(NSTimer*)theTimer;
-(id)init;
-(AXUIElementRef)frontMostApp;
-(NSRunningApplication*)app;
-(NSMutableDictionary*)getAppLog;
-(BOOL)updatingDics;

@end
