//
//  FriendsViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 10/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Usamos este método para poder recargar los amigos cada vez que la vista aparezca,
    // si lo ponemos en viewDidLoad solo aparecen la primera vez que se carga
    
    // Creamos la propiedad relacion y obtenemos el dato para el usuario logueado
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelations"];
    // Hacemos la consulta de la relacion
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
            

        } else {
            // Volcamos los datos devueltos a un array (propiedad)
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super view];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    
    // Configure the cell...
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    if ([segue.identifier isEqualToString:@"showEditFriends"]) {
        
        EditFriendsViewController *viewController = (EditFriendsViewController *)segue.destinationViewController;
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
        
    }

}


@end
