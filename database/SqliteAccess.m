//
//  SqliteAccess.m
//  test
//
//  Created by Alberto Chamorro on 11/15/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "SqliteAccess.h"

@interface SqliteAccess()
    - (NSString*) getDBPath:(NSString*)theDatabase;
    - (BOOL) createDatabase:(NSString*)theDatabase;
    - (BOOL) existsDatabase:(NSString*)theDatabase;
    - (BOOL) openDatabase;
    - (BOOL) closeDatabase;
    - (id)sendErrorMessageTo:(id)delegate andMessage:(NSString*)message andQuery:(NSString*)queryIdentifier;
@end

@implementation SqliteAccess

- (id) initWithExistingDatabase:(NSString*)theDatabase orCreateIt:(BOOL)create {
    if( self = [super init] ) {
        if(! [self existsDatabase:theDatabase] ) {
            if(create && ![self createDatabase:theDatabase]) {
                @throw [NSException exceptionWithName:@"DatabaseException" reason:@"The database does not exist and could not be created!" userInfo:nil];
            }
        }
        
        _databaseName = theDatabase;
    }

    return self;
}

- (BOOL) closeDatabase {
    if( _database != NULL ) {
        if( sqlite3_close(_database) != SQLITE_OK ) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark Private methods
- (NSString*) getDBPath: (NSString*)theDatabase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:theDatabase];
}

/**
 * Note: this function copy the database from the application to the
 * documents directory. Probably can be good to give code to create
 * the database
 */
- (BOOL) createDatabase:(NSString*)theDatabase {
    // copy the database
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString* defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theDatabase];
    
    return [manager copyItemAtPath:defaultDBPath toPath:[self getDBPath:theDatabase] error:nil];
}

- (BOOL) existsDatabase: (NSString*)theDatabase {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dbPath = [self getDBPath:theDatabase];
    
    return [manager fileExistsAtPath:dbPath];
}

- (BOOL) openDatabase {
    NSString *databasePath = [self getDBPath:_databaseName];
    
    if( sqlite3_open_v2([databasePath UTF8String], &_database, SQLITE_OPEN_READWRITE, NULL) == SQLITE_OK) {
        return YES;
    }else{
        return NO;
    }
}

- (NSDictionary*) executeSql:(NSString*) sql {
    NSArray *keys = [NSArray arrayWithObjects:QueryMessage, QueryResult, nil];
    
    if(! [self openDatabase] ) {
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(_database)];
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:errorMessage, @"NO", nil] forKeys:keys];
    }
    
    NSDictionary *result;
    if( sqlite3_exec(_database, [sql UTF8String], NULL, NULL, NULL) == SQLITE_OK ) {
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"", @"YES", nil] forKeys:keys];
    }else{
        NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(_database)];
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:errorMessage, @"NO", nil] forKeys:keys];
    }

    [self closeDatabase];
    
    return result;
}

-(id) executeSql:(NSString*)sql withQueryIdentifier:(NSString*)queryIdentifier andDelegate:(id)delegate {
    if( [delegate conformsToProtocol:@protocol(DatabaseAdapterDelegate)] ) {
        sqlite3_stmt *statement;
        
        if (! [self openDatabase]) {
            return [self sendErrorMessageTo:delegate andMessage:@"The database could not be opened" andQuery:queryIdentifier];
        }
        
        if(! sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK ) {
            NSString *reason = [NSString stringWithUTF8String:sqlite3_errmsg(_database)];
            
            return [self sendErrorMessageTo:delegate andMessage:[@"The statemente could not be prepared. Reason: " stringByAppendingString:reason] andQuery:queryIdentifier];
        }
        
        id result = [self sendSuccessMessageTo:delegate withIdentifier:queryIdentifier statement:statement];
        
        sqlite3_finalize(statement);
        
        if(! [self closeDatabase] ) {
            NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(_database)];
            NSLog(@"The database could not be closed. Reason %@", errorMessage);
        }
        
        return result;
    }
    
    return nil;
}

- (id)sendSuccessMessageTo:(id)delegate withIdentifier:(NSString*)queryIdentifier statement:(sqlite3_stmt*)statement {
    NSDictionary* queryData = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"Result"];
    SEL selector = @selector(queryResult:ofStatement:withIdentifier:);
    NSMethodSignature *methodSignature = [delegate methodSignatureForSelector:selector];
    id result;
    
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:delegate];
        [invocation setSelector:selector];
        [invocation setArgument:&queryData atIndex:2];
        [invocation setArgument:&statement atIndex:3];
        [invocation setArgument:&queryIdentifier atIndex:4];
        [invocation invoke];
        [invocation getReturnValue:&result];
    
    return result;
}

- (id)sendErrorMessageTo:(id)delegate andMessage:(NSString*)message andQuery:(NSString*)queryIdentifier {
    SEL selector = @selector(queryResult:ofStatement:withIdentifier:);
    NSMethodSignature *methodSignature = [delegate methodSignatureForSelector:selector];
    id returnValue;
    NSDictionary *queryData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], message, nil] forKeys:[NSArray arrayWithObjects:@"Result", @"Message", nil]];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:delegate];
        [invocation setSelector:selector];
        [invocation setArgument:&queryData atIndex:2];
        [invocation setArgument:nil atIndex:3];
        [invocation setArgument:&queryIdentifier atIndex:4];
        [invocation invoke];
        [invocation getReturnValue:&returnValue];
    
    return returnValue;
}

@end
