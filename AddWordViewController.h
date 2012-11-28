//
//  AddWordViewController.h
//  test
//
//  Created by Alberto Chamorro on 11/12/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWordViewController : UIViewController <UITextFieldDelegate> {
}

@property (retain, nonatomic) IBOutlet UITextField *nameField;

- (id) initWithWord:(NSString*)word;
- (IBAction)saveWord:(id)sender;
- (IBAction)cancel:(id)sender;
@end
