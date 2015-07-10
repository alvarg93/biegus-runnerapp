//
//  WeightCell.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 24.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "WeightCell.h"

@implementation WeightCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    self.weightLabel.text = [NSString stringWithFormat:@"Weight: %.0f", sender.value];
    [[PFUser currentUser] setObject:[NSNumber numberWithDouble:sender.value] forKey:@"weight"];
    [[PFUser currentUser] saveInBackground];
}
@end
