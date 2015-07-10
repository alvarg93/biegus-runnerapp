//
//  BGSStats.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 04.06.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "BGSStats.h"

@implementation BGSStats

+ (void) getStatsForYear:(NSInteger)year sport:(NSString*)sportType metrics:(BGSMetricsType)metricsType withCompletionBlock:(void (^)(NSArray* objects))block {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Run"];
    //get only current user's runs
    [query whereKey:@"TrackedBy" equalTo:[PFUser currentUser]];
    
    //set query to match year parameter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Warsaw"]];
    NSDate *startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"01-01-%lu 00:00", year]];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"31-12-%lu 23:59", year]];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:startDate];
    [query whereKey:@"createdAt" lessThanOrEqualTo:endDate];
    
    //set query to match sport parameter
    if (![sportType isEqualToString:kCategoryAllCategories]) [query whereKey:@"Type" equalTo:sportType];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //format output so we get only needed metrics
        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:12];
        
        for (NSInteger i = 1; i <= 12; i++) {
            NSDate *monthStart = [dateFormatter dateFromString:[NSString stringWithFormat:@"01-%lu-%lu 00:00",  i, year]];
            NSDate *monthEnd = [self endOfMonthOfDate:monthStart];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"createdAt BETWEEN { %@, %@ }", monthStart, monthEnd];
            NSArray *filtered = [objects filteredArrayUsingPredicate:pred];
            NSNumber *processedFiltered = nil;
            
            switch (metricsType) {
                case BGSMetricsTypeDistance:
                    processedFiltered = [filtered valueForKeyPath:@"@sum.Distance"];
                    break;
                    
                case BGSMetricsTypeCalories:
                    processedFiltered = [filtered valueForKeyPath:@"@sum.Calories"];
                    break;
                    
                case BGSMetricsTypeDuration:
                    processedFiltered = [filtered valueForKeyPath:@"@sum.Seconds"];
                    break;
                    
                default:
                    break;
            }
            
//            NSLog(@"%@", processedFiltered);
            [results insertObject:processedFiltered atIndex:i-1];
        }

        block(results);
    }];
}

+ (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd toDate:(NSDate*)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate: date options: 0];
}

+ (NSDate *) endOfMonthOfDate:(NSDate*)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 1 toDate:date];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
    
    return endOfMonth;
}

@end
