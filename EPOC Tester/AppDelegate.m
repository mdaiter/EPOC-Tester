//
//  AppDelegate.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 6/30/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    percentView = [[PercentDisplay alloc] init];
    [percentView display];
}

@end
