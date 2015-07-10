//
//  SettingsViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 28.04.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "SettingsViewController.h"
#import "WeightCell.h"
#import <SWRevealViewController.h>
#import <Parse/Parse.h>
#import "LoginController.h"
#import <ParseUI.h>

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *sectionTitles;
@property NSArray *sectionOneOptions;
@property NSArray *sectionTwoptions;

@property LoginController *loginController;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.sectionTitles = @[@"Account options", @"User"];
    self.sectionOneOptions = @[@"Logout"];
    self.sectionTwoptions = @[@"Weight"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeightCell" bundle:nil] forCellReuseIdentifier:@"weightCell"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLoggingIn) name:@"loggedInSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLoggingIn) name:@"signedUpSuccessfully" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![PFUser currentUser]) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _sectionOneOptions.count;
    } else if (section == 1) {
        if ([PFUser currentUser]) {
            return _sectionTwoptions.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    
    //title = [NSString stringWithFormat:@"Section %ld", (long)section];
    title = [self.sectionTitles objectAtIndex:section];
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            if ([PFUser currentUser]) {
                NSString *serviceName;
                if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
                    serviceName = @" (Twitter)";
                } else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
                    serviceName = @" (Facebook)";
                } else serviceName = @"";
                NSString *str = [NSString stringWithFormat:@"Logout%@ (%@)", serviceName, [[PFUser currentUser] username]];
                cell.textLabel.text = str;
            } else {
                cell.textLabel.text = @"Log in";
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"weightCell"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([PFUser currentUser]) {
                [PFUser logOut];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"You've been succesfully logged out" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.tableView reloadData];
            } else {
                self.loginController = [[LoginController alloc] init];
                self.loginController.parentViewController = self;
                [self.loginController presentLoginViewController];
            }
        }
    }
}

- (void) didFinishLoggingIn {
    [self.tableView reloadData];
}

@end
