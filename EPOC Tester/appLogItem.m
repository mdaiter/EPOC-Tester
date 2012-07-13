//
//  appLogItem.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/11/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "appLogItem.h"

@implementation AppLogItem

-(id)init{
    if ([super init]){
        appName = [[NSString alloc] init];
        tim = 0;
        ratings = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initWithApp:(NSRunningApplication *)app AndTime:(int)time{
    if ([self init]){
        appName = [app localizedName];
        tim = time;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)coder{
    [coder encodeObject: appName forKey:@"appName"];
    [coder encodeObject: ratings forKey:@"ratings"];
    [coder encodeObject:titleArray forKey:@"titles"];
    [coder encodeObject:[NSNumber numberWithInt:tim] forKey:@"time"];
}

-(id)initWithCoder:(NSCoder*)coder{
    if (self = [super init]){
        self->titleArray = [coder decodeObjectForKey:@"titles"];
        self->appName = [coder decodeObjectForKey:@"appName"];
        self->ratings = [coder decodeObjectForKey:@"ratings"];
        self->tim = [[coder decodeObjectForKey:@"time"] intValue];
    }
    return self;
}

-(int)getTime{
    return tim;
}

-(NSMutableDictionary*)ratings{
    return ratings;
}

-(void)setDictionaryOfApp:(NSMutableDictionary *)dic{
    ratings = [NSDictionary dictionaryWithDictionary:dic];
}

-(void)setNameOfApp:(NSString *)nameOfApp{
    appName = [NSString stringWithString:nameOfApp];
}

-(void)setTime:(int)time{
    tim = time;
}

//Get total average and record for each emotion
-(void)updateWithDic:(NSMutableDictionary *)dic WithKey:(NSString *)key{
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
