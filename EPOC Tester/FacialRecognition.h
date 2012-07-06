//
//  FacialRecognition.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmileRecognition.h"
#import "EyeRecognition.h"
#import "FaceComComm.h"

@interface FacialRecognition : NSObject{
    SmileRecognition* smileRec;
    EyeRecognition* eyeRec;
    FaceComComm *faceComComm;
}

@end
