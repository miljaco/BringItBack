//
//  DAOFactory.m
//  test
//
//  Created by Alberto Chamorro on 11/15/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "DAOFactory.h"

@implementation DAOFactory

- (id)initWithSqliteAccess:(SqliteAccess*)sqliteAccess {
    if( self = [self init] ) {
        _sqliteAccess = [sqliteAccess retain];
    }
    
    return self;
}

- (WordsDAO*) wordsDAO {
    if( _wordsDAO == NULL ) {
        _wordsDAO = [[WordsDAO alloc] initWithSqliteAccess:_sqliteAccess];
    }
    
    return _wordsDAO;
}

- (void)dealloc {
    [_sqliteAccess release];
    [_wordsDAO release];
    [super dealloc];
    
    _wordsDAO = nil;
    _sqliteAccess = nil;
}

@end
