//
//  GeoPointAnnotation.m
//  Motic
//
//  Created by Rose CW on 9/17/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "GeoPointAnnotation.h"

@interface GeoPointAnnotation()
@property (nonatomic, strong) PFObject* object;
@end

@implementation GeoPointAnnotation
-(id)initWithObject:(PFObject *)aObject{
    self = [super init];
    if (self) {
        _object = aObject;
        
        PFGeoPoint *geoPoint = [self.object objectForKey:@"location"];
        [self setGeoPoint:geoPoint];
    }
    return self;
}

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoPoint:geoPoint];
    [self.object setObject:geoPoint forKey:@"location"];
    [self.object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Send a notification when this geopoint has been updated. MasterViewController will be listening for this notification, and will reload its data when this notification is received.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"geoPointAnnotiationUpdated" object:self.object];
        }
    }];
}


#pragma mark - ()

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    

    
    _title = [dateFormatter stringFromDate:[self.object updatedAt]];
    _subtitle = @"hm";
}

@end