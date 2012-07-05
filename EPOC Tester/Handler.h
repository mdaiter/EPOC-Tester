//
//  Handler.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/5/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Handler : NSObject{
@protected
    pid_t currentAppPID;
    AXUIElementRef element;
    NSDictionary* mood;
}

-(AXUIElementRef)frontMostApp;

-(NSDictionary*)assessMood:(NSData*)data;

-(NSDictionary*)getMood;

@end
