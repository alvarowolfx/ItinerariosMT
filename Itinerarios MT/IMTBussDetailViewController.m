//
//  IMTDetailViewController.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTBussDetailViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>

@interface IMTBussDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation IMTBussDetailViewController

#pragma mark - Managing the detail item

- (void)setBuss:(id)newBuss
{
    if (_buss != newBuss) {
        _buss = newBuss;
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.buss) {
        [self.tblItinerary reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.buss.name;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.smcItineraryType.selectedSegmentIndex == 0){
        return self.buss.tripItinerary.count;
    }else{
        return self.buss.returnItinerary.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor greenSeaColor];
    NSString *path = @"";
    if(self.smcItineraryType.selectedSegmentIndex == 0){
        path = self.buss.tripItinerary[indexPath.row];
    }else{
        path = self.buss.returnItinerary[indexPath.row];
    }
    cell.textLabel.text = path;
    cell.textLabel.textColor = [UIColor cloudsColor];
    
    return cell;
}

- (IBAction)smcItineraryValueChanged:(UISegmentedControl *)sender {
    [self.tblItinerary reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
