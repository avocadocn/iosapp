//
//  RegisterViewController.m
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RegisterViewController.h"
#import "ChoosePhotoController.h"
#import "CardChooseView.h"

#import <Masonry.h>

@interface RegisterViewController ()<CardChooseViewDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self builtInterface];
}

- (void)builtInterface
{
    CGFloat imageButtonWidth = 75;
    self.userPhotoImageView = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userPhotoImageView.layer.masksToBounds = YES;
    self.userPhotoImageView.backgroundColor = [UIColor yellowColor];
    self.userPhotoImageView.layer.cornerRadius = imageButtonWidth / 2.0;  //弧度
    [self.userPhotoImageView addTarget:self action:@selector(userPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userPhotoImageView];
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(imageButtonWidth, imageButtonWidth));
    }];
    
    
    
    NSArray *labelNameArray = @[@"企业名称",@"公司邮箱",@"昵    称",@"密    码"];
    self.enterpriseNameTextField = [UITextField new];
    self.companyMailTextField = [UITextField new];
    self.userNickNameTextField = [UITextField new];
    self.userPasswordTextField = [UITextField new];
    NSArray *componentArray = @[self.enterpriseNameTextField, self.companyMailTextField, self.userNickNameTextField, self.userPasswordTextField];
    
    NSInteger numOfHeight = 25;
    
    NSInteger i  =0;
    for (NSString *str in labelNameArray) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 150 + i * (numOfHeight + 25), 260, numOfHeight)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, numOfHeight)];
        label.text = str;
        [view addSubview:label];
        
        UITextField *textField = [componentArray objectAtIndex:i];
        [
         view addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.left.mas_equalTo(label.mas_right).offset(10);
            make.right.mas_equalTo(view.mas_right);
        }];
        
        [self.view addSubview:view];
        i++;
    }
    
    
    self.manButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.manButton addTarget:self action:@selector(userSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.manButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [self.view addSubview:self.manButton];
    
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNickNameTextField.mas_top);
        make.left.mas_equalTo(self.userNickNameTextField.mas_right).offset(3);
        make.bottom.mas_equalTo(self.userNickNameTextField.mas_bottom);
        make.width.mas_equalTo(self.userNickNameTextField.mas_height);
    }];
    
    self.womanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.womanButton addTarget:self action:@selector(userSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanButton setBackgroundImage:[UIImage imageNamed:@"gray-woman"] forState:UIControlStateNormal];
    [self.view addSubview:self.womanButton];
    
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.manButton.mas_top);
        make.left.mas_equalTo(self.manButton.mas_right).offset(3);
        make.bottom.mas_equalTo(self.manButton.mas_bottom);
        make.height.mas_equalTo(self.manButton.height);
    }];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginButton addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:.9 green:.2 blue:.2 alpha:1]];
    [self.loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 45 / 2.0;
    [self.view addSubview:self.loginButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.view.mas_bottom).offset(-150);
    }];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)userLoginAction:(id)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"注册" forKey:@"name"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginAccount" object:nil userInfo:dic];
}


- (void)userSexAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            
            self.sex = UserSexMan;  // 男
            [self.manButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
            [self.womanButton setBackgroundImage:[UIImage imageNamed:@"gray-woman"] forState:UIControlStateNormal];
            break;
        case 2:
            
            self.sex = UserSexWoman;
            [self.manButton setBackgroundImage:[UIImage imageNamed:@"gray-man"] forState:UIControlStateNormal];
            [self.womanButton setBackgroundImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
            break;
    }
    
}

- (void)userPhotoButtonAction:(id)sender {
    CardChooseView *card = [[CardChooseView alloc]initWithTitleArray:@[@"从相册选取",@"拍摄"]];
    card.delegate = self;
    
    [self.view addSubview:card];
    [card show];
}


- (void)cardActionWithButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:{
            ChoosePhotoController *choose = [ChoosePhotoController shareStateOfController];
            [self.navigationController pushViewController:choose animated:YES];
            break;
        }
        case 2:{
            break;
        }
        default:
            break;
    }
}


@end

