//
//  LoginController.h
//  biegus-iOS
//
//  Created by Krystian Paszek on 24.05.2015.
//  Copyright (c) 2015 Krystian & Romek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MyPFLogInViewController.h"
#import "MyPFSignUpViewController.h"

/*!
 Object that creates and handles all callbacks from PFLoginViewController
 */
@interface LoginController : NSObject

///------
///@name Fields
///------

/*!
 Property holding view controller that creates and wants to present login view controller.
 */
@property UIViewController *parentViewController;

/*!
 Property holding created PFLoginViewController
 */
@property (weak, nonatomic) MyPFLogInViewController* loginViewController;

//------
//@name Methods
//------

/*!
 Method that creates, configures and shows PFLoginViewController from parentViewController
 */
- (void) presentLoginViewController;


@end
