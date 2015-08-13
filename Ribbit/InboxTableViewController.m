//
//  InboxTableViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "InboxTableViewController.h"
#import "ImageViewController.h"
#import "MSCellAccessory.h"

@interface InboxTableViewController ()

@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Inicializamos el reproductor de videos
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    // Inicializamos el control de refresco al deslizar
    self.refreshControl = [[UIRefreshControl alloc]init];
    // Establecemos el método que se lanzará al hacer el refresco deslizando (selector)
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
    
    
    
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
    
    [self.navigationController.navigationBar setHidden:NO];
    [self retrieveMessages];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
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
    
    // Establecemos la flechita y el color de la misma para los mensajes con la libreria MSCellAccesory (github)
    UIColor *disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:disclosureColor];
    
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    UIActivityIndicatorView *spinner =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [cell setAccessoryView:spinner];
    [spinner startAnimating];
    //[spinner release];
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *messageType = [self.selectedMessage objectForKey:@"fileType"];
    
    
    if ([messageType isEqualToString:@"image"]) {
        // Es una imagen
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        // Es un video
        
        // CARGAR LOS DATOS
        // Obtenemos el archivo y la url y la pasamos al media player
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *videoUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = videoUrl;
        
        // PREPARACION DEL MEDIA PLAYER
        // Llamamos al metodo prepareToPlay
        [self.moviePlayer prepareToPlay];
        
        // Llamamos a este metodo para que se muestre una miniatura en la animacion
        // de ampliar a fullscreen en lugar de una pantalla en blanco
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        // MOSTRAR EL VIDEO
        // Añadimos el media player al view controller para poder verlo
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    // Borramos del destinatario
    
    // Pasamos los destinatarios actuales del mensaje a una mutable array
    NSMutableArray *recipientsIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientsIds"]];
    
    if (recipientsIds.count==1) {
        // solo hay un destinatario con lo cual, borramos el mensaje una vez visto
        [self.selectedMessage deleteInBackground];
    } else {
        // borramos el destinatario del array
        [recipientsIds removeObject:[[PFUser currentUser] objectId]];
        // borramos el destinatario del mensaje en Parse
        [self.selectedMessage setObject:recipientsIds forKey:@"recipientsIds"];
        [self.selectedMessage saveInBackground];
    }

}


// Con este segue ocultamos la barra de abajo del tabbar
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
                
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        // Siempre hay que hacer una instancia del view controller al que queremos pasar el segue
        ImageViewController *imageViewController = (ImageViewController *) segue.destinationViewController;
        // Una vez tenemos la instancia, podemos pasar los datos
        imageViewController.message = self.selectedMessage;
         
    }
         
}

#pragma mark - Helper Methods

- (void)retrieveMessages {
    PFUser *currentUser = [PFUser currentUser];
    
    
    if (currentUser==nil) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    } else {
        
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
            
            
            // Una vez que termina el callback, paramos el spinner
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }];
    }
    
    
}





@end
