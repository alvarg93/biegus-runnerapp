//
//  BGSMath.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BGSMath : NSObject

+ (NSNumber*)caloriesFromDist:(float)meters overTime:(int)seconds;
+ (NSString *)stringifyCaloriesFromDist:(float)meters overTime:(int)seconds;
+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;

@end
