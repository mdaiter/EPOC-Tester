//
//  EyeRecognition.m
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/6/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import "EyeRecognition.h"

CvCapture *capture;

@implementation EyeRecognition

-(id)init{
    if ([super init]){
        //vidCap = [[VideoCapture alloc] init];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(capImage) userInfo:nil repeats:YES];
    }
    return self;
}

-(IplImage*)convertNSImage:(NSBitmapImageRep*)rep{
    int depth = (int)[rep bitsPerSample];
    int channels = (int)[rep samplesPerPixel];
    int height = [rep size].height;
    int width = [rep size].width;
    
    IplImage* iplpic = cvCreateImage(cvSize(width, height), 8, channels);
    cvSetImageData(iplpic, [rep bitmapData], (int)[rep bytesPerRow]);
    
    //Give data to image
    for (int i = 0; 0 < iplpic->imageSize; i+=3){
        uchar tempR, tempG, tempB;
        tempR = iplpic->imageData[i];
        tempG = iplpic->imageData[i+1];
        tempB = iplpic->imageData[i+2];
        
        iplpic->imageData[i+2] = tempR;
        iplpic->imageData[i+1] = tempG;
        iplpic->imageData[i] = tempB;
    }
    
    return iplpic;
}

-(void)capImage{
    //Start video stream from web cam
    capture = cvCaptureFromCAM(0);
    
    
    cvNamedWindow("video");
    cvNamedWindow("thresh");
    cvNamedWindow("pupil");
    //Need a blank image
    IplImage *img = 0;
    
    //Stream images from webcam
    img = cvQueryFrame(capture);
    //img = cvLoadImage("/Users/darkstar/Documents/EPOC Tester/EPOC Tester/eye.jpg");
    //img = [self convertNSImage:[vidCap takePhoto]];
    
    cvShowImage("video", img);
    IplImage* imgscribble = cvCreateImage(cvGetSize(img), 8, 3);
    
    //Get thresholded image
    IplImage* imgPupilThresh = [self latestContourAl:img];
    
    cvAdd(img, imgscribble, img);
    cvShowImage("pupil", imgPupilThresh);
    cvShowImage("video", img);
    
    //Release stuff
    cvReleaseImage(&imgPupilThresh);
    //cvReleaseCapture(&capture);
    cvReleaseImage(&img);
    cvReleaseImage(&imgscribble);
}

-(IplImage*)extractContours:(IplImage*)image{
    CvMemStorage* memStorage = cvCreateMemStorage(0);
    CvSeq* contours = 0;
    cvFindContours(image, memStorage, &contours, sizeof(CvContour), CV_RETR_EXTERNAL);
    
    //If there are contours, extract the largest one
    if (contours){
        /*int max = 0;
        for (int i = 0; i < contours->total; i++){
            if (i > 0){
                NSLog(@"%f", cvContourArea(contours, CV_WHOLE_SEQ));
                if (cvContourArea(contours, CV_WHOLE_SEQ) < cvContourArea(contours->h_next, CV_WHOLE_SEQ)){
                    max = i;
                }
            }
        }
        
        NSLog(@"Largest one is: %d", max);*/
        cvDrawContours(image, contours, cvScalarAll(255), cvScalarAll(100), 100);
    }
    
    cvReleaseMemStorage(&memStorage);
    
    return image;
}

-(IplImage*)latestContourAl:(IplImage*)image{
    IplImage* eyeIm = [self findEyeInPhoto:image];
    //cvReleaseImage(&image);
    
    //Makes easier for computer to analyze
    cvEqualizeHist(eyeIm, eyeIm);
    cvSmooth(eyeIm, eyeIm, CV_GAUSSIAN, 5, 3);
    //cvAdaptiveThreshold(eyeIm, eyeIm, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, 3, 5);
    IplImage* edgePass = cvCreateImage(cvGetSize(eyeIm), 8, 1);
    
    //Use Sobel matrix and canny algorithm to extract lines
    cvSobel(eyeIm, edgePass, 0, 1, CV_SCHARR);
    IplImage* edge = cvCreateImage(cvGetSize(edgePass), 8, 1);
    cvConvertScale(edgePass, edge);
    //cvCanny(eyeIm, edge, 0, 255);
    cvDilate(edge, edge, NULL, 1);
    cvErode(edge, edge, NULL, 1);
    
    cvNamedWindow("Comparison");
    cvShowImage("Comparison", edge);
    
    //Extract contours
    return [self extractContours:edge];
}

//Finds eyes in image using Haarcascade (if ever need to fall back)
-(IplImage*)findEyeInPhoto:(IplImage*)image{
    //Get gray image
    IplImage* gray = cvCreateImage(cvSize(image->width, image->height), 8, 1);
    cvCvtColor(image, gray, CV_BGR2GRAY);
    double scale = 1.3;
    
    //Resize for haar trained cascade
    IplImage* small_img = cvCreateImage(cvSize(cvRound(image->width/scale), cvRound(image->height/scale)), 8, 1);
    cvResize(gray, small_img, CV_INTER_LINEAR);
    cvReleaseImage(&gray);
    
    
    CvMemStorage* storage = cvCreateMemStorage(0);
    
    CvHaarClassifierCascade* eyeCascade = (CvHaarClassifierCascade*)cvLoad("/Users/darkstar/Documents/EPOC Tester/EPOC Tester/HaarCascade/haarcascade_eye.xml", 0, 0, 0);
    
    CvSeq* eyes = cvHaarDetectObjects(small_img, eyeCascade, storage, 1.1, 3, 0, cvSize(60, 60));
    
    if (eyes){
        for (int i = 0; i < eyes->total; i++){
            CvRect* r = (CvRect*)cvGetSeqElem(eyes, i);
            cvRectangle(small_img, cvPoint(r->x,r->y), cvPoint(r->x+r->width, r->y+r->height), cvScalar(255, 255,0));
            cvSetImageROI(small_img, cvRect(r->x, r->y + (r->height/5.5), r->width, r->height));
            //cvReleaseData(&r);
        }
    }
    
    cvClearMemStorage(storage);
    cvReleaseMemStorage(&storage);
    //cvReleaseData(&eyes);
    cvReleaseHaarClassifierCascade(&eyeCascade);
    
    return small_img;
}

//Get the black pupil from the image
-(IplImage*)getThresholdedImage:(IplImage*)img{
    //Make new image to hold HSV equiv.
    IplImage *imgHSV = cvCreateImage(cvGetSize(img), 8, 3);
    //Convert RGB
    cvCvtColor(img, imgHSV, CV_BGR2HSV);
    //Create new image for threshold
    IplImage *imgThresh = cvCreateImage(cvGetSize(img), 8, 1);
    //Compare the pixels from the lower scalar to the upper scalar
    cvInRangeS(imgHSV, cvScalar(0, 84, 0, 0), cvScalar(179, 256, 11, 0), imgThresh);
    //Don't need HSV image anymore, release it
    cvReleaseImage(&imgHSV);
    //Return the image we were looking for
    return imgThresh;
}

@end
