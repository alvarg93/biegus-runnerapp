//
//  HistoryCell.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>
#import <MapKit/MapKit.h>

@interface HistoryCell : PFTableViewCell

@property float distance;
@property int seconds;
@property NSString *sportType;
@property NSDate *dateOfRun;
@property NSArray *recordedRun;
@property CLLocationSpeed maxSpeed;
@property CLLocationSpeed minSpeed;

- (void) prepareCell;

@end
