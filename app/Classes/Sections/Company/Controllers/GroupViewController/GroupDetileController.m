//
//  GroupDetileController.m
//  app
//
//  Created by 申家 on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupDetileController.h"
#import "GroupCardModel.h"
#import "RestfulAPIRequestTool.h"


@interface GroupDetileController ()

@property (nonatomic, strong)GroupCardModel *model;

@end

@implementation GroupDetileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(238, 238, 240, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)setGroupModel:(GroupCardModel *)groupModel
{
    self.model = groupModel;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@4 forKey:@"interactionType"];
    [dic setObject:@10 forKey:@"limit"];
    [dic setObject:@"1" forKey:@"team"];
    [dic setObject:groupModel.groupId forKey:@"teamId"];
    
    [RestfulAPIRequestTool routeName:@"getInteraction" requestModel:dic useKeys:@[@"interactionType", @"limit", @"team", @"teamId"] success:^(id json) {
        NSLog(@"获取到的小队互动列表为   %@   ",  json);
    } failure:^(id errorJson) {
        NSLog(@"获取互动列表失败的原因为 %@", errorJson);
    }];
    
}








@end
