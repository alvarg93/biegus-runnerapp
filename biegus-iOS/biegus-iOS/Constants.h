//
//  Constants.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 04.06.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCategoryRunnning @"running"
#define kCategorySkiing @"skiing"
#define kCategorySkateboarding @"skateboarding"
#define kCategoryClimbing @"climbing"
#define kCategoryCycling @"cycling"
#define kCategoryHorse @"horse"
#define kCategoryNordicWalking @"nordicwalking"
#define kCategorySailing @"sailing"
#define kCategoryWalking @"walking"
#define kCategoryWheelchair @"wheelchair"
#define kCategoryAllCategories @"all"

@interface Constants : NSObject

typedef NS_ENUM(NSInteger, BGSMetricsType) {
    BGSMetricsTypeCalories,
    BGSMetricsTypeDistance,
    BGSMetricsTypeDuration
};

+ (NSString*) fullNameForConst:(NSString*)constName;
+ (NSString*) fullNameForMetrics:(BGSMetricsType)metricsType;

@end
