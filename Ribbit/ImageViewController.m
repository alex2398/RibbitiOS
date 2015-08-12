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
@end
