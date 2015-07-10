//
//  LocationManager.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 23.04.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface LocationManager : NSObject

@property CLLocationManager *locationManager;
@property (readonly) NSMutableArray *recordedRun;
@property (readonly) NSMutableArray *locationsTimes;
@property (readonly) CLLocation *lastLocation;
@property (readonly) CLLocationSpeed currentSpeed;
@property (readonly) CLLocationSpeed maximumSpeed;
@property (readonly) CLLocationSpeed minimumSpeed;
@property (readonly) float minimumVelocity;
@property (readonly) float maximumVelocity;
@property float distance;

+ (id) sharedManager;

- (void) startRecording;
- (void) stopRecording;

@end
