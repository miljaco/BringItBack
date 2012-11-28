//
//  WordViewController.h
//  test
//
//  Created by Alberto Chamorro on 11/22/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface WordViewController : UIViewController <UIAlertViewDelegate> {
    Word *_currentWord;
    UIAlertView *_alertRemoveWord;
}

@property (nonatomic, retain) UIButton *deleteWord;
@property (nonatomic, retain) UITextField *wordName;

-(id) initWithWord:(Word*) word;
-(void) removeWord:(id)sender;
-(void) saveWord;
-(void) editWord;
@end
