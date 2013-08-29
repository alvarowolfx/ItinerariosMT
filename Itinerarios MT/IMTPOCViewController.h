//
//  IMTPOCViewController.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 28/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface IMTPOCViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFlip;
- (IBAction)flipView:(id)sender;

@end
