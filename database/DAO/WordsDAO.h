//
//  WordsDAO.h
//  test
//
//  Created by Alberto Chamorro on 11/15/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseDelegate.h"
#import "SqliteAccess.h"
#import "Word.h"

@interface WordsDAO : NSObject <DatabaseAdapterDelegate> {
    NSMutableArray* _words;
    SqliteAccess* _sqliteDB;
}

- (id) initWithSqliteAccess:(SqliteAccess*)sqliteDB;
- (void) updateWord:(Word*)theWord;
- (void) deleteWord:(Word*)theWord;
- (void) insertWordByName:(NSString*) wordName;
- (Word*) wordWithId:(int)wordId;
- (Word*) wordWithName:(NSString*) wordName;
- (NSMutableArray*) getAllWords;

@end
