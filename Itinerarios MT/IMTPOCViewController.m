//
//  IMTPOCViewController.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 28/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTPOCViewController.h"
#import "IMTPointOfCharge.h"

@interface IMTPOCViewController (){
    BOOL isMapShowing;
    NSArray *_points;
}

@end

@implementation IMTPOCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isMapShowing = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"points_of_charge" ofType:@"plist"];
    _points = [IMTPointOfCharge loadWithContentOfFile:filePath];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    IMTPointOfCharge *point = _points[indexPath.row];
    cell.textLabel.text = point.name;
    cell.detailTextLabel.text = point.address;
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_points count];
}

-(MKMapView *)mapView{
    
    if(_mapView == nil){
        
        _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
        //Code to center in user
        bool first = YES;
        double minLatitude,maxLatitude;
        double minLongitude,maxLongitude;
        for (IMTPointOfCharge *p in _points) {
            if (!p.hasLocation) continue;
            
            if (first){
                minLatitude  = p.latitude;
                maxLatitude  = p.latitude;
                minLongitude = p.longitude;
                maxLongitude = p.longitude;
                first = NO;
            }
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(p.latitude, p.longitude);
            [annotation setCoordinate:loc];
            [annotation setTitle:p.name]; //You can set the subtitle too
            [self.mapView addAnnotation:annotation];
            
            minLatitude = MIN(minLatitude,p.latitude);
            minLongitude = MIN(minLongitude,p.longitude);
            
            maxLatitude = MAX(maxLatitude,p.latitude);
            maxLongitude = MAX(maxLongitude,p.longitude);
            
        }

        MKCoordinateRegion region;
        region.center.latitude = (minLatitude + maxLatitude) / 2;
        region.center.longitude = (minLongitude + maxLongitude) / 2;
        
        region.span.latitudeDelta = (maxLatitude - minLatitude) * 1.1;
        
        region.span.latitudeDelta = (region.span.latitudeDelta < 0.01)
        ? 0.01
        : region.span.latitudeDelta;
        
        region.span.longitudeDelta = (maxLongitude - minLongitude) * 1.1;
        
        MKCoordinateRegion scaledRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:scaledRegion animated:YES];
        [_mapView setShowsUserLocation:YES];
    }
    
    return _mapView;
    
}


- (IBAction)flipView:(id)sender {
    if(!isMapShowing){
        [UIView transitionWithView:self.view
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            
                            //[self.tblView removeFromSuperview];
                            [self.view addSubview:self.mapView];
                            
                        } completion:nil];
        self.btnFlip.title = @"Ver lista";
        isMapShowing = YES;
    }else{
        [UIView transitionWithView:self.view.superview
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            
                            [self.mapView removeFromSuperview];
                            //[self.view addSubview:self.tblView];
                            
                        } completion:nil];
        self.btnFlip.title = @"Ver mapa";
        isMapShowing = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
