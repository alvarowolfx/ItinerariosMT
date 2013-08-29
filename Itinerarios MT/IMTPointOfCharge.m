//
//  IMTPointOfCharge.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 29/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTPointOfCharge.h"

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
