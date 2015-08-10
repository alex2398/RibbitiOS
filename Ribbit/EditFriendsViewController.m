//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 10/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Establecemos el usuario actual en la propiedad
    self.currentUser = [PFUser currentUser];
    // Creamos una query
    PFQuery *query = [PFUser query];
    //PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            // Pasamos el resultado a un array definido como propiedad
            self.allUsers = objects;
            NSLog(@"Users %@", self.allUsers);
            // Recargamos los datos, ya que esto sucederá más tarde que la carga de la tabla sin datos
            [self.tableView reloadData];
            
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.allUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Celda" forIndexPath:indexPath];
    
    
    // Configure the cell...
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Seleccionamos la celda pulsada
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // Deseleccionamos la celda pulsada, si no se queda marcada
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Establecemos el check al lado de la celda
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Establecemos la relacion en parse
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    [friendsRelation addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
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
