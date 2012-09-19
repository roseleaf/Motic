//
//  FaceViewController.h
//  Motic
//
//  Created by Rose CW on 9/9/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MapMeViewController.h"
#import "MapAllViewController.h"
#import "UserTableViewController.h"

@interface FaceViewController : UIViewController
@property (strong) PFUser* user;

@end
