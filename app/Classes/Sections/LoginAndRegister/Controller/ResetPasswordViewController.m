//
//  ResetPasswordViewController.m
//  app
//
//  Created by burring on 15/9/9.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "RestfulAPIRequestTool.h"
#import <SMS_SDK/SMS_SDK.h>
#import "LoginSinger.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UITextField *newsPassword;
@property (strong, nonatomic) IBOutlet UILabel *clickLabel;
@property (strong, nonatomic) UILabel *confirmationLabel;

@property (nonatomic, strong)NSTimer *myTimer;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self builtInterface];
    self.clickLabel.text = @"重新获取验证码( 60 )";
    self.clickLabel.textColor = [UIColor blackColor];
    self.passWord.delegate = self;
    self.newsPassword.delegate = self;
    self.newsPassword.secureTextEntry = YES;
    self.title = @"重置密码";
    
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActions:) userInfo:nil repeats:YES];
}

- (void)timerActions:(id)sender
{
    NSString *str = self.clickLabel.text;
    NSArray *array = [str componentsSeparatedByString:@"( "];
    
    NSString *secStr = [array lastObject];
    NSArray *second = [secStr componentsSeparatedByString:@" )"];
    NSString *numStr = [second firstObject];
    
    NSInteger num = [numStr integerValue];
    
    if (num != 1) {
        self.clickLabel.text = [NSString stringWithFormat:@"重新获取验证码( %ld )", (long)--num];
    }
    else {
        self.clickLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:0/255.0 alpha:1];
        self.clickLabel.text = @"重新获取验证码";
        self.clickLabel.textColor = [UIColor whiteColor];
        [self.myTimer invalidate];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestsAgainTap:)];
        self.clickLabel.userInteractionEnabled = YES;
        [self.clickLabel addGestureRecognizer:tap];
    }
    
}

- (void)requestsAgainTap:(UITapGestureRecognizer *)tap {
    UIAlertView *alext = [[UIAlertView alloc]initWithTitle:@"重新发送验证码" message:@"" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    alext.delegate = self;
    [alext show];

}

- (void)builtInterface
{
    self.confirmationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    self.confirmationLabel.text = @"确认";
    self.confirmationLabel.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(determineAction:)];
    [self.confirmationLabel addGestureRecognizer:labelTap];
    self.confirmationLabel.font = [UIFont systemFontOfSize:15];
    self.confirmationLabel.textColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.confirmationLabel];
}



- (void)determineAction:(UITapGestureRecognizer *)sender
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.passWord.text forKey:@"code"];
    [dic setObject:@"13238041502" forKey:@"phone"];
    [dic setObject:self.newsPassword.text forKey:@"password"];
    [RestfulAPIRequestTool routeName:@"motifyPassword" requestModel:dic useKeys:@[@"phone", @"password", @"code"] success:^(id json) {
        
        NSLog(@"你的密码修改成功 %@", json);
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
}
#pragma UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    LoginSinger *singer = [LoginSinger shareState];
    switch (buttonIndex) {
        case 1:{
            [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumber
                                                  zone:@"86"
                                                result:^(SMS_SDKError *error)
             {
                 if (!error)
                 {
                     NSLog(@"验证码发送成功");
                     self.clickLabel.userInteractionEnabled = NO;
                     
                     NSString * str = @"重新获取验证码( 60 )";
                     self.clickLabel.backgroundColor = [UIColor colorWithWhite:.85 alpha:1];
                     self.clickLabel.textColor = [UIColor colorWithWhite:.7 alpha:1];
                     self.clickLabel.text = str;
                     self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActions:) userInfo:nil repeats:YES];
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
            
        }
        default:
            break;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.passWord.text.length == 4 && self.newsPassword.text.length >= 6) {
        self.confirmationLabel.userInteractionEnabled = YES;
        self.confirmationLabel.textColor = RGBACOLOR(253, 185, 0, 1);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
