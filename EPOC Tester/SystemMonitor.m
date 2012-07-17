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
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(getNewlyOpenedApp) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCurrApp:) userInfo:nil repeats:YES];
        
        @synchronized(self){
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(saveData) userInfo:nil repeats:YES];
        }
        
        app = [[NSRunningApplication alloc] init];
        
        //Date necessary for calculating time
        date = [NSDate date];
        
        prevTimeElapsed = 0;
        
        appLog = [[NSMutableDictionary alloc] init];
        
        [self loadData];
        
        sysResponder = [[SystemResponder alloc] init];
        
        // Register ourselves as a Growl delegate
        [GrowlApplicationBridge setGrowlDelegate:self];
        //Tell the user the graph has loaded
        [GrowlApplicationBridge notifyWithTitle:@"Graph loaded" description:@"Tracking data..." notificationName:@"Opening" iconData:nil priority:0 isSticky:NO clickContext:[NSDate date]];
       

        //[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(saveData) userInfo:nil repeats:YES];
    }
    return self;
}

//Load data in the beginning to get back data from previous session
-(void)loadData{
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"appLog"]){
        //
        appLog = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"appLog"]];
        
        NSLog(@"%ld apps loaded in total", [appLog count]);
    }
}

//Save data to place
-(void)saveData{    
    //Add latest app to app log
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:appLog] forKey:@"appLog"];
    NSLog(@"Saved data");
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
    
    //Update current app
    [self getCurrApp:nil];
}

-(BOOL)updatingDics{
    return updatingDics;
}

-(void)updateApps{
    AXUIElementRef systemWideElement = [self frontMostApp];
    AXUIElementRef frontMostWindow;
    AppLogItem* temp = [[AppLogItem alloc] initWithApp:app AndTime:0];
    CFStringRef windowTitle;
    CFStringRef documentURL;
    //Need Accessibility enabled
    if (!AXAPIEnabled()){
        [[NSWorkspace sharedWorkspace] openFile:@"/System/Library/PreferencePanes/UniversalAccessPref.prefPane"];
    }
    
    //If we need to ever manipulate windows
    if (![app.localizedName isEqualToString:@"EPOC Tester"]){
        AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedWindowAttribute, (CFTypeRef*)&frontMostWindow);
        AXUIElementCopyAttributeValue(frontMostWindow, kAXTitleAttribute, (CFTypeRef*)&windowTitle);
        AXUIElementCopyAttributeValue(frontMostWindow, kAXDocumentAttribute, (CFTypeRef*)&documentURL);
        /*if (windowTitle != NULL || CFStringGetLength(windowTitle) != 0){
         //Show strings
         CFShow(windowTitle);
         }*/
    }
    //If we've never seen the app before, add the time as zero. Otherwise, check if the app has the title in the dictionary
    if ([appLog objectForKey:[app localizedName]] == nil){
        //Add app with title to mutable dictionary
        [[temp getTitles] setObject:[NSMutableDictionary dictionary] forKey:(__bridge NSString*)windowTitle];
        [appLog setValue:temp forKey:[temp getNameOfApp]];
        NSLog(@"Never seen the app, but we're adding it!\n%@ is the name, %@ is the window!", [temp getNameOfApp], [[temp getTitles] objectForKey:(__bridge NSString*)windowTitle]);
    }
    else{
        //If we've never seen the title before, add it to the dictionary
        if ([[[appLog objectForKey:[app localizedName]] getTitles] objectForKey:(__bridge NSString*)windowTitle] == nil){
            [[[appLog objectForKey:[app localizedName]] getTitles] setObject:[NSMutableDictionary dictionary] forKey:(__bridge NSString*)windowTitle];
            NSLog(@"Seen the app, but we're adding it!\n%@ is the name, %@ is the window!", [app localizedName], [[[appLog objectForKey:[app localizedName]] getTitles] objectForKey:(__bridge NSString*)windowTitle]);
        }
        //If we've seen both the app and the title, don't do anything.
    }
    [[appLog objectForKey:[app localizedName]] setTime:[[appLog objectForKey:[app localizedName]] getTime]+1];
    
    //[sysResponder setURLFile:documentURL];
    
    CFRelease(windowTitle);
    CFRelease(frontMostWindow);
}
//Get current app
-(void)getCurrApp:(NSTimer*) theTimer{
    [self updateApps];
    [sysResponder checkForNewDataWith:appLog AndApp:app];
}
//Mark this as a newly opened app
-(void)getNewlyOpenedApp{
    NSLog(@"Getting the newly opened app.");
    [self updateApps];
    [sysResponder appChanged:true];
    [sysResponder checkForNewDataWith:appLog AndApp:app];
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
