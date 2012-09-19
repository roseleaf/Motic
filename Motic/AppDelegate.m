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
    [Parse setApplicationId:@"QOCXWVbQL55dP2MEhrb6uY7gE46MIuInekXGmbyI"
                  clientKey:@"4HtI742hrgrH1vjRVDF2zs9oto9Zbq0gsXiILzjP"];
    [PFTwitterUtils initializeWithConsumerKey:@"rIwixqDbv1m8sAWfz1rWTg"
                            consumerSecret:@"FsyVGlQIkpsAFct6ptGWpLu2zCOu66gwnxdFebzNyqI"];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navheader.png"] forBarMetrics:UIBarMetricsDefault];

    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [HomeViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end

