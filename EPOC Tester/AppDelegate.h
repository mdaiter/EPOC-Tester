//
//  AppDelegate.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 6/30/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PercentDisplay.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    PercentDisplay* percentView;
}

@property (assign) IBOutlet NSWindow *window;

@end
