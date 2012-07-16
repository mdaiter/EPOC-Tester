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
        currMood = [[NSString alloc] init];
        time = 5;
        ratingsCurrApp = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)updateResultsWithDic:(NSMutableDictionary*)dict AndApp:(NSRunningApplication*)ap{
    int max = 0;
    [ratingsCurrApp removeAllObjects];
    ratingsCurrApp = [[dict objectForKey:[ap localizedName]] ratings];
    for (NSString* str in ratingsCurrApp){
        NSLog(@"Mood in app is: %@", str);
        if (max < [[ratingsCurrApp objectForKey:str] intValue]){
            max = [[ratingsCurrApp objectForKey:str] intValue];
            currMood = str;
            NSLog(@"MAX MOOD IS NOW: %@", currMood);
        }
    }
}

-(void)checkForNewDataWith:(NSMutableDictionary *)dic AndApp:(NSRunningApplication *)app{
    if (time == 0){
        //If the time has reached three minutes, check about the app
        [self updateResultsWithDic:dic AndApp:app];
        [self respondToDataWithEmotion:currMood AndDic:ratingsCurrApp];
        time = 5;
    }
    else{
        NSLog(@"%d before next update", time);
        time--;
    }
}

-(void)respondToDataWithEmotion:(NSString*)emotion AndDic:(NSMutableDictionary*)dict{
    // Register ourselves as a Growl delegate
    [GrowlApplicationBridge setGrowlDelegate:self];
    
    if ([emotion isEqualToString:@"Angry"]){
        
    }
    
    //Tell the user the graph has loaded
    [GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"You seem %@", emotion] description:@"So..." notificationName:@"Opening" iconData:nil priority:0 isSticky:NO clickContext:[NSDate date]];
    
   
}

@end
