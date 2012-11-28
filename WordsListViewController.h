//
//  MainViewController.h
//  test
//
//  Created by Alberto Chamorro on 11/8/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccess.h"
#import "WordsDAO.h"

@interface WordsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    DataAccess *_dataAccess;
    WordsDAO *_wordsDAO;
    NSMutableArray *_data;
    int _selectedRow;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *filteredTableData;

- (void) addItem;
- (void) updateTable;
- (void) filterContentForSearchText:(NSString*) searchString;
- (NSMutableArray*) getDataSourceForTableView:(UITableView*)tableView;

@end
