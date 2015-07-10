//
//  BGSStats.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 04.06.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface BGSStats : NSObject

+ (void) getStatsForYear:(NSInteger)year sport:(NSString*)sportType metrics:(BGSMetricsType)metricsType withCompletionBlock:(void (^)(NSArray* objects))block;

@end
