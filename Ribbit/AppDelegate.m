//
//  AppDelegate.m
//  Ribbit
//
//  Created by Alex Valladares on 07/08/15.
//  Copyright (c) 2015 Alex Valladares. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"pIlXyyqk073KKogbMbz5pPqMJ6v1F3TiVG36S3Bz"
                  clientKey:@"iG6gsvPsP9reNVYomwQbG5LeEnQetA53rfezrmC9"];
    // Hacemos que dure más tiempo el launchScreen
    [NSThread sleepForTimeInterval:1.5];
    [self customizeUI];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)customizeUI {
    // Al customizar en AppDelegate hacemos que los cambios se produzcan en todas las vistas,
    // si lo hacemos con el diseñador tenemos que ir una por una
    
    
    // Customizamos la navigation bar mediante código
    
    //[[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.553 green:.0435 blue:0.718 alpha:1.0]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    // Customizamos la tab bar
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
        forState:UIControlStateNormal];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *inbox = [tabBar.items objectAtIndex:0];
    UITabBarItem *friends = [tabBar.items objectAtIndex:1];
    UITabBarItem *camera = [tabBar.items objectAtIndex:2];
    
    UIImage *inboxIconImage = [[UIImage imageNamed:@"inbox"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *cameraIconImage = [[UIImage imageNamed:@"camera"]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *friendsIconImage = [[UIImage imageNamed:@"friends"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    inbox = [inbox initWithTitle:nil image:inboxIconImage selectedImage:inboxIconImage];
    camera = [camera initWithTitle:nil image:cameraIconImage selectedImage:cameraIconImage];
    friends = [friends initWithTitle:nil image:friendsIconImage selectedImage:friendsIconImage];
    
    
    
    
    inbox = [inbox initWithTitle:nil image:inboxIconImage selectedImage:inboxIconImage];
    camera = [camera initWithTitle:nil image:cameraIconImage selectedImage:cameraIconImage];
    friends = [friends initWithTitle:nil image:friendsIconImage selectedImage:friendsIconImage];
    
    
    
    
    
}


@end
