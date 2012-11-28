//
//  DatabaseDelegate.h
//  test
//
//  Created by Alberto Chamorro on 11/26/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SqliteAccess.h"

@protocol DatabaseAdapterDelegate <NSObject>
@required
-(id) queryResult:(NSDictionary*)queryData ofStatement:(sqlite3_stmt*)statement withIdentifier:(NSString*)queryIdentifier;
@end
