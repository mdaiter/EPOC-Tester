//
//  EyeRecognition.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "EyeRecognition.h"

@implementation EyeRecognition

-(id)init{
    if ([super init]){
        //vidCap = [[VideoCapture alloc] init];
        CvCapture *capture = cvCaptureFromCAM(0);
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(capImage) userInfo:nil repeats:YES ];
    }
    return self;
}

-(void)capImage{
    CvCapture *capture = cvCaptureFromCAM(0);
}
@end
