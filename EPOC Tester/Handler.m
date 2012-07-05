//
//  Handler.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/5/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "Handler.h"

@implementation Handler

-(id)init{
    if ([super init]){
        
    }
    return self;
}

-(AXUIElementRef)frontMostApp{
    pid_t pid;
    ProcessSerialNumber psn;
    
    //Get front process and pid
    GetFrontProcess(&psn);
    GetProcessPID(&psn, &pid);
    
    return AXUIElementCreateApplication(pid);
}

-(NSDictionary*)assessMood:(NSData *)data{
    return [[NSDictionary alloc] init];
}

-(NSDictionary*)getMood{
    return mood;
}

@end
