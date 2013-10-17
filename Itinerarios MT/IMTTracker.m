//
//  IMTTracker.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 02/10/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTTracker.h"

@implementation IMTTracker

+(void)sendCreateView:(NSString *) name{
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];    
}

@end
