//
//  DataAccess.h
//  test
//
//  Created by Alberto Chamorro on 11/9/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAOFactory.h"

@interface DataAccess : NSObject {
    DAOFactory *_DAOFactory;
    int index;
}

@property (nonatomic, readonly) DAOFactory* DAOFactory;

- (DAOFactory*) DAOFactory;
+ (DataAccess*) sharedInstance;
@end
