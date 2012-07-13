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
    [coder encodeObject:titles forKey:@"titles"];
    [coder encodeObject:[NSNumber numberWithInt:tim] forKey:@"time"];
}

-(id)initWithCoder:(NSCoder*)coder{
    if (self = [super init]){
        self->appName = [coder decodeObjectForKey:@"appName"];
        self->ratings = [coder decodeObjectForKey:@"ratings"];
        self->titles = [coder decodeObjectForKey:@"titles"];
        self->tim = [[coder decodeObjectForKey:@"time"] intValue];
        
        NSLog(@"Retrieved name: %@", appName);
        NSLog(@"Retrieved ratings: %@", ratings);
        NSLog(@"Retrieved titles: %@", titles);
        NSLog(@"Retrieved time: %d", tim);
    }
    return self;
}

-(NSMutableDictionary*)getTitles{
    return titles;
}

-(void)addTitle:(CFStringRef)title{
    [titles setObject:[NSMutableDictionary dictionary] forKey:(__bridge NSString*)(title)];
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

-(void)setCurrWindowName:(NSString *)name{
    currWindowName = name;
}

-(void)setNameOfApp:(NSString *)nameOfApp{
    appName = [NSString stringWithString:nameOfApp];
}

-(void)setTime:(int)time{
    tim = time;
}

-(NSString*)currWindowName{
    return currWindowName;
}

//Get total average and record for each emotion
-(void)updateWithDic:(NSMutableDictionary *)dic WithKey:(NSString *)key{
    /*
     * Updates dictionary for window and current title
     * First part updates app dic
     * Second part updates title dic
     */
    
    //First part
    
    //Will always be a mutable array
    NSMutableArray* arr = (NSMutableArray*)[dic objectForKey:key];
    //Need to take out value in place
    int y = [[ratings valueForKey:key] intValue] * (tim-1);
    int x = 0;
    
    x = (y + [[arr objectAtIndex:[arr count]-1] intValue]);
    
    NSLog(@"%d equals x", x);
    NSLog(@"%d equals time", tim);
    
    //Get average
    x = x / tim;
    
    //Set new value
    [ratings setValue:[NSNumber numberWithInt:x] forKey:key];
    NSLog(@"New value for %@ with key %@ is %d", appName, key, x);
    
    
    //Second part
    if (![[titles valueForKey:currWindowName] isEqual:nil]){
        int z = [[[titles valueForKey:currWindowName] valueForKey:key] intValue];
        z += [[arr objectAtIndex:([arr count]-1)] intValue];
        z = z / tim;
        [[titles valueForKey:currWindowName] setValue:[NSNumber numberWithInt:z] forKey:key];
        
    }
    else{
        int addedValue = [[arr objectAtIndex:([arr count]-1)] intValue];
        [[titles valueForKey:currWindowName] setValue:[NSNumber numberWithInt:addedValue] forKey:key];
    }
}

-(NSString*)getNameOfApp{
    return appName;
}

@end
