//
//  DicHandler.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/5/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "DicHandler.h"

@implementation DicHandler

-(id)init{
    if ([super init]){
        //Init arrays
        angerArray = [[NSMutableArray alloc] init];
        happyArray = [[NSMutableArray alloc] init];
        timeArray = [[NSMutableArray alloc] init];
        stressArray = [[NSMutableArray alloc] init];
        
        //Init keys
        emotionsKeys = [[NSMutableArray alloc] initWithObjects:@"angry", @"happy", @"stressed", @"Time", nil];
        
        //Init dictionary that will hold everything
        dictionaries = [[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:angerArray, happyArray, stressArray, timeArray, nil] forKeys:[emotionsKeys copy]];
        
        //Date necessary for calculating time
        date = [NSDate date];
        
        [self generatePoints];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(generatePoints) userInfo:nil repeats:YES];
        
        faceRec = [[FacialRecognition alloc] init];
    }
    return self;
}

//Return "dictionaries"
-(NSMutableDictionary*)getDicHandler{
    return dictionaries;
}

-(NSMutableArray*)getEmotionsKeys{
    return emotionsKeys;
}

//Generate X & Y coords for graph
-(void)generatePoints{
    [self generateTime];
    [self generateFeelings];
}

//Generate coords for different feelings
-(void)generateFeelings{
    for (NSString* emo in emotionsKeys) {
        if (![emo isEqualToString:@"Time"]){
            NSMutableArray* temp = [dictionaries objectForKey:emo];
            [temp addObject:[self getDataFromSourceWithEmo:emo]];
            [dictionaries setObject:temp forKey:emo];
        }
    }
}

//Generate X-ccords, measured in time
-(void)generateTime{
    NSDateFormatter* formatter;
    NSString* timeString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm, MM-dd-yyyy"];
    
    timeString = [formatter stringFromDate:[NSDate date]];
    
    NSTimeInterval timeStamp = [date timeIntervalSinceNow];
    
    NSNumber *timeStampNum = [NSNumber numberWithDouble:timeStamp*(-1)];
    
    //Get update for time elapsed
    [timeArray addObject:timeStampNum];
    [dictionaries setObject:timeArray forKey:@"Time"];
}

//Get data from source
-(NSNumber*)getDataFromSourceWithEmo:(NSString*)emo{
    if ([emo isEqualToString:@"angry"]){
        return [NSNumber numberWithInt:70];
    }
    else{
        return [NSNumber numberWithInt:1];
    }
}

@end
