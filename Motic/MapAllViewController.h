//
//  MapAllViewController.h
//  Motic
//
//  Created by Rose CW on 9/18/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface MapAllViewController : UIViewController<MKMapViewDelegate>{
    NSMutableArray* allPhotos;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end
