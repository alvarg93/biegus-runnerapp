//
//  BGSMath.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "BGSMath.h"

@implementation BGSMath

+ (NSNumber*) caloriesFromDist:(float)meters overTime:(int)seconds {
    float avgVelocity = meters/seconds;
    
    //    x = 0.064 dla predkosci do 2,68224m/s
    //    x=0.079 dla predkosci od 2,68224 do 4,4704 m/s
    //    x=0.1 dla prędkości od 4,4704m/s do 5,36448056 m/s
    //    x=0.13 dla prędkości od 5,36448056 m/s
    
    float xFactor = 0;
    if (avgVelocity < 2.68224) {
        xFactor = 0.064;
    } else if (avgVelocity < 4.4704) {
        xFactor = 0.079;
    } else if (avgVelocity < 5.36448056) {
        xFactor = 0.1;
    } else {
        xFactor = 0.13;
    }
    
    float weight = [[[PFUser currentUser] objectForKey:@"weight"] floatValue];
    float kcal = xFactor * seconds/60 * weight * 2.20462262;
    return [NSNumber numberWithFloat:kcal];
}

+ (NSString *)stringifyCaloriesFromDist:(float)meters overTime:(int)seconds {
    return [NSString stringWithFormat:@"kcal: %.2f", [[self caloriesFromDist:meters overTime:seconds] floatValue]];
}

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds
{
    if (seconds == 0 || meters == 0) {
        return @"0 min/km";
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    int paceMin = (int) ((avgPaceSecMeters * 1000) / 60);
    int paceSec = (int) (avgPaceSecMeters * 1000 - (paceMin*60));
    
    NSString *unitName = @"min/km";
    return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat
{
    int remainingSeconds = seconds;
    int hours = remainingSeconds / 3600;
    remainingSeconds = remainingSeconds - hours * 3600;
    int minutes = remainingSeconds / 60;
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}

@end
