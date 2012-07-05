//
//  PercentDisplay.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/2/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "PercentDisplay.h"

@implementation PercentDisplay

-(id)init{
    if ([super initWithNibName:@"PercentDisplay" bundle:nil]){
        graph = [[GraphDisplay alloc] init];
    }
    return self;
}

-(void)display{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:TRUE];
    [statusItem setTitle:@"0.0.0.0"];
    [statusItem setEnabled:TRUE];
    [statusItem setAction:@selector(update:)];
    [statusItem setTarget:self];
    
    
    NSLog(@"I HAVE BEEN AWOKEN");
}

-(void)update:(id)sender{
    NSString* ipAddr = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://highearthorbit.com/service/myip.php"]];
    if (ipAddr != nil){
        [statusItem setTitle:ipAddr];
    }
    
    //show graph
    [[graph getPopover] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    [graph setCurrentRect];
}

@end
