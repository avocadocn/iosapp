//
//  RegisterViewController.h
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserSex){
    UserSexMan,
    UserSexWoman
};

@interface RegisterViewController : UIViewController

@property (nonatomic, copy)NSString *enterpriseName;

@property (weak, nonatomic) IBOutlet UIButton *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextField *enterpriseNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;

@property (assign, nonatomic) UserSex sex;

@end
