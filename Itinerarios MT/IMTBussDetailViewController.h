//
//  IMTDetailViewController.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTBuss.h"
#import <FlatUIKit/FUISegmentedControl.h>

@interface IMTBussDetailViewController : UIViewController <UISplitViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IMTBuss *buss;
@property (weak, nonatomic) IBOutlet UISegmentedControl *smcItineraryType;
@property (weak, nonatomic) IBOutlet UITableView *tblItinerary;
- (IBAction)smcItineraryValueChanged:(UISegmentedControl *)sender;

@end
