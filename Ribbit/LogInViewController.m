//
//  LogInViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Ocultamos el botón para volver al inbox
    // self.navigationItem.hidesBackButton = YES;
    
    /*
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
     */
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (username.length==0 || password.length==0) {
        // Comprobamos que ninguno de los campos esté vacío
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you entered an username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        // Creamos un indicador de actividad (spinner)
        
        [self.spinner startAnimating];

        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            [self.spinner stopAnimating];
            if (error) {
                // Si da error, mostramos una alerta
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [self.spinner stopAnimating];
                
            } else {
                [NSThread sleepForTimeInterval:2];
                [self.spinner stopAnimating];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }];
        
        
    }


}

#pragma mark - UITextField delegate methods
// Lo comentamos porque usamos el TPKeyboard AvoidingScrollView (github)
/*
// Este método se llama cada vez que se pulsa return en el campo de texto
// Requiere delegar la cabecera en <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Quitamos el textfield pulsado de ser el primer respondedor
    // algo asi como quitar el foco, con lo que el teclado se oculta
    [textField resignFirstResponder];
    return YES;
}
 */

@end
