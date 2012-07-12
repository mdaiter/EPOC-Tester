//
//  SystemMonitor.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/3/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "SystemMonitor.h"

@implementation SystemMonitor

-(id)init{
    if ([super init]) {
        //Detect if any applications switched
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(appSwitched) name:NSWorkspaceDidActivateApplicationNotification object:nil];

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCurrApp:) userInfo:nil repeats:YES];
        
        app = [[NSRunningApplication alloc] init];
        
        //Date necessary for calculating time
        date = [NSDate date];
        
        prevTimeElapsed = 0;
        
        appLog = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSMutableArray*)getAppLog{
    return appLog;
}

-(NSRunningApplication*)app{
    return app;
}

//Need to manipulate when apps change
-(void)appSwitched{
    NSLog(@"App changed");
    
    //Get time variable
    int timeElapse = ([[self returnTimeStamp] intValue]- prevTimeElapsed);
    prevTimeElapsed = [[self returnTimeStamp] intValue];
    
    //Make new referenced app
    BOOL isRepeat = FALSE;
    
    //If previously stored in our array, just add time elapsed onto app
    for (AppLogItem* item in appLog){
        if ([[item getNameOfApp] isEqualToString:[app localizedName]]){
            isRepeat = TRUE;
            [item setTime:[item getTime]+timeElapse];
            NSLog(@"%d seconds added to %@", timeElapse, [item getNameOfApp]);
            NSLog(@"%d seconds in %@", [item getTime], [item getNameOfApp]);
        }
    }
    
    //If app is never seen before, ad it to the system
    if (isRepeat == FALSE){
        //Create new log item
        AppLogItem* temp = [[AppLogItem alloc] initWithApp:app AndTime:timeElapse];
        //Add app to mutable array
        [appLog addObject:temp];
        NSLog(@"Added %@ to array.\n%@ was open for %d seconds", [temp getNameOfApp], [temp getNameOfApp], [temp getTime]);
    }
    
    //Update current app
    [self getCurrApp:nil];
}

-(void)getCurrApp:(NSTimer*) theTimer{
    AXUIElementRef systemWideElement = [self frontMostApp];
    AXUIElementRef frontMostWindow;
    CFStringRef windowTitle;
    if (!AXAPIEnabled()){
        [[NSWorkspace sharedWorkspace] openFile:@"/System/Library/PreferencePanes/UniversalAccessPref.prefPane"];
    }
    
    //If we need to ever manipulate windows
    if (![app.localizedName isEqualToString:@"EPOC Tester"]){
        AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedWindowAttribute, (CFTypeRef*)&frontMostWindow);
        AXUIElementCopyAttributeValue(frontMostWindow, kAXTitleAttribute, (CFTypeRef*)&windowTitle);
                
        //if (windowTitle == NULL || CFStringGetLength(windowTitle) == 0){
            //Show strings
            //CFShow(windowTitle);
        //}
    }
}

-(NSNumber*)returnTimeStamp{
    NSDateFormatter* formatter;
    NSString* timeString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm, MM-dd-yyyy"];
    
    timeString = [formatter stringFromDate:[NSDate date]];
    
    NSTimeInterval timeStamp = [date timeIntervalSinceNow];
    
    return [NSNumber numberWithDouble:timeStamp*(-1)];
}

-(AXUIElementRef)frontMostApp{
    pid_t pid;
    ProcessSerialNumber psn;
    
    //Get front process and pid
    GetFrontProcess(&psn);
    GetProcessPID(&psn, &pid);
    
    //Get app
    app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    //Display app name
    NSLog(@"Current app is: %@", app.localizedName);
    
    return AXUIElementCreateApplication(pid);
    
}

@end
