//
//  AddWordViewController.m
//  test
//
//  Created by Alberto Chamorro on 11/12/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "AddWordViewController.h"
#import "DataAccess.h"

@interface AddWordViewController ()

@end

@implementation AddWordViewController

@synthesize nameField = _nameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (id) initWithWord:(NSString*)word {
    if( self = [self initWithNibName:@"AddWordViewController" bundle:nil] ) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveWord:(id)sender {
    if(! [self.nameField.text isEqualToString:@""] ) {
        WordsDAO* wordsDao = [[[DataAccess sharedInstance] DAOFactory] wordsDAO];
        
        if( [wordsDao wordWithName:self.nameField.text] != nil ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Overwrite" message:@"The word already exists" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
            [wordsDao insertWordByName:self.nameField.text];
            [self dismissModalViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Please fill the word name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNameField:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameField resignFirstResponder];
    
    return YES;
}

@end
