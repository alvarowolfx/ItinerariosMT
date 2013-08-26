//
//  IMTMasterViewController.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMTBussDetailViewController;

@interface IMTBussViewController : UITableViewController

@property (strong, nonatomic) IMTBussDetailViewController *detailViewController;

@end
