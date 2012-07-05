//
//  PercentDisplay.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/2/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphDisplay.h"

@interface PercentDisplay : NSViewController{
@private
    NSStatusItem* statusItem;
    GraphDisplay *graph;
}

-(void)update:(id)sender;
-(void)display;

@end
