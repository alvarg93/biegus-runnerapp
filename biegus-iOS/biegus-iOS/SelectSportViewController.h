//
//  SelectSportViewController.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 30.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectSportProtocol <NSObject>

- (void) didSelectSportWithName:(NSString*)sportName;

@end

@interface SelectSportViewController : UITableViewController

@property id<SelectSportProtocol> delegate;

@end
