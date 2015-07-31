//
//  AppDelegate.h
//  etrst
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyViewController.h"
#import "MainController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITextField *mailBoxTextField;


@property (strong, nonatomic) MainController *mainController;
@end

