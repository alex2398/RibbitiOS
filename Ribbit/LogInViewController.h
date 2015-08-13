//
//  LogInViewController.h
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (IBAction)login:(id)sender;

@end
