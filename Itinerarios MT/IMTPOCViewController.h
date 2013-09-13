//
//  IMTPOCViewController.h
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 28/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OCMapView+PointOfCharge.h"

@interface IMTPOCViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

@property (strong, nonatomic) OCMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFlip;
- (IBAction)flipView:(id)sender;

@end
