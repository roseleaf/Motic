//
//  MapMeViewController.m
//  Motic
//
//  Created by Rose CW on 9/17/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "MapMeViewController.h"
#import "UserPhoto.h"
#import <Parse/Parse.h>
#import "CoreLocation/CoreLocation.h"

@interface MapMeViewController () <CLLocationManagerDelegate>
@property CLLocationManager* locationManager;
@property CLLocation* startLocation;
@end

@implementation MapMeViewController
@synthesize mapview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        [self query];
    }
    return self;
}

-(void)query{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            photos = [NSMutableArray arrayWithArray:objects];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.startLocation.coordinate.latitude;
    zoomLocation.longitude= self.startLocation.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.2*METERS_PER_MILE, 0.2*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
    [self query];
    [self.mapview setRegion:adjustedRegion animated:YES];
    [self plotPhotos];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView* titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bartitle.png"]];
    self.navigationItem.titleView = titleView;
    self.mapview.delegate = self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.startLocation = newLocation;
    
}

-(void)plotPhotos{
    for (PFObject<MKAnnotation> *annotation in photos){
        //        CLLocationCoordinate2D coordinate =
        PFGeoPoint *userGeoPoint = [annotation objectForKey:@"coordinates"];
        NSString* time = [annotation objectForKey:@"time"];
        NSString* place = [annotation objectForKey:@"location"];
        PFFile *theImage = [annotation objectForKey:@"imageFile"];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userGeoPoint.latitude, userGeoPoint.longitude);
        UserPhoto *photo = [[UserPhoto alloc] initWithName:time address:place coordinate:coordinate];
        photo.image = [self resizeImage:image newSize:CGSizeMake(16, 24)];
        
        [self.mapview addAnnotation:photo];
    }
}






- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"UserPhoto";
    UserPhoto* photo = annotation;

    if ([annotation isKindOfClass:[UserPhoto class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:photo reuseIdentifier:identifier];
        } else {
            annotationView.annotation = photo;
        }
        
//        UIImageView* pinView = [[UIImageView alloc]initWithImage:photo.image];
//        pinView.frame = CGRectMake(20, 20, 20, 30);
//        [annotationView addSubview: pinView];
        annotationView.frame = CGRectMake(0, 0, 20, 30);
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = photo.image;
        
        
        
        return annotationView;
    }
    
    return nil;    
}


- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}




@end
