//
//  AmendGroupName.m
//  app
//
//  Created by 申家 on 15/9/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AmendGroupName.h"
#import "RestfulAPIRequestTool.h"
#import "GroupDetileModel.h"

@interface AmendGroupName ()

@end

@implementation AmendGroupName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.groupName.layer.masksToBounds = NO;
    self.groupName.layer.borderColor = [UIColor clearColor].CGColor;
    self.groupName.placeholder = self.detileModel.name;
    
    [self builtLabel];
    
    
}

- (void)builtLabel
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    label.text = @"保存";
    label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
        label.userInteractionEnabled = YES;
    [label addGestureRecognizer:labelTap];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];

}

- (void)nextController:(UITapGestureRecognizer *)tap
{
    
//    [RestfulAPIRequestTool routeName:@"editeGroupsInfos" requestModel:dic useKeys:@[@"groupId", @"name"] success:^(id json) {
//        NSLog(@"修改群信息成功 %@", json);
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadGroup" object:nil userInfo:nil];
//        
//    } failure:^(id errorJson) {
//        NSLog(@"失败 %@", errorJson);
//    }];
    
    [self.delegate sendNewName:self.groupName.text];
    [self.navigationController popViewControllerAnimated:YES];
    
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
