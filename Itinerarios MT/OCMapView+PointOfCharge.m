//
//  OCMapView+PointOfCharge.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 06/09/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "OCMapView+PointOfCharge.h"
#import "IMTPointOfCharge.h"

@implementation OCMapView (PointOfCharge)

- (void)configureWithPoints:(NSArray *) points;
{

    bool first = YES;
    double minLatitude,maxLatitude;
    double minLongitude,maxLongitude;
    for (IMTPointOfCharge *p in points) {
        if (!p.hasLocation) continue;
        
        if (first){
            minLatitude  = p.latitude;
            maxLatitude  = p.latitude;
            minLongitude = p.longitude;
            maxLongitude = p.longitude;
            first = NO;
        }
        [self addAnnotation:p];
        
        minLatitude = MIN(minLatitude,p.latitude);
        minLongitude = MIN(minLongitude,p.longitude);
        
        maxLatitude = MAX(maxLatitude,p.latitude);
        maxLongitude = MAX(maxLongitude,p.longitude);
        
    }
    MKCoordinateRegion region;
    region.center.latitude = (minLatitude + maxLatitude) / 2;
    region.center.longitude = (minLongitude + maxLongitude) / 2;
    
    region.span.latitudeDelta = (maxLatitude - minLatitude) * 1.1;
    
    region.span.latitudeDelta = (region.span.latitudeDelta < 0.01)
    ? 0.01
    : region.span.latitudeDelta;
    
    region.span.longitudeDelta = (maxLongitude - minLongitude) * 1.1;
    
    MKCoordinateRegion scaledRegion = [self regionThatFits:region];
    [self setRegion:scaledRegion animated:YES];
    [self setShowsUserLocation:YES];
    
}

@end
