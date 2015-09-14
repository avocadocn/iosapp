//
//  DetailActivityShowController.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//  活动详情界面

#import "DetailActivityShowController.h"
#import "DetailActivityShowView.h"
#import "interaction.h"

@interface DetailActivityShowController ()

@end

@implementation DetailActivityShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self.view setBackgroundColor:RGB(235.0, 234.0, 236.0)];  
    DetailActivityShowView *detailView = [[DetailActivityShowView alloc]initWithModel:self.model];
    [self.view addSubview:detailView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
