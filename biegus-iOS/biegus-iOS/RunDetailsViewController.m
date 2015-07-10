//
//  RunDetailsViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 03.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "RunDetailsViewController.h"
#import "BGSMath.h"
#import "BGSMapUtils.h"
#import <Parse/Parse.h>
#import "LocationManager.h"
#import <MBProgressHUD.h>
@import MapKit;

@interface RunDetailsViewController () <MKMapViewDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property LocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageTempoLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumSpeedLabel;

- (IBAction)acceptTapped:(id)sender;
- (IBAction)rejectTapped:(id)sender;

@property MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsHeightConstraint;

@end

@implementation RunDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.locationManager = [LocationManager sharedManager];
    self.mapView.delegate = self;
    if (!_shouldShowButtons) {
        _buttonsHeightConstraint.constant = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.timeLabel.text = [BGSMath stringifySecondCount:self.seconds usingLongFormat:NO];
    float meters = self.distance;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", (meters / 1000), @"km"];
    self.caloriesLabel.text = [BGSMath stringifyCaloriesFromDist:meters overTime:self.seconds];
    self.minimumSpeedLabel.text = [NSString stringWithFormat:@"%.1f km/h", self.minimumSpeed*3.6];
    self.maximumSpeedLabel.text = [NSString stringWithFormat:@"%.1f km/h", self.maximumSpeed*3.6];
    self.averageTempoLabel.text = [BGSMath stringifyAvgPaceFromDist:meters overTime:self.seconds];
    
    [self.mapView setRegion:[BGSMapUtils mapRegionForArrayOfLocations:self.recordedRun]];
    [self.mapView addOverlay:[BGSMapUtils polyLineForArrayOfLocations:self.recordedRun]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    return [BGSMapUtils rendererForOverlay:overlay withColor:[UIColor blueColor] andLineWidth:5];
}

- (IBAction)acceptTapped:(id)sender {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;
    _hud.labelText = @"Uploading...";
    PFObject *run = [PFObject objectWithClassName:@"Run"];
    NSArray *recoredRun = self.recordedRun;
    NSMutableArray *parseLocationsArray = [[NSMutableArray alloc] initWithCapacity:recoredRun.count];
    for (CLLocation *location in recoredRun) {
        PFGeoPoint *geopoint = [PFGeoPoint geoPointWithLocation:location];
        [parseLocationsArray addObject:geopoint];
    }
    [run setObject:[PFUser currentUser] forKey:@"TrackedBy"];
    [run setObject:_sportType forKey:@"Type"];
    [run setObject:parseLocationsArray forKey:@"Locations"];
    [run setObject:[NSNumber numberWithInt:self.seconds] forKey:@"Seconds"];
    [run setObject:[NSNumber numberWithFloat:self.distance] forKey:@"Distance"];
    [run setObject:[BGSMath caloriesFromDist:self.distance overTime:self.seconds] forKey:@"Calories"];
    [run setObject:[NSNumber numberWithFloat:self.minimumSpeed] forKey:@"minSpeed"];
    [run setObject:[NSNumber numberWithFloat:self.maximumSpeed] forKey:@"maxSpeed"];
    
    
    [run saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-checkmark"]];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.delegate = self;
        _hud.labelText = @"Saved!";
        [_hud show:YES];
        [_hud hide:YES afterDelay:1.5];
        [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
    }];
}

- (IBAction)rejectTapped:(id)sender {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.dimBackground = YES;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-cross"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.delegate = self;
    _hud.labelText = @"Rejected!";
    [_hud show:YES];
    [_hud hide:YES afterDelay:1.5];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
}

- (void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
