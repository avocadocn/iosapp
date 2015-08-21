//
//  FillInformationCon.m
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FillInformationCon.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "DNImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "AccountAndPassword.h"
#import <ReactiveCocoa.h>
#import "LoginSinger.h"

@interface FillInformationCon ()<DNImagePickerControllerDelegate, UITextFieldDelegate>

@end

@implementation FillInformationCon

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写资料";
    
    self.view.backgroundColor = DLSBackgroundColor;
    [self builtInterface];
}

- (void)builtInterface
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    label.text = @"下一步";
    label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
//    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:labelTap];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    
    
    self.userPhoto = [UIImageView new];
    self.userPhoto.image = [UIImage imageNamed:@"boy"];  //默认男生是背景图片
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.userInteractionEnabled = YES;
    self.userPhoto.layer.cornerRadius = DLMultipleWidth(75.0);
    UITapGestureRecognizer *choosePhotoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhotoAction:)];
    [self.userPhoto addGestureRecognizer:choosePhotoTap];
    
    [self.view addSubview:self.userPhoto];
    
    [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64.0 + DLMultipleHeight(30.0));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(150.0), DLMultipleWidth(150.0)));
    }];
    
    self.userName = [LabelView new];
    self.userName.label.text = @"昵称";
    [self.userName setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.userName];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userPhoto.mas_bottom).offset(DLMultipleHeight(30.0));
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(DLMultipleHeight(50.0));
    }];
    
    self.nameTextField = [UITextField new];
    self.nameTextField.font = [UIFont systemFontOfSize:14];
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    [self.nameTextField.rac_textSignal subscribeNext:^(NSString *textStr) {
        if (textStr.length >= 3) {
            label.userInteractionEnabled = YES;
            label.textColor = RGBACOLOR(253, 185, 0, 1);
        }
    }];
    
    self.nameTextField.delegate = self;
    [self.userName addSubview:self.nameTextField];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userName.mas_left);
        make.top.mas_equalTo(self.userName.mas_top);
        make.bottom.mas_equalTo(self.userName.mas_bottom);
        make.right.mas_equalTo(self.userName.mas_right);
    }];
    
    UIView *lianview =[UIView new];
    [lianview setBackgroundColor:[UIColor colorWithWhite:.75 alpha:1]];
    [self.view addSubview:lianview];
    
    [lianview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.userName.mas_bottom);
        make.left.mas_equalTo(self.userName.mas_left).offset(15);
        make.right.mas_equalTo(self.userName.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    self.userGender = [LabelView new];
    self.userGender.label.text = @"性别";
    [self.view addSubview:self.userGender];
    
    [self.userGender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.left.mas_equalTo(self.userName.mas_left);
        make.right.mas_equalTo(self.userName.mas_right);
        make.height.mas_equalTo(DLMultipleHeight(50.0));
    }];
    
    // 性别按钮
    self.manButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.manButton addTarget:self action:@selector(userSexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.manButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [self.userGender addSubview:self.manButton];
    self.manButton.tag = 1;
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userGender.mas_top);
        make.right.mas_equalTo(self.userGender.mas_centerX).offset(-15);
        make.height.mas_equalTo(DLMultipleWidth(45.0));
        make.width.mas_equalTo(DLMultipleWidth(45.0));
    }];
    
    
    self.womanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.womanButton addTarget:self action:@selector(userSexAction:) forControlEvents:UIControlEventTouchUpInside];
    self.womanButton.tag = 2;
    [self.womanButton setBackgroundImage:[UIImage imageNamed:@"gray-woman"] forState:UIControlStateNormal];
    [self.userGender addSubview:self.womanButton];
    
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userGender);
        make.left.mas_equalTo(self.userGender.mas_centerX).offset(15);
        make.height.mas_equalTo(DLMultipleWidth(45.0));
        make.width.mas_equalTo(DLMultipleWidth(45.0));
    }];
    
    UIView *lineView2 = [UIView new];
    [lineView2 setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
    [self.userGender addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userGender.mas_top).offset(DLMultipleHeight(6.0));
        make.bottom.mas_equalTo(self.userGender.mas_bottom).offset(DLMultipleHeight(-6.0));
        make.width.mas_equalTo(.5);
        make.centerX.mas_equalTo(self.userGender.mas_centerX);
    }];
    
}

- (void)userSexAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:   //男性
            
            self.sex = EnumUserSexMan;  // 男
            [self.manButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
            [self.womanButton setBackgroundImage:[UIImage imageNamed:@"gray-woman"] forState:UIControlStateNormal];
            
            if ([self.userPhoto.image isEqual:[UIImage imageNamed:@"gril"]]) {
                self.userPhoto.image = [UIImage imageNamed:@"boy"];
            }
            break;
            
        case 2:  //女性
            self.sex = EnumUserSexWoman;
            [self.manButton setBackgroundImage:[UIImage imageNamed:@"gray-man"] forState:UIControlStateNormal];
            [self.womanButton setBackgroundImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
            if ([self.userPhoto.image isEqual:[UIImage imageNamed:@"boy"]]) {
                self.userPhoto.image = [UIImage imageNamed:@"gril"];
            }
            
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)choosePhotoAction:(UITapGestureRecognizer *)tap{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    DNAsset *dnasser = [imageAssets firstObject];
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library assetForURL:dnasser.url resultBlock:^(ALAsset *asset) {
        self.userPhoto.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 9) {
        return NO;
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
- (void)nextController:(UITapGestureRecognizer *)tap
{
    LoginSinger *singer = [LoginSinger shareState];
    
    [singer setName:self.nameTextField.text];
    if (self.sex == EnumUserSexMan) {
        [singer setGender:@1];
    } else
    {
        [singer setGender:@2];
    }
    singer.photo = [NSMutableArray arrayWithObject:self.userPhoto.image];
    
    [self.nameTextField resignFirstResponder];
    AccountAndPassword *acc= [[AccountAndPassword alloc]init];
    [self.navigationController pushViewController:acc animated:YES];
    
}


@end
