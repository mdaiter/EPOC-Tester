//
//  SystemMonitor.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/3/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "SystemMonitor.h"
#import "SpotifyHandler.h"

@implementation SystemMonitor

-(id)init{
    if ([super init]) {
        //Detect if any applications switched
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(getCurrApp:) name:NSWorkspaceDidActivateApplicationNotification object:nil];

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCurrApp:) userInfo:nil repeats:YES];
        
        app = [[NSRunningApplication alloc] init];
        
        mood = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:2], nil] forKeys:[[NSArray alloc] initWithObjects:@"Angry", nil]];
    }
    return self;
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
            CFShow(windowTitle);
        //}
    }
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
    NSLog(@"The name is: %@", app.localizedName);
    
    return AXUIElementCreateApplication(pid);
    
}

@end
