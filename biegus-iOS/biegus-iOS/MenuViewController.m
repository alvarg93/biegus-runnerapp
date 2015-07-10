//
//  MenuViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 28.04.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "MenuViewController.h"
#import <SWRevealViewController.h>

@interface MenuViewController () {
    NSArray *menuItems;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = @[@"main", @"history", @"statistics", @"settings"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[menuItems objectAtIndex:indexPath.row]];
    
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
