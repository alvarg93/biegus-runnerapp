//
//  SelectSportViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 30.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "SelectSportViewController.h"
#import "Constants.h"

@implementation SelectSportViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *returnName;
    
    switch (indexPath.row) {
        case 0:
            returnName = kCategoryClimbing;
            break;
        case 1:
            returnName = kCategoryCycling;
            break;
        case 2:
            returnName = kCategoryHorse;
            break;
        case 3:
            returnName = kCategoryNordicWalking;
            break;
        case 4:
            returnName = kCategoryRunnning;
            break;
        case 5:
            returnName = kCategorySailing;
            break;
        case 6:
            returnName = kCategorySkateboarding;
            break;
        case 7:
            returnName = kCategorySkiing;
            break;
        case 8:
            returnName = kCategoryWalking;
            break;
        case 9:
            returnName = kCategoryWheelchair;
            break;
            
        default:
            break;
    }
    
    if ([_delegate respondsToSelector:@selector(didSelectSportWithName:)]) {
        [self.delegate didSelectSportWithName:returnName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
