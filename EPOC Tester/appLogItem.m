//
//  appLogItem.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/11/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "appLogItem.h"

@implementation AppLogItem

-(id)initWithApp:(NSRunningApplication *)app AndTime:(int)time{
    if ([super init]){
        appName = [app localizedName];
        
        tim = time;
        
        ratings = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(int)getTime{
    return tim;
}

-(void)setTime:(int)time{
    tim = time;
}

//Get total average and record for each emotion
-(void)updateDic:(NSMutableDictionary *)dic WithKey:(NSString *)key{
    //Will always be a mutable array
    NSMutableArray* arr = (NSMutableArray*)[dic objectForKey:key];
    //Need to take out value in place
    [ratings valueForKey:key];
    int x = 0;
    //Get average
    for (NSNumber* i in arr) {
        x = x + [i intValue];
    }
    x = x / [arr count];
    //Set new value
    [ratings setValue:[NSNumber numberWithInt:x] forKey:key];
    NSLog(@"New value for %@ with key %@ is %d", appName, key, x);
}

-(NSString*)getNameOfApp{
    return appName;
}

@end
