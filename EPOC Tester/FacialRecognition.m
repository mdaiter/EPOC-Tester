//
//  FacialRecognition.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

/*
 * Meant as a coupling class between CIDetector + OpenCV, eye and face, etc.
 */

#import "FacialRecognition.h"

@implementation FacialRecognition

-(id)init{
    if ([super init]){
        smileRec = [[SmileRecognition alloc] init];
        eyeRec = [[EyeRecognition alloc] init];
        faceComComm = [[FaceComComm alloc] init];
    }
    return self;
}

@end
