//
//  Word.h
//  test
//
//  Created by Alberto Chamorro on 11/14/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

@property (nonatomic, readwrite, strong) NSString* name;
@property (nonatomic, readonly) int wordID;

- (id) initWithId:(int)theId;
+ (Word*) wordWithId:(int)theId andValue:(NSString*)theName;

@end
