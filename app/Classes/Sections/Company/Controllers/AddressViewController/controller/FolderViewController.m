//
//  FolderViewController.m
//  app
//
//  Created by 申家 on 15/8/4.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FolderViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "CuntomFolderView.h"

static NSInteger num = 0;

@interface FolderViewController ()

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DLSBackgroundColor;
    self.title = @"个人资料";
    
    num = 0;
    [self builtTitleView];  // 设置资料照片
    [self builtInformationView];  //设置资料 label
    
}

- (void)builtTitleView // 照片和选择照片
{
    CGFloat width = DLScreenWidth / (375.0 / 150.0);
    self.folderPhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake((DLScreenWidth - width) / 2, 75, width, width)];
    self.folderPhotoImage.image = [UIImage imageNamed:@"1"];
    self.folderPhotoImage.layer.masksToBounds = YES;
    self.folderPhotoImage.layer.cornerRadius = width / 2.0;
    [self.view addSubview:self.folderPhotoImage];
    
}

- (void)editFolder  //用户看自己的资料, 允许被编辑
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 30);
    [button setTitle:@"编辑" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

- (void)editButtonAction:(UIButton *)sender
{
    for (CuntomFolderView *view in self.componentArray) {
        if (self.buttonState == EnumOfEditButtonNo) { //未编辑
            view.informationTextField.userInteractionEnabled = YES;
        }
        else
        {
            view.informationTextField.userInteractionEnabled = NO;
        }
    }
    if (self.buttonState == EnumOfEditButtonNo) {
        self.buttonState = EnumOfEditButtonYes;
    } else { //写编辑完成后的网络请求
        
        self.buttonState = EnumOfEditButtonNo;//编辑完成
    }
    
}

- (void)builtInformationView
{
    self.nickName = [CuntomFolderView new];
    self.synopsis = [CuntomFolderView new];
    self.realName = [CuntomFolderView new];
    self.gender = [CuntomFolderView new];
    self.brithday = [CuntomFolderView new];
    self.department = [CuntomFolderView new];
    self.phoneNumber = [CuntomFolderView new];
    self.constellation = [CuntomFolderView new];
    NSArray *array = @[self.nickName, self.synopsis, self.realName, self.gender, self.brithday, self.department, self.phoneNumber, self.constellation];
    NSArray *labelName = @[@"昵       称", @"个人简介", @"真实姓名", @"性       别", @"生       日", @"部       门", @"手机号码", @"星       座"];
    
    UIScrollView *scroll = [UIScrollView new];
    scroll.bounces = NO;
    scroll.showsVerticalScrollIndicator = FALSE;
    scroll.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scroll];
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.folderPhotoImage.mas_bottom).offset(25);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    for (CuntomFolderView *view in array) {
        view.frame = CGRectMake(0, num * 45, DLScreenWidth, 45);
        view.titleLabel.text = [labelName objectAtIndex:num];
        [view setBackgroundColor:[UIColor whiteColor]];
        [scroll addSubview:view];
        num ++;
    }
    scroll.contentSize = CGSizeMake(0, 45 * num);
    
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
