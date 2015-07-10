//
//  MyPFLogInViewController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 24.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "MyPFLogInViewController.h"

@interface MyPFLogInViewController ()

@end

@implementation MyPFLogInViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"biegus";
    [label setFont:[UIFont systemFontOfSize:36]];
    [self.logInView setLogo:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
