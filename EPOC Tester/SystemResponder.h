//
//  SystemResponder.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/13/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemResponder : NSObject{
@private
    NSMutableDictionary* changeLog;
    BOOL newData;
}

-(void)checkForNewDataWith:(NSMutableDictionary*)dic AndApp:(NSRunningApplication*)app;

-(void)respondToData;

@end
