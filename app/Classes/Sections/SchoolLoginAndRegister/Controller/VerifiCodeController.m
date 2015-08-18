//
//  VerifiCodeController.m
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VerifiCodeController.h"
#import <Masonry.h>
#import "PasswordView.h"

@interface VerifiCodeController ()

@end

@implementation VerifiCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DLSBackgroundColor;
    self.title = @"输入验证码";
    
    [self builtInterface];
}

- (void)builtInterface
{
    self.phoneNumber = [UILabel new];
    self.phoneNumber.textAlignment = NSTextAlignmentCenter;
    self.phoneNumber.text = @"132 3804 1502";
    self.phoneNumber.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.phoneNumber];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64 + DLMultipleHeight(20.0));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth, DLMultipleHeight(23.01)));
    }];
    
    UILabel *tempLabel = [UILabel new];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor colorWithWhite:.7 alpha:1];
    tempLabel.font = [UIFont systemFontOfSize:11];
    tempLabel.text = @"请输入验证码";
    [self.view addSubview:tempLabel];
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumber.mas_bottom).offset(DLMultipleHeight(5.0));
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth, 15));
        make.left.mas_equalTo(self.view.mas_left);
    }];
    
    PasswordView *password = [[PasswordView alloc]initWithFrame:CGRectMake(DLMultipleWidth(52.0), 64 + DLMultipleHeight(77.0), DLMultipleWidth(46.0) * 6, DLMultipleHeight(54.0)) textFieldNum:6.0];
    [self.view addSubview:password];
    
    
    self.requestAgain = [UILabel new];
    NSString * str = @"重新获取验证码( 60 )";
    CGRect rect = [str boundingRectWithSize:CGSizeMake(10000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.5]} context:nil];
    
    self.requestAgain.layer.masksToBounds = YES;
    self.requestAgain.backgroundColor = [UIColor colorWithWhite:.85 alpha:1];
    self.requestAgain.textColor = [UIColor colorWithWhite:.7 alpha:1];
    self.requestAgain.text = str;
    self.requestAgain.textAlignment = NSTextAlignmentCenter;
    self.requestAgain.font = [UIFont systemFontOfSize:13.5];
    self.requestAgain.layer.cornerRadius = DLMultipleHeight(15.0);
    [self.view addSubview:self.requestAgain];
    [self.requestAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(password.mas_bottom).offset(DLMultipleHeight(15.0));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake((rect.size.width + DLMultipleWidth(44.0)), DLMultipleHeight(30.0)));
    }];
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    UILabel *checkLabel = [UILabel new];
    checkLabel.text = @"验证码短信已发送至您的手机,注意查收哦~";
    checkLabel.font = [UIFont systemFontOfSize:11];
    checkLabel.textColor = [UIColor colorWithWhite:.7 alpha:1];
    checkLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:checkLabel];
    [checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.requestAgain.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(DLMultipleHeight(20.0));
    }];
    
}

- (void)timerAction:(id)sender
{
    NSString *str = self.requestAgain.text;
    NSArray *array = [str componentsSeparatedByString:@"( "];
    
    NSString *secStr = [array lastObject];
    NSArray *second = [secStr componentsSeparatedByString:@" )"];
    NSString *numStr = [second firstObject];
    
    NSInteger num = [numStr integerValue];
    
    if (num != 1) {
        self.requestAgain.text = [NSString stringWithFormat:@"重新获取验证码( %ld )", --num];
    }
    else {
        self.requestAgain.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:214.0/255.0 blue:0/255.0 alpha:1];
        self.requestAgain.text = @"重新获取验证码";
        self.requestAgain.textColor = [UIColor whiteColor];
        [self.myTimer invalidate];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestAgainTap:)];
        self.requestAgain.userInteractionEnabled = YES;
        [self.requestAgain addGestureRecognizer:tap];
    }
    
}

- (void)requestAgainTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"重新获取");
    self.requestAgain.userInteractionEnabled = NO;

    NSString * str = @"重新获取验证码( 60 )";
    self.requestAgain.backgroundColor = [UIColor colorWithWhite:.85 alpha:1];
    self.requestAgain.textColor = [UIColor colorWithWhite:.7 alpha:1];
    self.requestAgain.text = str;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
