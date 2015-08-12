//
//  InboxTableViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "InboxTableViewController.h"
#import "ImageViewController.h"

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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientsIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            // Obtenemos los mensajes para el usuario
            self.messages = objects;
            [self.tableView reloadData];
            // NSLog(@"current user : %@",[[PFUser currentUser] objectId]);
            // NSLog(@"messages : %lu", (unsigned long)[self.messages count]);
        }
    }];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogIn" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    
    // Configure the cell...
    // Obtenemos el mensaje del array
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    NSString *messageType = [message objectForKey:@"fileType"];
    
    if ([messageType isEqualToString:@"image"]) {
        // Es una imagen
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    } else {
        // Es un video
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *messageType = [self.selectedMessage objectForKey:@"fileType"];
    
    if ([messageType isEqualToString:@"image"]) {
        // Es una imagen
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        // Es un video
            }

}


// Con este segue ocultamos la barra de abajo del tabbar
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogIn"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        /*
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        // Siempre hay que hacer una instancia del view controller al que queremos pasar el segue
        ImageViewController *imageViewController = (ImageViewController *) segue.destinationViewController;
        // Una vez tenemos la instancia, podemos pasar los datos
        imageViewController.message = self.selectedMessage;
         */
    }
         
}




@end
