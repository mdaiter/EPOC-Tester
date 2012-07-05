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

        app = [[NSRunningApplication alloc] init];
        
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
    if (![app.localizedName isEqualToString:@""]){
        AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedWindowAttribute, (CFTypeRef*)&frontMostWindow);
        AXUIElementCopyAttributeValue(frontMostWindow, kAXTitleAttribute, (CFTypeRef*)&windowTitle);
        
        
        
        CFStringRef test = (CFStringRef)nil;
        
        if (test == NULL || CFStringGetLength(test) == 0){
            //Show strings
            //CFShow(windowTitle);
            NSLog((__bridge NSString*)test);
        }
    }
    
    SpotifyHandler *s = [[SpotifyHandler alloc] init];
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
