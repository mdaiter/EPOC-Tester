//
//  SystemResponder.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/13/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "SystemResponder.h"

@implementation SystemResponder

-(id)init{
    if ([super init]){
        changeLog = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)checkForNewDataWith:(NSMutableDictionary *)dic AndApp:(NSRunningApplication *)app{
    
}

-(void)respondToData{
    
}

@end
