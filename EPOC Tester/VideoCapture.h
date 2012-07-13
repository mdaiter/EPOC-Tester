//
//  VideoCapture.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@interface VideoCapture : NSObject{
    QTCaptureSession *captureSession;
    QTCaptureMovieFileOutput *movieFileOutput;
    QTCaptureDeviceInput *videoDeviceInput;
    
    //Stuff to take images
    QTCaptureDecompressedVideoOutput *vidOutput;
    CVImageBufferRef currImage;
    
    
    NSThread* thread;
}

-(id)init;

-(NSBitmapImageRep*)takePhoto;

-(NSData*)takeImage;

@end
