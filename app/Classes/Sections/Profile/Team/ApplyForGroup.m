//
//  ApplyForGroup.m
//  app
//
//  Created by 申家 on 15/9/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//


#import "UIImageView+DLGetWebImage.h"
#import "Person.h"
#import "RestfulAPIRequestTool.h"
#import "FMDBSQLiteManager.h"
#import "ApplyForGroup.h"
#import "GroupDetileModel.h"
#import "AttentionViewCell.h"


@interface ApplyForGroup ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *myTableView;
@end
static NSString *tableId = @"AttentionViewCell";
@implementation ApplyForGroup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请加入";
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    [self.myTableView registerClass:[AttentionViewCell class] forCellReuseIdentifier:tableId];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    self.myTableView.tableFooterView = view;
    
    [self.view addSubview:self.myTableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableId forIndexPath:indexPath];
    NSDictionary *dic = [self.detileModel.applyMember objectAtIndex:indexPath.row];
    Person *per = [[FMDBSQLiteManager shareSQLiteManager]selectPersonWithUserId:[dic objectForKey:@"_id"]];
    
//    cell.textLabel.text = per.name;
    cell.AttentionName.text = per.name;
    [cell.AttentionPhoto dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:cell.AttentionPhoto.size];
    cell.joinButton.tag = indexPath.row + 1;
    [cell.joinButton addTarget:self action:@selector(joinAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)joinAction:(UIButton *)sender
{
    
    NSLog(@"邀请");
    NSDictionary *temp = self.detileModel.applyMember[sender.tag - 1];
    NSString *str = [temp objectForKey:@"_id"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.detileModel.ID, str, @1] forKeys:@[@"groupId", @"userId", @"accept"]];
    
    [RestfulAPIRequestTool routeName:@"detailGroupsApplicants" requestModel:dic useKeys:@[@"groupId", @"userId", @"accept"] success:^(id json) {
        NSLog(@"加入成功  %@", json);
        
        NSIndexPath *pa = [NSIndexPath indexPathForRow:(sender.tag - 1) inSection:0];
        
        [self.detileModel.applyMember removeObjectAtIndex:pa.row];
        [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pa] withRowAnimation:UITableViewRowAnimationFade];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMemberTableView" object:nil userInfo:dic];
        
    } failure:^(id errorJson) {
        NSLog(@"加入失败   %@", errorJson);
    }];
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detileModel.applyMember.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DLMultipleHeight(67.0);
}

- (void)setGroupId:(NSString *)groupId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:groupId forKey:@"groupId"];
    [dic setObject:@"1" forKey:@"allInfo"];
    
    [RestfulAPIRequestTool routeName:@"getGroupInfor" requestModel:dic useKeys:@[@"groupId", @"allInfo"] success:^(id json) {
        NSLog(@"获取到的群组信息为 %@", json);
        NSDictionary *group = [json objectForKey:@"group"];
        
        self.detileModel = [[GroupDetileModel alloc]init];
        [self.detileModel setValuesForKeysWithDictionary:group];
        
        [self.myTableView reloadData];
    } failure:^(id errorJson) {
        NSLog(@"获取失败群组信息为 %@", errorJson);
    }];
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
