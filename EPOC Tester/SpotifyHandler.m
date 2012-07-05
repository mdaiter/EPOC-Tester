//
//  SpotifyHandler.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/4/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "SpotifyHandler.h"
#import "SystemMonitor.h"

@implementation SpotifyHandler

-(id)init{
    if ([super init]){
        [[NSWorkspace sharedWorkspace] openFile:@"/Applications/Spotify.app"];
    }
    
    NSLog(@"Spotify has been awoken");
    
    element = [super frontMostApp];
    
    [self selectPlaylistForMoods];
    
    return self;
}

-(void)selectPlaylistForMoods{
    NSString* angerLevel = [mood objectForKey:@"Anger"];
    NSString* happinessLevel = [mood objectForKey:@"Happy"];
    
    NSArray *app = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.syntonetic.MoodagentPro"];
    NSLog(@"Current apps are: ");
    for (NSRunningApplication* a in app) {
        NSLog(@" %@", a.localizedName);
    }
}

@end
