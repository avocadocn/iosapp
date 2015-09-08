//
//  AccountAndPassword.m
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AccountAndPassword.h"
#import <Masonry.h>
#import "ImageHolderView.h"
#import "DXAlertView.h"
#import "VerifiCodeController.h"
#import <ReactiveCocoa.h>
#import <SMS_SDK/SMS_SDK.h>
#import "LoginSinger.h"


@interface AccountAndPassword ()<UITextFieldDelegate>

@end

@implementation AccountAndPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
    
}

- (void)builtInterface
{
    self.title = @"设置账号和密码";
    
    self.view.backgroundColor = DLSBackgroundColor;
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    self.label.text = @"下一步";
    self.label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
//    label.userInteractionEnabled = YES;
    [self.label addGestureRecognizer:labelTap];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.label];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLMultipleHeight(38.0))];
    phoneLabel.text = @"  设置手机号以保障您的账号安全";
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:phoneLabel];
    
    self.phoneNumber = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + DLMultipleHeight(38.0), DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"phone"] andPlaceHolder:@"输入您的手机号"];
    self.phoneNumber.textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumber.textfield.delegate = self;
    [self.view addSubview:self.phoneNumber];
    
    self.password = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + DLMultipleHeight(88.0), DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"write"] andPlaceHolder:@"输入您的登录密码"];
    self.password.textfield.delegate = self;
    self.password.textfield.keyboardType = UIKeyboardTypeAlphabet;
    [self.view addSubview:self.password];
    
}


//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (self.phoneNumber.textfield.text.length == 11 && self.password.textfield.text.length > 5) {
//        NSLog(@"长度为%@", self.phoneNumber.textfield.text);
//        self.label.userInteractionEnabled = YES;
//        self.label.textColor = RGBACOLOR(253, 185, 0, 1);
//    } else {
//        self.label.textColor = [UIColor lightGrayColor];
//        self.label.userInteractionEnabled = NO;
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumber.textfield) {
        if (range.location == 11) {
            return NO;
        }
    }
    if (textField == self.password.textfield) {
        if (range.location == 16) {
            return NO;
        }
    }
    
    if (self.phoneNumber.textfield.text.length == 11 && self.password.textfield.text.length >= 5) {
        NSLog(@"长度为%@", self.phoneNumber.textfield.text);
        self.label.userInteractionEnabled = YES;
        self.label.textColor = RGBACOLOR(253, 185, 0, 1);
    } else {
        self.label.textColor = [UIColor lightGrayColor];
        self.label.userInteractionEnabled = NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)nextController:(UITapGestureRecognizer *)tap
{
    [self.phoneNumber.textfield resignFirstResponder];
    [self.password.textfield resignFirstResponder];
    /*
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.phoneNumber.textfield.text];
    */
    /*
    if (!isMatch) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"手机号不正确啊少年" contentText:nil leftButtonTitle:@"修改" rightButtonTitle:nil];
        [alert show];
    } else {  */
        NSString *phoneStr = [NSString stringWithFormat:@"+86 %@", [self addPhoneNumberWithNumString:self.phoneNumber.textfield.text]];
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"我们将发送验证码到该手机" contentText:phoneStr leftButtonTitle:@"修改" rightButtonTitle:@"确认"];
    [alert show];
    
    alert.rightBlock = ^(){
        NSString *str2 = [NSString stringWithFormat:@"86"];
        [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumber.textfield.text
                                              zone:str2
                                            result:^(SMS_SDKError *error)
         {
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 LoginSinger *login = [LoginSinger shareState];
                 [login setPhone:self.phoneNumber.textfield.text];
                 [login setPassword:self.password.textfield.text];
                 
                 VerifiCodeController *ver = [[VerifiCodeController alloc]init];
                 [self.navigationController pushViewController:ver animated:YES];
                 
             }
             else
             {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"验证码发送失败", nil)
                                                                 message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];

        
    };
   /* }*/
//    alert.leftBlock = ^(){
//        [alert ];
//    };
}

- (NSString *)addPhoneNumberWithNumString:(NSString *)str
{
    NSMutableString *mutableStr = [NSMutableString stringWithString:str];
    [mutableStr insertString:@"-" atIndex:7];
    [mutableStr insertString:@"-" atIndex:3];
    return mutableStr;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
