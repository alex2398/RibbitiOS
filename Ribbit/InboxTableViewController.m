//
//  InboxTableViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "InboxTableViewController.h"
#import <Parse/Parse.h>

@interface InboxTableViewController ()

@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@",currentUser.username);
        
    } else {
        // Lanzar una view con un segue sin datos, (como un startActivity en los intents)
        [self performSegueWithIdentifier:@"showLogIn" sender:self];
    }
    
    //    Notas de la implementación de Parse.com
    //    Parse.com
    //    Known Issues
    //    
    //    The steps to include the Parse SDK in an Xcode project have changed slightly since this video was recorded. You       now also need to copy the Bolts.framework file from the Parse zip file into your project. If you don't you will get some Mach-O Linker errors.
    //    
    //    Required Frameworks Specified in the Quick Start Guide
    //    
    //    AudioToolbox.framework
    //    CFNetwork.framework
    //    CoreGraphics.framework
    //    CoreLocation.framework
    //    QuartzCore.framework
    //    Security.framework
    //    StoreKit.framework
    //    SystemConfiguration.framework
    //    libz.dylib
    //    libsqlite3.dylib
    //    Accounts.framework
    //    Social.framework
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogIn" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

// Con este segue ocultamos la barra de abajo del tabbar
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"showLogIn"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}



@end
