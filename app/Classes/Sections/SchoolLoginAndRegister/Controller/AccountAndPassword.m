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




@interface AccountAndPassword ()

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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    label.text = @"下一步";
    label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
//    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:labelTap];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLMultipleHeight(38.0))];
    phoneLabel.text = @"  设置手机号以保障您的账号安全";
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:phoneLabel];
    
    self.phoneNumber = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + DLMultipleHeight(38.0), DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"phone"] andPlaceHolder:@"输入您的手机号"];
    self.phoneNumber.textfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneNumber];
    
    self.password = [[ImageHolderView alloc]initWithFrame:CGRectMake(0, 64 + DLMultipleHeight(88.0), DLScreenWidth, DLMultipleHeight(50.0)) andImage:[UIImage imageNamed:@"write"] andPlaceHolder:@"输入您的登录密码"];
    [self.view addSubview:self.password];
    
    RAC(label, userInteractionEnabled) = [RACSignal combineLatest:@[self.phoneNumber.textfield.rac_textSignal, self.password.textfield.rac_textSignal] reduce:^(NSString *a, NSString *b){
        NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
        label.textColor = [UIColor lightGrayColor];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isMatch = [pred evaluateWithObject:self.phoneNumber.textfield.text];
        
        if (b.length > 6 && (a.length == 10 || a.length == 12 || a.length == 11)) {
            label.textColor = RGBACOLOR(253, 185, 0, 1);
        }
        return @(a.length == 11 && b.length > 6);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)nextController:(UITapGestureRecognizer *)tap
{
    [self.phoneNumber.textfield resignFirstResponder];
    [self.password.textfield resignFirstResponder];
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.phoneNumber.textfield.text];
    
    if (!isMatch) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"手机号不正确啊少年" contentText:nil leftButtonTitle:@"修改" rightButtonTitle:nil];
        [alert show];
    } else {
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"我们将发送验证码到该手机" contentText:@"+86 400-803-5055" leftButtonTitle:@"修改" rightButtonTitle:@"确认"];
    [alert show];
    
    alert.rightBlock = ^(){
        VerifiCodeController *ver = [[VerifiCodeController alloc]init];
        [self.navigationController pushViewController:ver animated:YES];
    };
    }
//    alert.leftBlock = ^(){
//        [alert ];
//    };
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
