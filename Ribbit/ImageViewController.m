//
//  ImageViewController.m
//  Ribbit
//
//  Created by Alex Valladares on 12/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageURL = [[NSURL alloc]initWithString:[imageFile url]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.imageView.image = image;
    
    NSString *sender = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", sender];
    self.navigationItem.title = title;
    
                            
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Ponemos el contador aqui porque queremos empezar a contar los 10 segundos
    // desde que se carga la imagen (termina el viewDidLoad)
    [super viewDidAppear:animated];
    // Establecemos el timer cada 10 segundos
    
    if ([self respondsToSelector:@selector(timeOut)]) {
        // En el NSTimer establecemos el tiempo en segundos, el target, el selector (metodo) que se ejecutará,
        // userInfo (nil) y si queremos que se repita o no indefinidamente
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    }
    
}

- (void)timeOut {
    // Quitamos el actual viewController del stack con popViewController
    [self.navigationController popViewControllerAnimated:YES];
}

@end
