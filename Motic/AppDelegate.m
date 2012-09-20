//
//  AppDelegate.m
//  Motic
//
//  Created by Rose CW on 9/9/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "FaceViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification* localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"How's it going?" message:@"Time to send in a Motic." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [Parse setApplicationId:@"QOCXWVbQL55dP2MEhrb6uY7gE46MIuInekXGmbyI"
                  clientKey:@"4HtI742hrgrH1vjRVDF2zs9oto9Zbq0gsXiILzjP"];
    [PFTwitterUtils initializeWithConsumerKey:@"rIwixqDbv1m8sAWfz1rWTg"
                            consumerSecret:@"FsyVGlQIkpsAFct6ptGWpLu2zCOu66gwnxdFebzNyqI"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|
        UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navheader.png"] forBarMetrics:UIBarMetricsDefault];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [HomeViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (application.applicationState == UIApplicationStateActive){
        if (notification) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"How's it going?" message:@"Time to send in a Motic." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken{
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError* error){
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel");
        }
    }];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to register for push, %@", error);
}



-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [PFPush handlePush:userInfo];
}


@end

