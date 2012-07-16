//
//  SystemResponder.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/13/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appLogItem.h"
#import <Growl/Growl.h>

@interface SystemResponder : NSObject <GrowlApplicationBridgeDelegate>{
@private
    NSMutableDictionary* changeLog;
    BOOL newData;
    NSString* currMood;
    NSMutableDictionary* ratingsCurrApp;
    unsigned int time;
}

-(void)checkForNewDataWith:(NSMutableDictionary*)dic AndApp:(NSRunningApplication*)app;

@end
