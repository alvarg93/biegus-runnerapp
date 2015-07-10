//
//  HistoryViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "HistoryViewController.h"
#import "RunDetailsViewController.h"
#import "HistoryCell.h"
#import <SWRevealViewController.h>
#import "BGSMath.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.parseClassName = @"Run";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (PFQuery *)queryForTable {
    PFQuery *runsQuery = [PFQuery queryWithClassName:@"Run"];
    [runsQuery whereKey:@"TrackedBy" equalTo:[PFUser currentUser]];
    [runsQuery orderByDescending:@"updatedAt"];
    return runsQuery;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    int seconds = [object[@"Seconds"] intValue];
    float meters = [object[@"Distance"] floatValue];
    NSArray *locations = object[@"Locations"];
    CLLocationSpeed maximumSpeed = [object[@"maxSpeed"] floatValue];
    CLLocationSpeed minimumSpeed = [object[@"minSpeed"] floatValue];
    NSMutableArray *recordedRun = [[NSMutableArray alloc] initWithCapacity:locations.count];
    
    for (PFGeoPoint *geopoint in locations) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:geopoint.latitude longitude:geopoint.longitude];
        [recordedRun addObject:location];
    }
    
    cell.recordedRun = recordedRun;
    cell.seconds = seconds;
    cell.distance = meters;
    cell.maxSpeed = maximumSpeed;
    cell.minSpeed = minimumSpeed;
    cell.dateOfRun = object.updatedAt;
    cell.sportType = object[@"Type"];
    [cell prepareCell];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HistoryRunDetailsSegue"]) {
        RunDetailsViewController *destinationVC = (RunDetailsViewController*)segue.destinationViewController;
        HistoryCell *senderCell = (HistoryCell*)sender;
        destinationVC.seconds = senderCell.seconds;
        destinationVC.distance = senderCell.distance;
        destinationVC.recordedRun = senderCell.recordedRun;
        destinationVC.maximumSpeed = senderCell.maxSpeed;
        destinationVC.minimumSpeed = senderCell.minSpeed;
    }
}

@end
