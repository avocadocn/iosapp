//
//  PublishSeekHelp.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PublishSeekHelp.h"
#import "ChoosePhotoController.h"
#import "EMTextView.h"
#import <Masonry.h>

//#import "UITextView+PlaceHolder.h"
@interface PublishSeekHelp ()<ArrangeState>

@end

@implementation PublishSeekHelp


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationItem];
    [self setSeekContent];
}

- (void)setSeekContent
{
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLScreenHeight)];
    [self.view addSubview:bigView];
/*
    self.seekHelpContent = [[UITextView alloc]initWithFrame:CGRectMake(0,  100 + 64, DLScreenWidth, 120)];
    self.seekHelpContent.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 10);
//    [self.seekHelpContent placeHolderWithString:@"请输入求助内容"];
    self.seekHelpContent.font = [UIFont systemFontOfSize:17];
    [self.seekHelpContent setBackgroundColor:[UIColor greenColor]];
    self.seekHelpContent.textAlignment = NSTextAlignmentJustified;
    self.seekHelpContent.contentOffset = CGPointMake(0, 0);
    self.seekHelpContent.scrollEnabled = NO;
    [bigView addSubview:self.seekHelpContent];
    
    */
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(200.0))];
    
    textField.placeholder = @"请输入求助内容";
    [textField placeholder];
    [bigView addSubview:textField];
    
    
    self.selectPhoto = [UIImageView new];
    self.selectPhoto.userInteractionEnabled = YES;
    //    self.selectPhoto.contentMode = UIViewContentModeCenter;
    self.selectPhoto.image = [UIImage imageNamed:@"image"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhotoAction:)];
    [self.selectPhoto addGestureRecognizer:tap];
    [bigView addSubview:self.selectPhoto];
    
    [self.selectPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textField.mas_bottom).offset(DLMultipleHeight(50.0));
        make.left.mas_equalTo(bigView.mas_left).offset(DLMultipleWidth(15.0));
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(50.0), DLMultipleWidth(50.0)));
    }];
    
    UIView *lastLineView = [UIView new];
    [lastLineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [bigView addSubview:lastLineView];
    
    [lastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.selectPhoto.mas_top);
        make.left.mas_equalTo(self.selectPhoto.mas_left);
        make.right.mas_equalTo(bigView.mas_right).offset(-15);
        make.height.mas_equalTo(.5);
    }];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [bigView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectPhoto.mas_bottom);
        make.left.mas_equalTo(self.selectPhoto.mas_left);
        make.right.mas_equalTo(bigView.mas_right).offset(-15);
        make.height.mas_equalTo(.5);
    }];
    
}

- (void)selectPhotoAction:(UITapGestureRecognizer *)tap
{
    ChoosePhotoController *choose = [ChoosePhotoController shareStateOfController];
    choose.allowSelectNum = 1;
    choose.delegate = self;
    [self.navigationController pushViewController:choose animated:YES];
    
}

- (void)arrangeStartWithArray:(NSMutableArray *)array
{
    self.selectPhoto.image = [array lastObject];
}


- (void)setNavigationItem
{
    self.title = @"发布求助";
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 0, 60, 20);
    [cancelButton setTitleColor:[UIColor colorWithWhite:.5 alpha:.5] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    publishButton.frame = CGRectMake(0, 0, 60, 20);
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishButton];
    
}

- (void)publishAction:(UIButton *)sender
{
    NSLog(@"发布");
}

- (void)cancelButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
