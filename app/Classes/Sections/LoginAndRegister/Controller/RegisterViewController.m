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
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import "DLNetworkRequest.h"
#import "UserDataTon.h"


@interface RegisterViewController ()<CardChooseViewDelegate, ArrangeState, DLNetworkRequestDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self builtInterface];
}

- (void)builtInterface
{
    CGFloat imageButtonWidth = [UIScreen mainScreen].bounds.size.width / 2.56;
    self.userPhotoImageView = [UIButton buttonWithType:UIButtonTypeSystem];
    self.userPhotoImageView.layer.masksToBounds = YES;
    self.userPhotoImageView.backgroundColor = DLSBackgroundColor;
    self.userPhotoImageView.layer.cornerRadius = imageButtonWidth / 2.0;  //弧度
    [self.userPhotoImageView addTarget:self action:@selector(userPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.userPhotoImageView];
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(imageButtonWidth, imageButtonWidth));
    }];
    [self builtTextfield];
    
    // 性别按钮
    self.manButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.manButton addTarget:self action:@selector(userSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.manButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [self.view addSubview:self.manButton];
    self.manButton.tag = 1;
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userPasswordTextField.mas_bottom).offset(20);
        make.right.mas_equalTo(self.view.mas_centerX).offset(-15);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
    }];
    
    
    self.womanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.womanButton addTarget:self action:@selector(userSexAction:) forControlEvents:UIControlEventTouchUpInside];
    self.womanButton.tag = 2;
    [self.womanButton setBackgroundImage:[UIImage imageNamed:@"gray-woman"] forState:UIControlStateNormal];
    [self.view addSubview:self.womanButton];
    
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userPasswordTextField.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_centerX).offset(15);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
    }];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    if (self.enterpriseNameTextField.userInteractionEnabled == YES) { //公司不可点, 为用户注册
        [self.loginButton addTarget:self action:@selector(companyLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.loginButton addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.loginButton setBackgroundColor:[UIColor orangeColor]];
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
    
//    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.enterpriseNameTextField.rac_textSignal, self.userPasswordTextField.rac_textSignal] reduce:^(NSString * UserNick, NSString *userPassword){
//        return @(UserNick.length > 6 && userPassword.length > 6);
//    }];  //长度统统大于6
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.enterpriseName) {
        
    }
}
- (void)builtEnterTextNameWithString:(NSString *)str
{
    if (!self.enterpriseNameTextField) {
        self.enterpriseNameTextField = [UITextField new];
    }
    self.enterpriseNameTextField.text = str;
    self.enterpriseNameTextField.userInteractionEnabled = NO;
}

- (void)builtTextfield
{
//    NSArray *labelNameArray = @[@"企业名称",@"公司邮箱",@"昵    称",@"密    码"];
    NSArray *labelNameArray = @[@"输入您的公司", @"输入您的密码"];
    
    if (!self.enterpriseNameTextField) {
        self.enterpriseNameTextField = [UITextField new];
    }
    self.userPasswordTextField = [UITextField new];
    
    NSArray *componentArray = @[self.enterpriseNameTextField, self.userPasswordTextField];
    
    NSInteger i  =0;
    for (NSString *str in labelNameArray) {
        
        UITextField *textfield = [componentArray objectAtIndex:i];
        textfield.placeholder = str;
        textfield.textAlignment = NSTextAlignmentCenter;

        [textfield placeholder];
        
        [self.view addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userPhotoImageView.mas_bottom).offset(20 + 40 * i);
            make.left.mas_equalTo(self.view.mas_left).offset(30);
            make.right.mas_equalTo(self.view.mas_right).offset(-30);
            make.height.mas_equalTo(30);
        }];
        
        
        UIView *view = [UIView new];
        [view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.8]];
        [textfield addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textfield.mas_bottom).offset(-.5);
            make.left.mas_equalTo(textfield.mas_left);
            make.right.mas_equalTo(textfield.mas_right);
            make.bottom.mas_equalTo(textfield.mas_bottom);
        }];
        i++;
    }
    self.userPasswordTextField.secureTextEntry = YES;
    self.userPasswordTextField.textColor = [UIColor colorWithWhite:.2 alpha:.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/// 用户注册
- (void)userLoginAction:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.companyCid forKey:@"cid"];
    [dic setObject:self.comMail forKey:@"email"];
    [dic setObject:self.userPasswordTextField.text forKey:@"password"];
    
    if (self.sex == UserSexMan) {
        [dic setObject:@"1" forKey:@"gender"];
    } else
    {
        [dic setObject:@"0" forKey:@"gender"];
    }
    
    if (!self.userImage) {
        self.userImage = [UIImage imageNamed:@"mzx.jpg"];
    }
        NSMutableDictionary *smDic = [NSMutableDictionary dictionary];
        NSData *data = UIImagePNGRepresentation(self.userImage);
        [smDic setObject:data forKey:@"data"];
        [smDic setObject:@"photo" forKey:@"name"];
        NSArray *array = [NSArray arrayWithObject:smDic];
        [dic setObject:array forKey:@"imageArray"];
    
    DLNetworkRequest *request = [[DLNetworkRequest alloc]init];
    [request dlRouteNetWorkWithNetName:@"Register" andRequestType:@"POST" paramter:dic];
    request.delegate = self;
    
}

//公司注册
- (void)companyLoginAction:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.enterpriseNameTextField.text forKey:@"name"];
    [dic setObject:self.comMail forKey:@"email"];
    [dic setObject:self.userPasswordTextField.text forKey:@"password"];
    
    
    if (self.sex == UserSexMan) {
        [dic setObject:@"1" forKey:@"gender"];
    } else
    {
        [dic setObject:@"0" forKey:@"gender"];
    }
    if (!self.userImage) {
        self.userImage = [UIImage imageNamed:@"mzx.jpg"];
    }
    NSMutableDictionary *smDic = [NSMutableDictionary dictionary];
    NSData *data = UIImagePNGRepresentation(self.userImage);
    [smDic setObject:data forKey:@"data"];
    [smDic setObject:@"photo" forKey:@"name"];
    NSArray *array = [NSArray arrayWithObject:smDic];
    [dic setObject:array forKey:@"imageArray"];
    
    DLNetworkRequest *request = [[DLNetworkRequest alloc]init];
    [request dlRouteNetWorkWithNetName:@"companyQuickRegister" andRequestType:@"POST" paramter:dic];
    request.delegate = self;
    
}



- (void)sendParsingWithDictionary:(NSDictionary *)dictionary
{
    UserDataTon *user = [UserDataTon shareState];
    
    NSLog(@"注册成功 获得的数据为%@", dictionary);
    user.company_uid = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"uid"]];
    
    //注册通知
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeRootViewController" object:nil userInfo:dic];
    
    
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

- (void)arrangeStartWithArray:(NSMutableArray *)array
{
    [self.userPhotoImageView setBackgroundImage:[array lastObject] forState:UIControlStateNormal];
    self.userImage = [UIImage new];
    self.userImage = [array lastObject];
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
            choose.allowSelectNum = 1;  choose.delegate = self;
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

