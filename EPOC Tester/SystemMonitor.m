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
        
        prevAppLog = [[NSMutableDictionary alloc] init];
        
        appLog = [[NSMutableDictionary alloc] init];
        
        [self loadData];
        
        // Register ourselves as a Growl delegate
        [GrowlApplicationBridge setGrowlDelegate:self];
        [GrowlApplicationBridge notifyWithTitle:@"Graph loaded" description:@"Tracking data..." notificationName:@"Opening" iconData:nil priority:0 isSticky:NO clickContext:[NSDate date]];
       

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(saveData) userInfo:nil repeats:YES];
    }
    return self;
}

-(NSMutableDictionary*)getPrevAppLog{
    return prevAppLog;
}

//Load data in the beginning to get back data from previous session
-(void)loadData{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"appLog"]){
        //
        appLog = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"appLog"]];
        
        NSLog(@"%ld apps loaded in total", [appLog count]);
    }
}

//Save data to place
-(void)saveData{    
    //Add latest app to app log
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:appLog] forKey:@"appLog"];
}

-(NSMutableDictionary*)getAppLog{
    return appLog;
}

-(NSRunningApplication*)app{
    return app;
}

//Need to manipulate when apps change
-(void)appSwitched{
    NSLog(@"App changed");
    
    if ([appLog count] != 0){
    
        //Get time variable
        int timeElapse = ([[self returnTimeStamp] intValue]- prevTimeElapsed);
        prevTimeElapsed = [[self returnTimeStamp] intValue];
    
        int currTime = [[appLog objectForKey:[app localizedName]] getTime];
        
        [[appLog objectForKey:[app localizedName]] setTime:currTime + timeElapse];
    }
    //Update current app
    [self getCurrApp:nil];
}

-(BOOL)updatingDics{
    return updatingDics;
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
    AppLogItem* temp = [[AppLogItem alloc] initWithApp:app AndTime:0];
    
    //Add app to mutable dictionary
    [appLog setValue:temp forKey:[temp getNameOfApp]];
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
