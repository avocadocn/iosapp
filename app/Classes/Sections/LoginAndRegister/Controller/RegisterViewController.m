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
#import <AFNetworking.h>
#import "DLNetworkRequest.h"

@interface RegisterViewController ()<CardChooseViewDelegate, ArrangeState>

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
    [self.loginButton addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
//    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.enterpriseNameTextField.rac_textSignal, self.companyMailTextField.rac_textSignal, self.userNickNameTextField.rac_textSignal, self.userPasswordTextField.rac_textSignal] reduce:^(NSString *enterpriseName, NSString * companyMail, NSString * UserNick, NSString *userPassword){
//        return @(enterpriseName.length > 6 && companyMail.length > 6&& UserNick.length > 6 && userPassword.length > 6);
//    }];  //长度统统大于6

    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.userNickNameTextField.rac_textSignal, self.userPasswordTextField.rac_textSignal] reduce:^(NSString * UserNick, NSString *userPassword){
        return @(UserNick.length > 6 && userPassword.length > 6);
    }];  //长度统统大于6
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)builtTextfield
{
//    NSArray *labelNameArray = @[@"企业名称",@"公司邮箱",@"昵    称",@"密    码"];
    NSArray *labelNameArray = @[@"昵   称", @"密   码"];
    
//    self.enterpriseNameTextField = [UITextField new];
//    self.companyMailTextField = [UITextField new];
    self.userNickNameTextField = [UITextField new];
    self.userPasswordTextField = [UITextField new];
//    NSArray *componentArray = @[self.enterpriseNameTextField, self.companyMailTextField, self.userNickNameTextField, self.userPasswordTextField];
    
    NSArray *componentArray = @[self.userNickNameTextField, self.userPasswordTextField];
    
//    NSInteger numOfHeight = 25;
//    
//    NSString *tempStr = [labelNameArray objectAtIndex:1];
//    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
////    CGRect rect = [tempStr boundingRectWithSize:CGSizeMake(12121212, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    NSInteger i  =0;
    for (NSString *str in labelNameArray) {
        
        UITextField *textfield = [componentArray objectAtIndex:i];
        textfield.placeholder = str;
        textfield.textAlignment = NSTextAlignmentCenter;

        [textfield placeholder];
//        [textfield.rac_textSignal subscribeNext:^(NSString * x) {
//            if (x.length > 0) {
//                textfield.textAlignment = NSTextAlignmentCenter;
//            }
//        }];
        
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


- (void)userLoginAction:(id)sender {
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *str = @"http://192.168.2.110:3002/v2_0/users";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"53aa6fc011fd597b3e1be250" forKey:@"cid"];
    [dic setObject:self.comMail forKey:@"email"];
    [dic setObject:self.userNickNameTextField.text forKey:@"nickname"];
    [dic setObject:self.userPasswordTextField.text forKey:@"password"];
    
    if (self.sex == UserSexMan) {
        [dic setObject:@"1" forKey:@"gender"];
    } else
    {
        [dic setObject:@"0" forKey:@"gender"];
    }
    
//    [manger POST:str parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSData *data = [NSData dataWithData:responseObject];
//        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"请求的数据为%@", dataDic);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"请求数据失败, 原因为 %@", error);
//    }];
    
    DLNetworkRequest *requset = [[DLNetworkRequest alloc]init];
    NSDictionary *datadic = [requset dlPOSTNetRequestWithString:str andParameters:dic];
    NSLog(@"请求到的网络数据为 %@", datadic);
    
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

