//
//  DataAccess.m
//  test
//
//  Created by Alberto Chamorro on 11/9/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "DataAccess.h"

#define WORDS_DB @"words.sqlite"

@interface DataAccess()
- (id) initDataAccess;
@end

@implementation DataAccess

static DataAccess *_instance = nil;

@synthesize DAOFactory;

// Prevent the developer to init the DataAccess with [[DataAccess alloc] init]
- (id) init {
    return nil;
}

- (id) initDataAccess {
    if( self = [super init] ) {
        SqliteAccess *sqliteDB = [[SqliteAccess alloc] initWithExistingDatabase:WORDS_DB orCreateIt:YES];
        _DAOFactory = [[DAOFactory alloc] initWithSqliteAccess:sqliteDB];
        [sqliteDB release];
    }

    return self;
}

- (DAOFactory*) DAOFactory {
    return _DAOFactory;
}

+ (DataAccess*) sharedInstance {
    if( _instance == nil ) {
        _instance = [[DataAccess alloc] initDataAccess];
    }
    
    return _instance;
}

- (id) retain {
    return self;
}

- (id) autorelease {
    return self;
}

- (oneway void) release {
    
}

- (NSUInteger) retainCount {
    return NSUIntegerMax;
}

@end
