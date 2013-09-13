//
//  IMTPointOfCharge.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 29/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <OCMapView/OCGrouping.h>

@interface IMTPointOfCharge : NSObject <MKAnnotation,OCGrouping>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) BOOL hasLocation;

- (id)initWithName:(NSString *) name address:(NSString *) address latitude:(double) lat longitude:(double) lon;
- (id)initWithName:(NSString *) name address:(NSString *) address;
- (MKMapItem *) mapItem;
+ (NSArray *) loadWithContentOfFile:(NSString *) path;

@end
