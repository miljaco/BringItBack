//
//  Word.m
//  test
//
//  Created by Alberto Chamorro on 11/14/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "Word.h"

@interface Word()
    @property (nonatomic, readwrite) int wordID;
@end

@implementation Word

@synthesize name = _name, wordID = _wordID;

- (id) initWithId:(int)theId {
    if(self = [self init]) {
        self.wordID = theId;
    }
    
    return self;
}

+ (Word*) wordWithId:(int)theId andValue:(NSString*)theName {
    Word* result = [[Word alloc] initWithId:theId];
    result.name = theName;
    
    return [result autorelease];
}

@end
