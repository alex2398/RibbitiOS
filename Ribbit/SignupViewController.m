//
//  SignupViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signup:(id)sender {
    
    // Creamos variables NSString para almacenar el texto de los campos
    // con el método stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
    // eliminamos los espacios vacíos delante y detrás del texto
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length==0 || password.length==0 || email.length==0) {
        // Comprobamos que ninguno de los campos esté vacío
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you entered an username, password and email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        // Creamos el usuario en parse.com
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        // Lanzamos el comando para dar de alta el usuario en parse.com
        // ^: es un bloque, es como los callbacks en android, es la parte que se ejecuta, en este caso,
        // cuando el método en background devuelve una respuesta
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                // Si da error, mostramos una alerta
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];

            } else {
                // Si todo va bien, saltamos a la pantalla inicial del navigationController
                //[self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - UITextField delegate methods

// Este método se llama cada vez que se pulsa return en el campo de texto
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Quitamos el textfield pulsado de ser el primer respondedor
    // algo asi como quitar el foco, con lo que el teclado se oculta
    [textField resignFirstResponder];
    return YES;
}

@end
