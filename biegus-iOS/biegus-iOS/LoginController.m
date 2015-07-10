//
//  LoginController.m
//  biegus-iOS
//
//  Created by Krystian Paszek on 24.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import "LoginController.h"

@interface LoginController() <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation LoginController

- (PFLogInViewController*) loginViewController {
    MyPFLogInViewController *logInViewController = [[MyPFLogInViewController alloc] init];
    [logInViewController setDelegate:self];
    MyPFSignUpViewController *signUpViewController = [[MyPFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self];
    [logInViewController setSignUpController:signUpViewController];
    [logInViewController setFields: PFLogInFieldsDefault];
    [logInViewController setFields:PFLogInFieldsFacebook | PFLogInFieldsTwitter | PFLogInFieldsDefault | PFLogInFieldsDismissButton];
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"public_profile", nil]];
    
    self.loginViewController = logInViewController;
    return logInViewController;
}

- (void) presentLoginViewController {
    [self.parentViewController presentViewController:[self loginViewController] animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedInSuccessfully" object:nil];
    
    if ([PFFacebookUtils isLinkedWithUser:user]) {
        
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error) {
                NSString *facebookUsername = [result objectForKey:@"name"];
                [PFUser currentUser].username = facebookUsername;
                [[PFUser currentUser] saveEventually];
            } else {
                NSLog(@"%@", [error localizedDescription]);
            }
            
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    } else if ([PFTwitterUtils isLinkedWithUser:user]) {
        NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", [PFTwitterUtils twitter].screenName];
        
        
        NSURL *verify = [NSURL URLWithString:requestString];
        NSError *error;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
        [[PFTwitterUtils twitter] signRequest:request];
        NSURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        
        if ( error == nil){
            NSString *twitterScreenName = [PFTwitterUtils twitter].screenName;
            NSLog(@"%@", twitterScreenName);
            [PFUser currentUser].username = twitterScreenName;
            [[PFUser currentUser] saveEventually];
            //                NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        //        }
    } else {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"did fail to login, error: %@", [error localizedDescription]);
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"did fail to sign up, error: %@", [error localizedDescription]);
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signedUpSuccessfully" object:nil];
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"did sign up: %@", user);
        NSLog(@"current user: %@", [PFUser currentUser]);
    }];
}


@end
