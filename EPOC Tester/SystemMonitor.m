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
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(getCurrApp:) name:NSWorkspaceDidActivateApplicationNotification object:nil];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCurrApp:) userInfo:nil repeats:YES];
        
        app = [[NSRunningApplication alloc] init];
    }
    return self;
}

-(void)getCurrApp:(NSTimer*) theTimer{
    //wait five seconds before doing anything
    
    for (int i = 0; i < 2; i++){
        sleep(1);
    }
    
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
    
        //Show strings
        CFShow(windowTitle);
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
