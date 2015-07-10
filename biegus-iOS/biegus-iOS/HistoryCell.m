//
//  HistoryCell.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "HistoryCell.h"
#import "BGSMath.h"

@interface HistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sportImage;

@end

@implementation HistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) prepareCell {
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", (self.distance / 1000), @"km"];
    self.timeLabel.text = [BGSMath stringifySecondCount:_seconds usingLongFormat:NO];
    self.sportImage.image = [UIImage imageNamed:self.sportType];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yy HH:mm";
    
    self.dateLabel.text = [dateFormatter stringFromDate:self.dateOfRun];
}

@end
