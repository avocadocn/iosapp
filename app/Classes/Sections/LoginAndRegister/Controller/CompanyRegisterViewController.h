//
//  CompanyRegisterViewController.h
//  app
//
//  Created by 申家 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyRegisterViewController : UIViewController

@property (nonatomic, strong)UIButton *companyLogoButton;

@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UITextField *companyNameTextField;
@property (nonatomic, strong)UITextField *companyPasswordTextField;

@property (nonatomic, copy)NSString *companyEmail;
@end
