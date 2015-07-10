//
//  ViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 10.04.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import <Parse/Parse.h>
#import <ParseUI.h>
#import <SWRevealViewController.h>
#import "BGSMath.h"
#import "BGSMapUtils.h"
#import "RunDetailsViewController.h"
#import "LoginController.h"
#import "SelectSportViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Constants.h"

@import MapKit;

@interface ViewController () <MKMapViewDelegate, SelectSportProtocol>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *gpsStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *selectSportButton;
@property (weak, nonatomic) IBOutlet UIImageView *sportTypeImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (nonatomic) BOOL isRecording;
@property BOOL showWholePath;
@property NSTimer *timer;
@property int seconds;
@property NSString *sportType;

@property LoginController *loginController;
@property LocationManager *locationManager;

- (IBAction)startstop:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[PFUser currentUser] fetchInBackground];
    
    _sportType = kCategoryRunnning;
    _isRecording = NO;
    _showWholePath = NO;
    _locationManager = [LocationManager sharedManager];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateLocation:) name:@"DidUpdateLocations" object:_locationManager];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    if (![PFUser currentUser]) {
        [self.startButton setTitle:@"Log in to record run" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_isRecording) {
        self.seconds = 0;
        self.timeLabel.text = [BGSMath stringifySecondCount:self.seconds usingLongFormat:NO];
        float meters = 0;
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", (meters / 1000), @"km"];
        self.paceLabel.text = [BGSMath stringifyAvgPaceFromDist:meters overTime:self.seconds];
        self.caloriesLabel.text = [BGSMath stringifyCaloriesFromDist:meters overTime:self.seconds];
        [self.mapView removeOverlays:self.mapView.overlays];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLoggingIn) name:@"loggedInSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLoggingIn) name:@"signedUpSuccessfully" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didUpdateLocation:(NSNotification*)notification {

    CLLocation *lastLocation = [self.locationManager lastLocation];
    
    NSString *statusMsg;
    if (lastLocation.horizontalAccuracy < 10) {
        statusMsg = @"Perfect";
    } else if (lastLocation.horizontalAccuracy < 20) {
        statusMsg = @"OK";
    } else if (lastLocation.horizontalAccuracy < 60) {
        statusMsg = @"medium";
    } else if (lastLocation.horizontalAccuracy < 120) {
        statusMsg = @"weak";
    } else {
        statusMsg = @"very weak";
    }
    
    NSArray *locations = [self.locationManager recordedRun];
    
    if (_isRecording) {
        if (locations.count > 1 && _showWholePath) {
            [self.mapView setRegion:[BGSMapUtils mapRegionForArrayOfLocations:locations]];
        }
        
        if (self.mapView.overlays.count > 0) {
            MKPolyline *polylineToRemove = [self.mapView.overlays firstObject];
            [self.mapView removeOverlay:polylineToRemove];
        }
        [self.mapView addOverlay:[BGSMapUtils polyLineForArrayOfLocations:locations]];
    }
    
    _gpsStatusLabel.text = [NSString stringWithFormat:@"GPS Status: %@ (%.2f)", statusMsg, lastLocation.horizontalAccuracy];
}

- (IBAction)startstop:(id)sender {
    UIImageView *senderButton = (UIImageView*)((UITapGestureRecognizer*)sender).view;
    
    if (![PFUser currentUser]) {
        self.loginController = [[LoginController alloc] init];
        self.loginController.parentViewController = self;
        [self.loginController presentLoginViewController];
    } else {
        _isRecording = !_isRecording;
        if (_isRecording) {
            [self.locationManager startRecording];
            self.mapView.userTrackingMode = MKUserTrackingModeFollow;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
            self.seconds = 0;
            [self.selectSportButton setUserInteractionEnabled:NO];
            [senderButton setImage:[UIImage imageNamed:@"pause"]];
            
        } else {
            [self.timer invalidate];
            self.timer = nil;
            [self.locationManager stopRecording];
            [senderButton setImage:[UIImage imageNamed:@"play"]];
            [self.selectSportButton setUserInteractionEnabled:YES];
            
            [self performSegueWithIdentifier:@"RunDetailsSegue" sender:self];
        }
    }
}

- (void) eachSecond {
    self.seconds++;
    self.timeLabel.text = [BGSMath stringifySecondCount:self.seconds usingLongFormat:NO];
    float meters = [self.locationManager distance];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f %@", (meters / 1000), @"km"];
    self.paceLabel.text = [BGSMath stringifyAvgPaceFromDist:meters overTime:self.seconds];
    self.caloriesLabel.text = [BGSMath stringifyCaloriesFromDist:meters overTime:self.seconds];
    self.speedLabel.text = [NSString stringWithFormat:@"%.1f km/h", [self.locationManager currentSpeed]*3600/1000];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    return [BGSMapUtils rendererForOverlay:overlay withColor:[UIColor blueColor] andLineWidth:5];
}

- (void) didFinishLoggingIn {
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)didSelectSportWithName:(NSString *)sportName {
    [self.selectSportButton setTitle:[Constants fullNameForConst:sportName] forState:UIControlStateNormal];
    self.sportType = sportName;
    [self.sportTypeImage setImage:[UIImage imageNamed:self.sportType]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RunDetailsSegue"]) {
        RunDetailsViewController *destinationVC = (RunDetailsViewController*)segue.destinationViewController;
        destinationVC.seconds = self.seconds;
        destinationVC.distance = [self.locationManager distance];
        destinationVC.recordedRun = [self.locationManager recordedRun];
        destinationVC.maximumSpeed = [self.locationManager maximumSpeed];
        destinationVC.minimumSpeed = [self.locationManager minimumSpeed];
        destinationVC.shouldShowButtons = YES;
        destinationVC.sportType = self.sportType;
    } else if ([segue.identifier isEqualToString:@"selectSportSegue"]) {
        SelectSportViewController *destinationVC = (SelectSportViewController*)segue.destinationViewController;
        destinationVC.delegate = self;
    }
}

@end
