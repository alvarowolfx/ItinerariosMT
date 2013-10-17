//
//  IMTPOCViewController.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 28/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTPOCViewController.h"
#import "IMTPointOfCharge.h"
#import <FlatUIKit/FlatUIKit.h>
#import "IMTTracker.h"
#import <math.h>
#define kDEFAULTCLUSTERSIZE 0.1
#define kDEFAULTMINZOOM 0.05

@interface IMTPOCViewController (){
    BOOL isMapShowing;
    NSArray *_points;
}

@end

@implementation IMTPOCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor peterRiverColor]];
    
    [IMTTracker sendCreateView:@"POC View"];
    
    isMapShowing = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"points_of_charge" ofType:@"plist"];
    _points = [IMTPointOfCharge loadWithContentOfFile:filePath];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _mapView.frame = self.view.frame;
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.tabBarController.tabBar.hidden = isMapShowing;
    }
    if (isMapShowing){
        UIImage *imgLoc = [UIImage imageNamed:@"loc.png"];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] init]];
        self.navigationItem.leftBarButtonItem.image = imgLoc;
        self.navigationItem.leftBarButtonItem.action = @selector(gotoUserLocation);
        self.navigationItem.leftBarButtonItem.target = self;
        
        
    }else{
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}


-(void)gotoUserLocation{
    MKUserLocation *loc = _mapView.userLocation;
    [self gotoLocation:loc.coordinate animated:YES];
    //NSLog(@"Chamando center");

}

-(void)gotoLocation:(CLLocationCoordinate2D) coordinate animated:(BOOL) animated{
    [self.mapView setCenterCoordinate:coordinate animated:animated];
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion scaledRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:scaledRegion animated:animated];
}

-(OCMapView *)mapView{
    
    if(_mapView == nil){

        _mapView = [[OCMapView alloc] initWithFrame:self.view.frame ];
        _mapView.delegate = self;
        _mapView.clusterByGroupTag = YES;
        _mapView.clusterSize = kDEFAULTCLUSTERSIZE;
        _mapView.minLongitudeDeltaToCluster = kDEFAULTMINZOOM;
        [_mapView configureWithPoints:_points];
        
        UIImage *imgLoc = [UIImage imageNamed:@"loc.png"];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] init]];
        self.navigationItem.leftBarButtonItem.image = imgLoc;
        self.navigationItem.leftBarButtonItem.action = @selector(gotoUserLocation);
        self.navigationItem.leftBarButtonItem.target = self;
        
        [IMTTracker sendCreateView:@"POC Map View"];
    }
    
    return _mapView;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IMTPointOfCharge *point = _points[indexPath.row];
    if(point.hasLocation){
        [self flipView:nil];
        [self gotoLocation:point.coordinate animated:NO];
        int idx = [[self.mapView annotations] indexOfObjectIdenticalTo:point];
        if (idx != NSNotFound){
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.mapView selectAnnotation:[[self.mapView annotations] objectAtIndex:idx] animated:YES];
            });
        }else{
            NSLog(@"Mioou");
        }
    }
    /*
    }else{
        FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Sem localização cadastrada" message:point.address delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
     */
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor cloudsColor];
    
    IMTPointOfCharge *point = _points[indexPath.row];    
    cell.textLabel.text = point.name;
    cell.textLabel.textColor = [UIColor midnightBlueColor];
    cell.detailTextLabel.text = point.address;
    cell.detailTextLabel.textColor = [UIColor midnightBlueColor];
    
    if ( [point hasLocation]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_points count];
}

#pragma mark - Map View

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView doClustering];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    if ([annotation isKindOfClass:[IMTPointOfCharge class]]) {
        static NSString *identifier = @"IMTPointOfCharge";
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, -10);
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:@"point-icon.png"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
        
    }else if ([annotation isKindOfClass:[OCAnnotation class]]){
        static NSString *identifier = @"Cluster";
        
        OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
        clusterAnnotation.title = @"Pontos de venda";
        clusterAnnotation.subtitle = [NSString stringWithFormat:@"Contém %d pontos de venda",[clusterAnnotation.annotationsInCluster count] ];
        
        CLLocationDistance clusterRadius = mapView.region.span.longitudeDelta * _mapView.clusterSize * 111000 / 2.0f;
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
        [circle setTitle:@"background"];
        [_mapView addOverlay:circle];
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:clusterAnnotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, -10);
            
            //annotationView.pinColor = MKPinAnnotationColorRed;
        } else {
            annotationView.annotation = clusterAnnotation;
        }
        annotationView.image = [UIImage imageNamed:@"group-icon.png"];
        
        return annotationView;
    }
    
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    MKCircle *circle = overlay;
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    
    if ([circle.title isEqualToString:@"background"])
    {
        circleView.fillColor = [UIColor orangeColor];
        circleView.alpha = 0.25;
        circleView.strokeColor = [UIColor blackColor];
        circleView.lineWidth = 1.5;
    }
    return circleView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    IMTPointOfCharge *location = (IMTPointOfCharge*)view.annotation;
    //NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    NSDictionary *launchOptions = [NSDictionary dictionary];
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}

@end

