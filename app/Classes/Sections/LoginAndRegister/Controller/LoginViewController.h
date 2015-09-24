//
//  LoginViewController.h
//  app
//
//  Created by 申家 on 15/7/24.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong)UITextField *mailTextField;

@property (nonatomic, strong)UITextField *passwordTextField;

/**
 *  登录界面的页面信息  默认  NO 需要 leftItem  YES  不需要
 */
@property (nonatomic, assign)BOOL pageState;




@end
