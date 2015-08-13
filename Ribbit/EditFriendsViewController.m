//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 10/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "EditFriendsViewController.h"
#import "MSCellAccessory.h"


@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

    UIColor *disclosureColor;

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
    
    // Establecemos el color para los checks (variable globarl)
    disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
    
    
    
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
    
    // Comprobamos si el usuario de la celda es amigo
    
    if ([self isFriend:user]) {
        // Si es amigo, ponemos un check
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        
    } else {
        // Si no no se pone nada
        cell.accessoryView = nil;
    }


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Seleccionamos la celda pulsada
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // Deseleccionamos la celda pulsada, si no se queda marcada
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelations"];

    if ([self isFriend:(user)]) {
    // Borramos amigo
        // Quitamos el check
        cell.accessoryView = nil;
        // Borramos el amigo del array de amigos (local)
        for (PFUser *friend in self.friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        // Borramos de parse
        [friendsRelation removeObject:user];
        
        
    } else {
        // Añadimos el checkmark
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        [self.friends addObject:user];
        
        // Establecemos la relacion en parse
        [friendsRelation addObject:user];
    }
    
    // Guardamos en parse
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
            

        }
    }];
}



#pragma mark - Helper methods
- (BOOL)isFriend:(PFUser *)user {
    
    // Método que comprueba si un usuario está en la lista de amigos
    // La lista de amigos la obtenemos desde el viewcontroller Friends, con un segue
    // y se guarda en la propiedad array friends
    
    // Si en la lista de usuarios alguno es igual al usuario que pasamos como parámetro, devolvemos YES;
    for (PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
    
}

@end
