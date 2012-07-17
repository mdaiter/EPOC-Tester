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
    ratingsCurrApp = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSMutableDictionary* currApp = [[ratingsCurrApp objectForKey:[ap localizedName]] ratings];
    for (NSString* str in currApp){
        NSLog(@"Mood in app is: %@", str);
        if (max < [[currApp objectForKey:str] intValue]){
            max = [[currApp objectForKey:str] intValue];
            currMood = str;
            NSLog(@"MAX MOOD IS NOW: %@", currMood);
        }
    }
}

-(void)appChanged:(BOOL)bo{
    appChanged = bo;
}

-(void)checkForNewDataWith:(NSMutableDictionary *)dic AndApp:(NSRunningApplication *)app{
    if (time == 0){
        //If the time has reached three minutes, check about the app
        [self updateResultsWithDic:dic AndApp:app];
        [self respondToDataWithEmotion:currMood AndDic:ratingsCurrApp AndApp:app];
        time = 5;
    }
    else{
        NSLog(@"%d before next update", time);
        time--;
    }
}

-(void)setURLFile:(CFStringRef)urlFile{
    url = urlFile;
}

-(void)respondToDataWithEmotion:(NSString*)emotion AndDic:(NSMutableDictionary*)dict AndApp:(NSRunningApplication*)ap{
    // Register ourselves as a Growl delegate
    [GrowlApplicationBridge setGrowlDelegate:self];
    
    NSString* appToLaunch = [[NSString alloc] init];
    //If the app just launched, then handle responsibly and see if the person likes or does not like said app
    if (appChanged == TRUE){
        if ([emotion isEqualToString:@"angry"]){
            /*
             * Got this from Stack Overflow. Thanks Bryan Kyle! Gets all apps that can open speficied file
             */
            NSArray* allApps = (__bridge NSArray *)(LSCopyApplicationURLsForURL(CFURLCreateWithString(kCFAllocatorDefault, url, 0), kLSRolesAll));
            
            NSLog(@"%@ is the default app for this bundled id: %@", allApps, [ap bundleIdentifier]);
            
            //Don't get the default...
            
            NSString* path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:[allApps objectAtIndex:0]];
            appToLaunch = [[NSFileManager defaultManager] displayNameAtPath:path];
            
            [GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"You seem %@ when using %@", emotion, [ap localizedName]] description:[NSString stringWithFormat:@"Do you want to open %@ instead?\nIt might be a better option", appToLaunch] notificationName:@"Opening" iconData:[[ap icon] TIFFRepresentation] priority:0 isSticky:NO clickContext:[NSDate date]];
            
            appChanged = FALSE;
            //CFRelease(url);
        }
    }
    else{
        
    }
}

-(void)growlNotificationWasClicked:(id)clickContext{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"AppLauncher" ofType:@"scpt"];
    if (path){
        NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        NSAppleScript* script2 = [[NSAppleScript alloc] initWithSource:@"do shell script \"open -a iCal\""];
    //    NSLog(@"result = %@", result);
        NSLog(@"%@'s string value", [[script executeAndReturnError:nil] stringValue]);
    }
}

@end
