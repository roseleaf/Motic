//
//  FaceViewController.m
//  Motico
//
//  Created by Rose CW on 8/25/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "FaceViewController.h"
#import "FaceView.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreLocation/CoreLocation.h"


@interface FaceViewController () <CLLocationManagerDelegate, UINavigationControllerDelegate> {
    
    NSMutableString* locationHolder;
}
//face image proprties
@property (strong)  UIImage* faceImage;
@property (strong) CLLocation* faceLocation;
@property (strong) NSString* locationDescription;
//view objects
@property (strong) UIView* header;
@property (strong) UIView* footer;
@property (weak) UIButton* submitButton;
@property (weak) UIButton* visualizeButton;
@property (weak) UIButton* loginButton;
//location Utilities
@property (strong) CLLocationManager* locationManager;
@property (strong) CLGeocoder* geoCoder;

@end


@implementation FaceViewController


// Initialization Code:

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.geoCoder = [CLGeocoder new];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        //self.navController = [UINavigationController new];

    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    FaceView* faceView = [[FaceView alloc]initWithFrame:self.view.frame];
    self.view = faceView;
    self.header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header.png"]];
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 30)];
    headerLabel.text = @"How are you?";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    [self.header addSubview:headerLabel];
    
    self.footer = [[UIView alloc]initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 190)];
    self.footer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"footer.png"]];
    [self.view addSubview:self.header];
    [self.view addSubview:self.footer];
    

    if ([PFUser currentUser]) {
        self.submitButton = [self addSubmitButton];
        [self.view addSubview:self.submitButton];
        self.visualizeButton = [self addVisualizeButton];
        [self.view addSubview:self.visualizeButton];

        self.loginButton.hidden = YES;
        self.visualizeButton.hidden = NO;
        self.submitButton.hidden = NO;
    } else {
        self.loginButton = [self addLoginButton];
        [self.view addSubview:self.loginButton];

        self.loginButton.hidden = NO;
        self.visualizeButton.hidden = YES;
        self.submitButton.hidden = YES;
    }


}


-(UIButton*)addSubmitButton{
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton addTarget:self action:@selector(getFaceImageData) forControlEvents:UIControlEventTouchDown];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    submitButton.frame = CGRectMake(60.0, 365.0, 100.0, 40.0);
    UIImage* buttonImage = [UIImage imageNamed:@"lightbutton.png"];
    [submitButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return submitButton;
}
-(UIButton*)addVisualizeButton{
    UIButton* visualizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [visualizeButton addTarget:self action:@selector(showUserData) forControlEvents:UIControlEventTouchDown];
    [visualizeButton setTitle:@"Visualize" forState:UIControlStateNormal];
    visualizeButton.frame = CGRectMake(160.0, 365.0, 100.0, 40.0);
    [visualizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage* buttonImage = [UIImage imageNamed:@"lightbutton.png"];
    [visualizeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    return visualizeButton;
}
-(UIButton*)addLoginButton{
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(160.0, 315.0, 100.0, 40.0);
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage* buttonImage = [UIImage imageNamed:@"lightbutton.png"];
    [loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    return loginButton;
}



//CLLocationManagerDelegate Method:

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.faceLocation = newLocation;
    
}



//Get Face Image From View:

-(UIImage*)getFaceImageData{
    //NSString* locationHolder = [NSString new];
    self.visualizeButton.hidden = YES;
    self.submitButton.hidden = YES;
    self.header.hidden = YES;
    self.footer.hidden = YES;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Convert to data:
    NSData* faceImageData = UIImageJPEGRepresentation(viewImage, 0.7);
    
    
    //Geocoder method that turns coords into address:
    [self.geoCoder reverseGeocodeLocation: self.locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
         //save location to a variable, referenced in uploadImage:
         self.locationDescription = locatedAt;
         [self uploadImage:faceImageData withLocation:self.locationDescription];
         
     }];
    
    return viewImage;
}


//Upload Face Image to Parse:
-(void)uploadImage:(NSData *)imageData withLocation:(NSString*)locationDescription{
    
    //Create Image File:
    PFFile* imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    [imageFile saveInBackground];
    //Assign to imageFile column:
    PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
    [userPhoto setObject:imageFile forKey:@"imageFile"];
    //Get location object:
    PFGeoPoint* imageLocation = [PFGeoPoint geoPointWithLatitude:self.faceLocation.coordinate.latitude longitude:self.faceLocation.coordinate.longitude];
    //Assign to Location Column:
    [userPhoto setObject:imageLocation forKey:@"coordinates"];
    userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    //Assign location description:
    [userPhoto setObject:self.locationDescription forKey:@"location"];
    
    //Get local timestamp:
    NSDate* date = [NSDate date];
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    
    NSDateFormatter* df_local = [NSDateFormatter new];
    [df_local setTimeZone:tz];
    [df_local setDateFormat:@"dd/MM/yyyy 'at' HH:mm:ss zzz"];
    NSString* ts_local_string = [df_local stringFromDate:date];
    NSString* localTime = ts_local_string;
    
    [userPhoto setObject:localTime forKey:@"time"];
    
    
    PFUser *user = [PFUser currentUser];
    [userPhoto setObject:user forKey:@"user"];
    PFACL* photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    userPhoto.ACL = photoACL;
    
    [userPhoto saveInBackground];
    
    self.header.hidden = NO;
    self.footer.hidden = NO;
    self.submitButton.hidden = NO;
    self.visualizeButton.hidden = NO;
    
    [self showUserData];
    
}

-(void)showUserData{
    UserTableViewController* userview = [UserTableViewController new];
    MapMeViewController* mapMe = [MapMeViewController new];
    MapAllViewController* mapEveryone = [MapAllViewController new];
    userview.title = @"My Motics";
    mapMe.title = @"Map Me";
    mapEveryone.title = @"Map Everyone";
    
    UITabBarController* tabBar = [[UITabBarController alloc]init];
    tabBar.viewControllers = [NSArray arrayWithObjects:userview, mapMe, mapEveryone, nil];
    
    UIButton* offButton = [UIButton buttonWithType:UIButtonTypeCustom];
    offButton.frame = CGRectMake(0, 0, 50, 50);
    UIImage* offImage = [UIImage imageNamed:@"off.png"];
    [offButton setImage:offImage forState:UIControlStateNormal];
    [offButton addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* signOut = [[UIBarButtonItem alloc]initWithCustomView:offButton];
    
    UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 50, 50);
    UIImage* addImage = [UIImage imageNamed:@"add.png"];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(showFace) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* addFace = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    //addFace.tintColor = [UIColor clearColor];
    
    tabBar.navigationItem.rightBarButtonItem = signOut;
    tabBar.navigationItem.leftBarButtonItem = addFace;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:tabBar];
    [self presentModalViewController:navController animated:YES];
}


-(void)showFace{
    [self.presentedViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"goingback to face");
}
-(void)signOut{
    UIViewController* presenter = self.presentingViewController;
    [presenter dismissModalViewControllerAnimated:YES];
    [presenter dismissModalViewControllerAnimated:YES];
    [PFUser logOut];

}
// Defaults:

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
