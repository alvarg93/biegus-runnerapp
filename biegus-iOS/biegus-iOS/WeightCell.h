//
//  WeightCell.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 24.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WeightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
- (IBAction)stepperChanged:(UIStepper *)sender;

@end
