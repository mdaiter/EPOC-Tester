//
//  VideoCapture.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "VideoCapture.h"

@implementation VideoCapture

-(id)init{
    if ([super init]){
        captureSession = [[QTCaptureSession alloc] init];
        
        NSError *error;
        
        QTCaptureDevice *videoDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
        
        if (![videoDevice open:&error]){
            videoDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeMuxed];
        }
        
        if (![videoDevice open:&error]){
            NSLog(@"Failed to open video device.");
        }
        
        videoDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:videoDevice];
        
        [captureSession addInput:videoDeviceInput error:&error];
    
        vidOutput = [[QTCaptureDecompressedVideoOutput alloc] init];
        
        [vidOutput setDelegate:self];
        
    if (![captureSession addOutput:vidOutput error:&error]){
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
        [captureSession startRunning];
    }
    
    
    thread = [[NSThread alloc] init];
    
    currImage = nil;
    
    return self;
}


/*
 * Stuff from Apple docs. Basically called every frame. Takes pictures.
 */
-(void)captureOutput:(QTCaptureOutput *)captureOutput didOutputVideoFrame:(CVImageBufferRef)videoFrame withSampleBuffer:(QTSampleBuffer *)sampleBuffer fromConnection:(QTCaptureConnection *)connection{
    
    CVBufferRetain(videoFrame);
    
    @synchronized(self){
        currImage = videoFrame;
    }
    
    if (currImage){
        NSLog(@"Took picture");
    }
}

//Check if there's actually a face in the photo. If not, don't send it to any face detector classes
-(BOOL)detectFaces:(CIImage*)buff{
    NSLog(@"Searching for faces...");
    CIDetector* faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    NSArray* features = [faceDetector featuresInImage:buff];
    
    if (features != nil && [features count] > 0){
        NSLog(@"Detected faces!");
        return TRUE;
    }
    else{
        return FALSE;
    }
}

-(NSBitmapImageRep*)takePhoto{
    CIImage* image = [CIImage imageWithCVImageBuffer:currImage];
    if ([self detectFaces:image]){
        //CONVERSIONS!!!!
        NSCIImageRep *imageRep = [NSCIImageRep imageRepWithCIImage:image];
        
        NSImage* tempImage = [[NSImage alloc] initWithSize:[imageRep size]];
        [tempImage addRepresentation:imageRep];
        NSData* bitmapData = [tempImage TIFFRepresentation];
        NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:bitmapData];
        
        CVBufferRelease(currImage);
        
        NSLog(@"Returning image");
        
        return bitmapRep;
    }
    else{
        return nil;
    }
}

//Taken from tutorial (mostly). Takes currImage and converts to NSImage (easier to work with).
-(NSData*)takeImage{
    CIImage* image = [CIImage imageWithCVImageBuffer:currImage];
    if ([self detectFaces:image]){
        //CONVERSIONS!!!!
        NSCIImageRep *imageRep = [NSCIImageRep imageRepWithCIImage:image];
        
        NSImage* tempImage = [[NSImage alloc] initWithSize:[imageRep size]];
        [tempImage addRepresentation:imageRep];
        
        NSData* bitmapData = [tempImage TIFFRepresentation];
        NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:bitmapData];
        NSData *imageData = [bitmapRep representationUsingType:NSJPEGFileType properties:nil];
                
        CVBufferRelease(currImage);
        
        NSLog(@"Returning image");
        
        return imageData;
    }
    else{
        return nil;
    }
}

@end