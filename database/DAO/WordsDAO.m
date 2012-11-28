//
//  WordsDAO.m
//  test
//
//  Created by Alberto Chamorro on 11/15/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "WordsDAO.h"
#import "Word.h"
#import <sqlite3.h>

#define SQL_INSERT_WORD @"INSERT INTO words(name) VALUES ('%@')"
#define SQL_UPDATE_WORD @"UPDATE words SET name='%@' WHERE id='%d'"
#define SQL_DELETE_WORD @"DELETE FROM words WHERE id='%d'"
#define SQL_SELECT_ALL_WORDS @"SELECT * FROM words"
#define SQL_SELECT_WORD_WITH_ID @"SELECT * FROM words WHERE id=%d"
#define SQL_SELECT_WORD_WITH_NAME @"SELECT * FROM words WHERE name='%@'"

#define QUERY_IDENTIFIER_INSERT @"insertWord"
#define QUERY_IDENTIFIER_UPDATE @"updateWord"
#define QUERY_IDENTIFIER_DELETE @"deleteWord"
#define QUERY_IDENTIFIER_SELECT_ALL @"getAllWords"
#define QUERY_IDENTIFIER_SELECT_BY_ID @"getWordWithId"
#define QUERY_IDENTIFIER_SELECT_BY_NAME @"getWordWithName"

@interface WordsDAO()
- (void) notifyDataObservers;
@end

@implementation WordsDAO

- (id) initWithSqliteAccess:(SqliteAccess*) sqliteDB {
    if( self = [super init] ) {
        _sqliteDB = [sqliteDB retain];
                
        _words = [[self getAllWords] retain];
    }
    
    return self;
}

- (void) insertWordByName:(NSString*) wordName {
    NSString *sql = [NSString stringWithFormat:SQL_INSERT_WORD, wordName];
    
    NSDictionary* sqlResult = [_sqliteDB executeSql:sql];
    if( [sqlResult objectForKey:QueryResult] == @"YES" ) {
        [self notifyDataObservers];
    }else{
        NSString *message = [sqlResult objectForKey:QueryMessage];
        NSLog(@"Error: %@", message);
    }
}

- (void) updateWord:(Word*)theWord {
    NSString *sql = [NSString stringWithFormat:SQL_UPDATE_WORD, theWord.name, theWord.wordID];
    
    NSDictionary* sqlResult = [_sqliteDB executeSql:sql];
    if( [sqlResult objectForKey:QueryResult] == @"YES" ) {
        [self notifyDataObservers];
    }else{
        NSString *message = [sqlResult objectForKey:QueryMessage];
        NSLog(@"Error: %@", message);
    }
}

- (void) deleteWord:(Word*)theWord {
    NSString *sql = [NSString stringWithFormat:SQL_DELETE_WORD, theWord.wordID];
    
    NSDictionary* sqlResult = [_sqliteDB executeSql:sql];
    if( [sqlResult objectForKey:QueryResult] == @"YES" ) {
        [self notifyDataObservers];
    }else{
        NSString *message = [sqlResult objectForKey:QueryMessage];
        NSLog(@"Error: %@", message);
    }
}

- (Word*) wordWithId:(int)wordId {
    return [_sqliteDB executeSql:[NSString stringWithFormat:SQL_SELECT_WORD_WITH_ID, wordId] withQueryIdentifier:QUERY_IDENTIFIER_SELECT_BY_ID andDelegate:self];
}

- (Word*) wordWithName:(NSString*) wordName {
    return [_sqliteDB executeSql:[NSString stringWithFormat:SQL_SELECT_WORD_WITH_NAME, wordName] withQueryIdentifier:QUERY_IDENTIFIER_SELECT_BY_NAME andDelegate:self];
}

- (NSMutableArray*) getAllWords {
    return [_sqliteDB executeSql:SQL_SELECT_ALL_WORDS withQueryIdentifier:QUERY_IDENTIFIER_SELECT_ALL andDelegate:self];
}

- (id)wordsAdapter:(sqlite3_stmt *)statement {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int index;
    NSString *wordName;
    
    while( sqlite3_step(statement) == SQLITE_ROW ) {
        index = sqlite3_column_int(statement, 0);
        wordName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
        [result addObject:[Word wordWithId:index andValue:wordName]];
    }
    
    return [result autorelease];
}

-(id) queryResult:(NSDictionary*)queryData ofStatement:(sqlite3_stmt*)statement withIdentifier:(NSString*)queryIdentifier {
    BOOL success = [(NSNumber*)[queryData objectForKey:@"Result"] boolValue];
    if(! success ) {
        NSString *message = [queryData objectForKey:@"Message"];
        NSLog(@"Database Error: %@ failed because of '%@'", queryIdentifier, message);
    }
    
    if( [queryIdentifier isEqualToString:QUERY_IDENTIFIER_SELECT_ALL] ) {
        return [self wordsAdapter:statement];
    }
    
    if( [queryIdentifier isEqualToString:QUERY_IDENTIFIER_SELECT_BY_ID] || [queryIdentifier isEqualToString:QUERY_IDENTIFIER_SELECT_BY_NAME]) {
        NSMutableArray *words = [self wordsAdapter:statement];
        
        if( [words count] > 0 ) {
            return [words objectAtIndex:0];
        }
    }
   
    return nil;
}

- (void) notifyDataObservers {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWordChanged" object:nil];
}

- (void)dealloc {
    [_sqliteDB release];
    [_words release];
    [super dealloc];
}

@end
