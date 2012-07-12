//
//  appLogItem.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/11/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLogItem : NSObject{
@private
    int tim;
    NSString* appName;
    
    NSMutableDictionary* ratings;
}

-(id)initWithApp:(NSRunningApplication*)app AndTime:(int)time;

-(int)getTime;

-(void)setTime:(int)time;

-(NSString*)getNameOfApp;

-(void)updateDic:(NSMutableDictionary*)dic WithKey:(NSString*)key;

@end
