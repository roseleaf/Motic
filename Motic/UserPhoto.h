//
//  UserPhoto.h
//  Motic
//
//  Created by Rose CW on 9/17/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface UserPhoto : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong) UIImage* image;
//-(id)initWithObject:(PFObject*)theObject;
-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
@end