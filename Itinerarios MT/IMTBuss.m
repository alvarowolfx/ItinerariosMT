//
//  IMTBuss.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTBuss.h"

@implementation IMTBuss

- (id)initWithName:(NSString *) name line:(NSString *) line trip:(NSArray *) trip ret:(NSArray *) ret
{
    self = [super init];
    if (self) {
        self.name = [name copy];
        self.line = [line copy];
        self.tripItinerary = trip;
        self.returnItinerary = ret;
    }
    return self;
}

+(NSArray *)loadWithContentOfFile:(NSString *)path{
    NSArray *raws = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *buss = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in raws) {
        NSString *line = [dict valueForKey:@"linha"];
        NSString *name = [dict valueForKey:@"nome"];
        NSDictionary *itinerary = [dict valueForKey:@"itinerario"];
        NSArray *tripItinerary = [itinerary valueForKey:@"ida"];
        NSArray *returnItinerary = [itinerary valueForKey:@"volta"];
        [buss addObject:[[IMTBuss alloc] initWithName:name line:line trip:tripItinerary ret:returnItinerary]];
    }
    raws = nil;
    return buss;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    NSString *line = [aDecoder decodeObjectForKey:@"linha"];
    NSString *name = [aDecoder decodeObjectForKey:@"nome"];
    NSDictionary *dict = [aDecoder decodeObjectForKey:@"itinerario"];
    NSArray *tripItinerary = [dict objectForKey:@"ida"];
    NSArray *returnItinerary = [dict objectForKey:@"volta"];
    return [self initWithName:name line:line trip:tripItinerary ret:returnItinerary];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.line forKey:@"linha"];
    [aCoder encodeObject:self.name forKey:@"nome"];
    NSDictionary *dict = @{@"ida" : self.tripItinerary,
                           @"volta" : self.returnItinerary};
    [aCoder encodeObject:dict forKey:@"itinerario"];
}

@end
