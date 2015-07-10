//
//  Constants.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 04.06.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (NSString*) fullNameForConst:(NSString*)constName {
    NSDictionary *dict = @{kCategoryRunnning:@"Running",
                           kCategoryWalking:@"Walking",
                           kCategoryHorse:@"Horse riding",
                           kCategorySkiing:@"Skiing",
                           kCategoryCycling:@"Cycling",
                           kCategorySailing:@"Sailing",
                           kCategoryClimbing:@"Climbing",
                           kCategoryWheelchair:@"Wheelchair",
                           kCategoryNordicWalking:@"Nordic walking",
                           kCategorySkateboarding:@"Skateboarding"};
    
    return dict[constName];
}

+ (NSString*) fullNameForMetrics:(BGSMetricsType)metricsType {
    NSArray *arr = @[@"Calories", @"Distance", @"Duration"];
    
    return arr[metricsType];
}

@end
