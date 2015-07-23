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

@interface RegisterViewController ()<CardChooseViewDelegate>

@end

@implementation RegisterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self builtInterface];
    }
    return self;
}
- (void)builtInterface
{
    self.title = @"个人注册";
    if (self.enterpriseName) {
        self.enterpriseNameTextField.text = self.enterpriseName;
        self.enterpriseNameTextField.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)userLoginAction:(id)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"注册" forKey:@"name"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginAccount" object:nil userInfo:dic];
}


- (IBAction)userSexAction:(UIButton *)sender {
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

- (IBAction)userPhotoButtonAction:(id)sender {
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
