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
#import <FlatUIKit/FlatUIKit.h>
#import "IMTTracker.h"

#define kDataKey       @"Root"
#define kDataFile      @"temp.plist"


@interface IMTBussViewController () {
    NSArray *_objects;
    NSMutableArray *_filtered_objects;
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
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor peterRiverColor]];
    [self.tabBarController.tabBar configureFlatTabBarWithColor:[UIColor peterRiverColor] selectedColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor cloudsColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        
        [self.searchDisplayController.searchBar setBarStyle:UIBarStyleBlackOpaque];
        [self.searchDisplayController.searchBar setTintColor:[UIColor peterRiverColor]];
        [self.searchDisplayController.searchBar setBarTintColor:[UIColor cloudsColor]];
        [self.searchDisplayController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [self.searchDisplayController.searchBar setBackgroundColor:[UIColor cloudsColor]];
        self.navigationItem.backBarButtonItem.title = @"";
        
    }else{
        self.navigationItem.backBarButtonItem.title = @"Voltar";
    }
    
    
    [IMTTracker sendCreateView:@"Buss View"];
    
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
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return _filtered_objects.count;
    }else{
        return _objects.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor cloudsColor];
    
    IMTBuss *buss = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        buss = _filtered_objects[indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else{
        buss = _objects[indexPath.row];
    }
    UILabel *lblLinha = cell.textLabel;
    UILabel *lblNome = cell.detailTextLabel;
        
    lblLinha.text = [@"Linha " stringByAppendingString:buss.line];
    lblLinha.textColor = [UIColor midnightBlueColor];
    
    lblNome.text = [buss.name stringByReplacingOccurrencesOfString:@"/ " withString:@"\n"];
    lblNome.textColor = [UIColor midnightBlueColor];
    lblNome.lineBreakMode = NSLineBreakByWordWrapping;
    lblNome.numberOfLines = 2;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            return 50.0f;
        }else{
            return 70.0f;
        }
    }else{
        return 70.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        IMTBuss *buss = _objects[indexPath.row];
        [self.detailViewController setBuss:buss];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView)
        [self performSegueWithIdentifier:@"showDetail" sender:self];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope {
    [_filtered_objects removeAllObjects];

    NSPredicate *predicate = nil;
    if(scope == 0){
        predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@ || SELF.line contains[cd] %@",searchText,searchText];
    }else{
        predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMTBuss *buss = (IMTBuss *) evaluatedObject;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:buss.tripItinerary.count + buss.returnItinerary.count];
            [arr addObjectsFromArray:buss.tripItinerary];
            [arr addObjectsFromArray:buss.returnItinerary];
            
            for(NSString *t in arr){
                if([t.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound)
                    return YES;
            }
            
            return NO;
        }];
    }
    _filtered_objects = [NSMutableArray arrayWithArray:[_objects filteredArrayUsingPredicate:predicate]];
    
}

#pragma mark - UISearchBar

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:searchOption];
    return YES;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        IMTBuss *buss = nil;
        if(self.searchDisplayController.isActive){
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            buss = _filtered_objects[indexPath.row];
        }else{
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            buss = _objects[indexPath.row];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Linhas" style:UIBarButtonItemStylePlain target:nil action:nil];
        }else{
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        }
        [[segue destinationViewController] setBuss:buss];
    }
}

@end
