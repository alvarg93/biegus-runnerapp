//
//  RunDetailsViewController.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RunDetailsViewController : UIViewController

@property int seconds;
@property float distance;
@property NSArray *recordedRun;
@property NSString *sportType;
@property CLLocationSpeed maximumSpeed;
@property CLLocationSpeed minimumSpeed;

@property BOOL shouldShowButtons;

@end
