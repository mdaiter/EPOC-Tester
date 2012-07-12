//
//  SettingsDisplay.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/10/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface SettingsDisplay : NSViewController{
   IBOutlet NSWindow *window;
}

-(void)launch;

@end
