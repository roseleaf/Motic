//
//  MapMeViewController.h
//  Motic
//
//  Created by Rose CW on 9/17/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface MapMeViewController : UIViewController <MKMapViewDelegate>{
    NSMutableArray* photos;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@end
