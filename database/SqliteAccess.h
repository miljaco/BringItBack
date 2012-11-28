//
//  SqliteAccess.h
//  test
//
//  Created by Alberto Chamorro on 11/15/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DatabaseDelegate.h"

#define QueryResult @"QueryResult"
#define QueryMessage @"QueryMessage"

@interface SqliteAccess : NSObject {
    sqlite3* _database;
    NSString *_databaseName;
}

- (id) initWithExistingDatabase:(NSString*)theDatabase orCreateIt:(BOOL)create;
- (NSDictionary*) executeSql:(NSString*) sql;
- (id) executeSql:(NSString*) sql withQueryIdentifier:(NSString*)queryIdentifier andDelegate:(id)delegate;

@end
