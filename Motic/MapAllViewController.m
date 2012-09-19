//
//  MapAllViewController.m
//  Motic
//
//  Created by Rose CW on 9/18/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "MapAllViewController.h"
#import "UserPhoto.h"
#import <Parse/Parse.h>

@interface MapAllViewController ()

@end

@implementation MapAllViewController
@synthesize mapview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allPhotos = [NSMutableArray new];
        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
        [query setLimit:300];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                [allPhotos addObjectsFromArray:objects];
            } else {
                NSLog(@"Error: %@", error);
            }
        }];

    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 37.777468;
    zoomLocation.longitude = -122.400723;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
    [self.mapview setRegion:adjustedRegion animated:YES];
    [self plotPhotos];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapview.delegate = self;
    UIImageView* titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bartitle.png"]];
    [self.navigationController.navigationBar insertSubview:titleView atIndex:0];

}

-(void)viewWillDisappear:(BOOL)animated{
    //try to save the current zoom region and send it to the NSUserDefaults
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)plotPhotos{
    for (PFObject<MKAnnotation> *annotation in allPhotos){
        PFGeoPoint *userGeoPoint = [annotation objectForKey:@"coordinates"];
        NSString* time = [annotation objectForKey:@"time"];
        NSString* place = [annotation objectForKey:@"location"];
        PFFile *theImage = [annotation objectForKey:@"imageFile"];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userGeoPoint.latitude, userGeoPoint.longitude);
        UserPhoto *photo = [[UserPhoto alloc] initWithName:time address:place coordinate:coordinate];
        photo.image = [self resizeImage:image newSize:CGSizeMake(8, 12)];
        
        [self mapView:self.mapview viewForAnnotation:photo];
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
