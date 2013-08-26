//
//  IMTMasterViewController.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTBussViewController.h"
#import "IMTBussDetailViewController.h"
#import "IMTBuss.h"
#define kDataKey       @"Root"
#define kDataFile       @"temp.plist"


@interface IMTBussViewController () {
    NSArray *_objects;
}
@end

@implementation IMTBussViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {        
        self.detailViewController = (IMTBussDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"plist"];
    _objects = [IMTBuss loadWithContentOfFile:filePath];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    IMTBuss *buss = _objects[indexPath.row];
    cell.textLabel.text = [@"Linha " stringByAppendingString:buss.line];
    UILabel *lbl = cell.detailTextLabel;
    lbl.numberOfLines = 2;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.text = [buss.name stringByReplacingOccurrencesOfString:@"/ " withString:@"\n"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        IMTBuss *buss = _objects[indexPath.row];
        [self.detailViewController setBuss:buss];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        IMTBuss *buss = _objects[indexPath.row];
        [[segue destinationViewController] setBuss:buss];
    }
}

@end
