//
//  IMTTracker.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 02/10/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

@interface IMTTracker : NSObject

+(void)sendCreateView:(NSString *) name;

@end
