//
//  UserPhoto.m
//  Motic
//
//  Created by Rose CW on 9/17/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "UserPhoto.h"

@interface UserPhoto()
@property (nonatomic, strong) PFObject *object;
@end

@implementation UserPhoto

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate{
    self.title = name;
    self.subtitle = address;
    self.coordinate = coordinate;
    return self;
}
//- (id)initWithObject:(PFObject *)theObject {
//    self = [super init];
//    if (self) {
//        _object = theObject;
//        
//        PFGeoPoint *geoPoint = [self.object objectForKey:@"location"];
//        [self setGeoPoint:geoPoint];
//    }
//    return self;
//}

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    _title = [dateFormatter stringFromDate:[self.object updatedAt]];

}
@end
