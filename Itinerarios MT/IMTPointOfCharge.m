//
//  IMTPointOfCharge.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 29/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTPointOfCharge.h"
#import <AddressBook/AddressBook.h>

@implementation IMTPointOfCharge

-(id)initWithName:(NSString *)name address:(NSString *)address{
    self = [super init];
    if (self) {
        self.name = [name copy];
        self.address = [address copy];
        self.hasLocation = NO;
    }
    return self;
}

-(id)initWithName:(NSString *)name address:(NSString *)address latitude:(double)lat longitude:(double)lon{
    self = [super init];
    if (self) {
        self.name = [name copy];
        self.address = [address copy];
        self.latitude = lat;
        self.longitude = lon;
        self.hasLocation = YES;
    }
    return self;
}

-(NSString *)title{
    return _name;
}

-(NSString *)subtitle{
    return _address;
}

-(CLLocationCoordinate2D)coordinate{
    if (_hasLocation){
        return CLLocationCoordinate2DMake(_latitude, _longitude);
    }else{
        return CLLocationCoordinate2DMake(0, 0);
    }
}

- (MKMapItem *) mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

-(NSString *)groupTag{
    return @"POC";
}

+(NSArray *)loadWithContentOfFile:(NSString *)path{
    NSArray *raws = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in raws) {
        NSString *address = [dict valueForKey:@"address"];
        NSString *name = [dict valueForKey:@"name"];
        NSDictionary *loc = [dict valueForKey:@"location"];
        if([loc count] == 0){
            [points addObject:[[IMTPointOfCharge alloc] initWithName:name address:address]];
        }else{
            double lat = [[loc valueForKey:@"lat"] doubleValue];
            double lon = [[loc valueForKey:@"lon"] doubleValue];
            [points addObject:[[IMTPointOfCharge alloc] initWithName:name address:address latitude:lat longitude:lon]];
        }
    }
    raws = nil;
    return points;
}

@end
