//
//  TSTAppDelegate.h
//  test
//
//  Created by Alberto Chamorro on 10/9/12.
//  Copyright (c) 2012 Alberto Chamorro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataAccess.h"

@interface TSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) DataAccess *dataAccess;

@end
