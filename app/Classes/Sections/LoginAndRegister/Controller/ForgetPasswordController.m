//
//  ForgetPasswordController.m
//  app
//
//  Created by 申家 on 15/9/9.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import <SMS_SDK/SMS_SDK.h>

#import "ImageHolderView.h"
#import "ForgetPasswordController.h"
#import "DXAlertView.h"
#import "ResetPasswordViewController.h"
@interface ForgetPasswordController () <UITextFieldDelegate>
@property (nonatomic, strong)ImageHolderView *phoneNumber;
@property (nonatomic, strong)UILabel *label;


@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    self.view.backgroundColor = RGBACOLOR(236, 236, 236, 1);
    self.phoneNumber = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + 10, DLScreenWidth, 50) andImage:[UIImage imageNamed:@"phone"] andPlaceHolder:@"请输入您与warm绑定的手机号"];
    self.phoneNumber.textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumber.textfield.delegate = self;
    [self.view addSubview:self.phoneNumber];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.label.text = @"下一步";
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor lightGrayColor];
    [self.label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 11) {
        self.label.userInteractionEnabled = YES;
        self.label.textColor = RGBACOLOR(253, 185, 0, 1);
        
        return NO;
    }
     else
     {
         self.label.userInteractionEnabled = NO;
         self.label.textColor = [UIColor lightGrayColor];
     }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)addPhoneNumberWithNumString:(NSString *)str
{
    NSMutableString *mutableStr = [NSMutableString stringWithString:str];
    [mutableStr insertString:@"-" atIndex:7];
    [mutableStr insertString:@"-" atIndex:3];
    return mutableStr;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSString *phoneStr = [NSString stringWithFormat:@"+86 %@", [self addPhoneNumberWithNumString:self.phoneNumber.textfield.text]];
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"我们将发送验证码到该手机" contentText:phoneStr leftButtonTitle:@"修改" rightButtonTitle:@"确认"];
    [alert show];
    alert.rightBlock = ^(){
        
        NSString *str2 = [NSString stringWithFormat:@"86"];
        [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumber.textfield.text zone:str2 customIdentifier:@"打死都不能告诉别人" result:^(SMS_SDKError *error) {
            if (!error) {
                ResetPasswordViewController *resetVC = [[ResetPasswordViewController alloc] init];
                resetVC.phoneNumber = self.phoneNumber.textfield.text;
                [self.navigationController pushViewController:resetVC animated:YES];
            }
        }];
    };
    
}

@end
