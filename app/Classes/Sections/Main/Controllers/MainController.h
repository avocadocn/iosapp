//
//  MainController.h
//  DLDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UITabBarController
{
    EMConnectionState _connectionState;
}


- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

@end
