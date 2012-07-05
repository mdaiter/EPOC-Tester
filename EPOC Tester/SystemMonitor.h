//
//  SystemMonitor.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/3/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Handler.h"

@interface SystemMonitor : Handler{
    NSRunningApplication *app;
}

-(void)getCurrApp:(NSTimer*)theTimer;
-(id)init;
-(AXUIElementRef)frontMostApp;

@end
