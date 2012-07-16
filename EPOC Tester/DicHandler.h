//
//  DicHandler.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/5/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacialRecognition.h"

@interface DicHandler : NSObject{
@private
    NSMutableDictionary *dictionaries;
    NSMutableArray* angerArray;
    NSMutableArray* happyArray;
    NSMutableArray* timeArray;
    NSMutableArray* stressArray;

    FacialRecognition *faceRec;
    
    NSMutableArray* emotionsKeys;
    
    NSDate* date;
}

-(id)init;

-(NSMutableDictionary*)getDicHandler;

-(void)generatePoints;

-(NSMutableArray*)getEmotionsKeys;

@end
