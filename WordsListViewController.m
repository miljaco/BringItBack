//
//  MainViewController.m
//  test
//
//  Created by Alberto Chamorro on 11/8/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "WordsListViewController.h"
#import "AddWordViewController.h"
#import "WordViewController.h"
#import "TSTAppDelegate.h"
#import "Word.h"

@interface WordsListViewController ()
@end

@implementation WordsListViewController

@synthesize filteredTableData = _filteredTableData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Words";
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)] autorelease];
        _dataAccess = [DataAccess sharedInstance];
        DAOFactory *daoFactory = [DataAccess sharedInstance].DAOFactory;
        _wordsDAO = [[daoFactory wordsDAO] retain];
        _data = [[[daoFactory wordsDAO] getAllWords] retain];
        _selectedRow = -1;
        self.filteredTableData = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(updateTable) name:@"DataWordChanged" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_dataAccess release];
    [_wordsDAO release];
    [_data release];
    [_filteredTableData release];
    
    _dataAccess = nil;
    _wordsDAO = nil;
    _data = nil;
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void) addItem {
    AddWordViewController *addWordViewController = [[AddWordViewController alloc] initWithNibName:@"AddWordViewController" bundle:nil];
    
    [self presentModalViewController:addWordViewController animated:YES];
    
    [addWordViewController release];
}

- (void) updateTable {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_data release];
        
        _data = [[[[[DataAccess sharedInstance] DAOFactory] wordsDAO] getAllWords] retain];
        [self.tableView reloadData];
    });
}

- (NSMutableArray*) getDataSourceForTableView:(UITableView*)tableView {
    if( tableView == self.searchDisplayController.searchResultsTableView ) {
        return self.filteredTableData;
    }else{
        return _data;
    }
}

#pragma mark UITableViewDelegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if( tableView == self.searchDisplayController.searchResultsTableView ) {
        return [self.filteredTableData count];
    }else{
        return [_data count];
    }
}

#pragma mark UITableViewDataSource methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedRow = indexPath.row;

    NSMutableArray *dataSource = [self getDataSourceForTableView:tableView];
    Word* word = [dataSource objectAtIndex:indexPath.row];
    WordViewController *controller = [[WordViewController alloc] initWithWord:word];
    
    TSTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"reuseMe";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    if( tableView == self.searchDisplayController.searchResultsTableView ) {
        if( indexPath.row < [self.filteredTableData count] ){
            Word* word = [self.filteredTableData objectAtIndex:indexPath.row];
            cell.textLabel.text = word.name;
        } else {
            return nil;
        }
    }else{
        if( indexPath.row < [_data count] ) {
            Word* word = [_data objectAtIndex:indexPath.row];
            cell.textLabel.text = word.name;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            if( [tableView isEditing] ) {
                [cell setSelectionStyle:UITableViewCellEditingStyleNone];
            }else{
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
        }else{
            if( tableView != self.searchDisplayController.searchResultsTableView ) {
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.text = @"Add a new animal...";
            }
        }
    }
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void) filterContentForSearchText:(NSString *)searchString {
    [self.filteredTableData removeAllObjects];
    
    // TODO Change this ugly code, I know I can do it better
    for( Word* word in _data ) {
        NSComparisonResult result = [word.name compare:searchString options:(NSCaseInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        
        if( result == NSOrderedSame ) {
            [self.filteredTableData addObject:word];
        }
    }
}

#pragma UISearchBarDelegate methods
#pragma UISearchDisplayDelegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText: searchString];
    
    return YES;
    
}
/*
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
}*/
@end
