//
//  WordViewController.m
//  test
//
//  Created by Alberto Chamorro on 11/22/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import "WordViewController.h"
#import "DataAccess.h"

@interface WordViewController ()
    typedef NS_ENUM(NSInteger, BarButtonItemType) {
        BarButtonItemSave = 0,
        BarButtonItemEdit = 1
    };

    -(UIBarButtonItem*) getBarButtonItem:(BarButtonItemType)type;
@end

@implementation WordViewController

@synthesize deleteWord = _deleteWord;
@synthesize wordName = _wordName;

- (id) initWithWord:(Word*)theWord {
    self = [super initWithNibName:@"WordViewController" bundle:nil];
    
    if (self) {
        // Custom initialization
        self.title = theWord.name;
        
        self.navigationItem.rightBarButtonItem = [self getBarButtonItem:BarButtonItemEdit];
        
        // Create delete button
        UIImage *imageNormal = [UIImage imageNamed:@"redButtonActivated.png"];
        UIImage *stretchableNormalImageButton = [imageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        UIImage *imagePressed = [UIImage imageNamed:@"redButton.png"];
        UIImage *stretchablePressedImageButton = [imagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        
        UIButton *removeWordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [removeWordButton setFrame:CGRectMake(20, 351, 280, 36)];
        
        [removeWordButton setTitle:@"Delete" forState:UIControlStateNormal];
        [removeWordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [removeWordButton setBackgroundImage:stretchableNormalImageButton forState:UIControlStateNormal];
        [removeWordButton setBackgroundImage:stretchablePressedImageButton forState:UIControlStateHighlighted];
        
        [removeWordButton addTarget:self action:@selector(removeWord:) forControlEvents:UIControlEventTouchDown];
        
        // Create Label
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 36)] autorelease];
        label.text = @"Word Name";
        
        // Create an input field
        self.wordName = [[[UITextField alloc] initWithFrame:CGRectMake(20, 40, 280, 30)] autorelease];
        [self.wordName setBorderStyle:UITextBorderStyleRoundedRect];
        [self.wordName setEnabled:NO];
        [self.wordName setText:theWord.name];
        
        [self.view addSubview:removeWordButton];
        [self.view addSubview:label];
        [self.view addSubview:self.wordName];
        
        _currentWord = [theWord retain];
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
    [_deleteWord release];
    [_wordName release];
}

- (void)dealloc {
    [self setDeleteWord:nil];
    [self setWordName:nil];
    [_currentWord release];
    
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if( editing ) {
        self.navigationItem.rightBarButtonItem = [self getBarButtonItem:BarButtonItemSave];
    }else{
        self.navigationItem.rightBarButtonItem = [self getBarButtonItem:BarButtonItemEdit];
    }
    
    [self.wordName setEnabled:editing];
}

#pragma mark actions
- (void)removeWord:(id)sender {
    _alertRemoveWord = [[UIAlertView alloc] initWithTitle:@"Remove Word" message:@"Are you sure you want to delete this word from your dictionary?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

    [_alertRemoveWord show];
}

- (void) saveWord {
    WordsDAO *dao = [[[DataAccess sharedInstance] DAOFactory] wordsDAO];

    if( [dao wordWithName:self.wordName.text] != nil ) {
    }else{
        _currentWord.name = self.wordName.text;
        
        [dao updateWord:_currentWord];
        
        [self setEditing:NO animated:YES];
    }
}

- (void) editWord {
    [self setEditing:YES animated:YES];
}

#pragma mark UIAlertView Delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _alertRemoveWord) {
        if( buttonIndex == 1 ) {
            WordsDAO *dao = [[[DataAccess sharedInstance] DAOFactory] wordsDAO];
            [dao deleteWord:_currentWord];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark Private methods
-(UIBarButtonItem *)getBarButtonItem:(BarButtonItemType)type {
    switch (type) {
        case BarButtonItemSave:
            return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveWord)] autorelease];
            
        case BarButtonItemEdit:
            return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editWord)] autorelease];

    }
}

@end
