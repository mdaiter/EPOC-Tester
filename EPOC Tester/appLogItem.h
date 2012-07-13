//
//  appLogItem.h
//  EPOC Tester
//
//  Created by Matthew Daiter on 7/11/12.
//  Copyright (c) 2012 Matthew Daiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLogItem : NSObject{
@private
    //Amount of time the app's been open
    int tim;
    //App name
    NSString* appName;
    //Amount of titles that have been in the array
    NSMutableDictionary* titles;
    NSString* currWindowName;
    NSMutableDictionary* ratings;
}

-(id)initWithApp:(NSRunningApplication*)app AndTime:(int)time;

-(int)getTime;

-(NSString*)currWindowName;

-(void)setCurrWindowName:(NSString*)name;

-(void)setTime:(int)time;

-(NSString*)getNameOfApp;

-(NSMutableDictionary*)ratings;

-(NSMutableDictionary*)getTitles;

-(void)setNameOfApp:(NSString*)nameOfApp;

-(void)setDictionaryOfApp:(NSMutableDictionary*)dic;

-(void)updateWithDic:(NSMutableDictionary*)dic WithKey:(NSString*)key;

-(void)addTitle:(CFStringRef)title;

@end
