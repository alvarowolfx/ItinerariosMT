//
//  IMTBuss.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMTBuss : NSObject <NSCoding>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *line;
@property (nonatomic,strong) NSArray *tripItinerary;
@property (nonatomic,strong) NSArray *returnItinerary;

- (id)initWithName:(NSString *) name line:(NSString *) line trip:(NSArray *) trip ret:(NSArray *) ret;
+ (NSArray *) loadWithContentOfFile:(NSString *) path;

@end
