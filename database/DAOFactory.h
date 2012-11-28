//
//  DAOFactory.h
//  test
//
//  Created by Alberto Chamorro on 11/15/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteAccess.h"
#import "WordsDAO.h"

@interface DAOFactory : NSObject {
    SqliteAccess* _sqliteAccess;
    WordsDAO *_wordsDAO;
}

- (id)initWithSqliteAccess:(SqliteAccess*)sqliteAccess;
- (WordsDAO*) wordsDAO;
@end
