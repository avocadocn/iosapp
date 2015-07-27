
//
//  RegisterViewController.h
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, UserRegisterState) {
    UserRegisterForCompany,          // 帮公司注册,公司邮箱传递过来,皆可设定
    UserRegisterStateForFoundCompany,  //找到公司, 公司邮件固定,名称固定, 昵称,性别,密码自定义
};

typedef NS_ENUM(NSInteger, UserSex){
    UserSexMan,
    UserSexWoman
};

@interface RegisterViewController : UIViewController

@property (nonatomic, copy)NSString *enterpriseName; // 公司名字

@property (strong, nonatomic)UIButton *userPhotoImageView;
@property (strong, nonatomic)UITextField *enterpriseNameTextField;
@property (strong, nonatomic)UITextField *userNickNameTextField;
@property (strong, nonatomic)UITextField *userPasswordTextField;
@property (strong, nonatomic)UIButton *loginButton;
@property (strong, nonatomic)UIButton *manButton;
@property (strong, nonatomic)UIButton *womanButton;
@property (strong, nonatomic)UITextField *companyMailTextField;

@property (assign, nonatomic) UserSex sex;

@property (nonatomic, copy)NSString *comMail;  //公司邮箱

@end
