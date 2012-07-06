//
//  FaceComComm.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//
// Face.com talker

#import "FaceComComm.h"

@implementation FaceComComm

-(id)init{
    if ([super init]){
        vidCap = [[VideoCapture alloc] init];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendOutFaceCom) userInfo:nil repeats:YES];
    
    return self;
}

-(void)sendOutFaceCom{
    //Get image from current rolling stream buffer
    NSData* image = [vidCap takeImage];
    
    //URL for Face.com json array
    NSURL* url = [[NSURL alloc] initWithString:@"http://api.face.com/faces/detect.json"];
    
    //Request that will be sent to Face.com
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    /*
     The message we're sending to Face.com right now
     Basically trying to add our stuff to a request and requesting a return value json array.
     */
    [request addPostValue:@"51974f1616910079824db30a0057844d" forKey:@"api_key"];
    [request addPostValue:@"32950d9caf72376e7c53da39fc9c5c6e" forKey:@"api_secret"];
    [request addPostValue:@"all" forKey:@"attributes"];
    [request addData:image withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"filename"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(postFinished:)];
    
    [request startAsynchronous];
}

-(void)postFinished:(ASIHTTPRequest*)request{
    NSString* response = [request responseString];
    
    NSDictionary* feed = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
    
    NSLog(@"%@",[feed allKeys]);
    
    NSLog(@"%@", response);
    
    NSString *smiling = [[[[[[[feed objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"tags"] objectAtIndex:0] objectForKey:@"attributes"] objectForKey:@"smiling"] objectForKey:@"value"];
    
    NSLog(@"Smiling is: %@", smiling);
}

@end
