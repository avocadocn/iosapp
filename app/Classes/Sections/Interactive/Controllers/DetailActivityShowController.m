//
//  DetailActivityShowController.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//  活动详情界面
#import "RestfulAPIRequestTool.h"
#import "DetailActivityShowController.h"
#import "DetailActivityShowView.h"
#import "interaction.h"

@interface DetailActivityShowController ()<DetailActivityShowViewDelegate>

@end

@implementation DetailActivityShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self.view setBackgroundColor:RGB(235.0, 234.0, 236.0)];
    if (self.model) {
        DetailActivityShowView *detailView = [[DetailActivityShowView alloc]initWithModel:self.model andButtonState:self.quitState];
        detailView.delegate = self;
        [self.view addSubview:detailView];
        
    }
}

- (void)DetailActivityShowViewDismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInteraction:(NSString *)interaction
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:interaction forKey:@"interactionId"];
    [dic setObject:self.interactionType forKey:@"interactionType"];
    
    [RestfulAPIRequestTool routeName:@"getInterDetails" requestModel:dic useKeys:@[@"interactionType", @"interactionId"] success:^(id json) {
        NSLog(@" 获得的求助详情微 %@", json);
        self.model = [[Interaction alloc]init];
        [self.model setValuesForKeysWithDictionary:json];
        
        DetailActivityShowView *detailView = [[DetailActivityShowView alloc]initWithModel:self.model andButtonState:NO];
        [self.view addSubview:detailView];

        
    } failure:^(id errorJson) {
        NSLog(@"获取求朱详情失败 %@",errorJson);
    }];
}


@end
