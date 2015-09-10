//
//  InteractionView.m
//  app
//
//  Created by burring on 15/9/8.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "InteractionView.h"
#import "MessageTableViewCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "getIntroModel.h"
#import "RestfulAPIRequestTool.h"
@implementation InteractionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
        [self netWorkRequest];
    }
    return self;
}
- (void)netWorkRequest {
    Account *account = [AccountTool account];
    getIntroModel *model = [[getIntroModel alloc] init];
    [model setUserId:account.ID];
    [model setNoticeType:@"interaction"];
    [RestfulAPIRequestTool routeName:@"getPersonalNotificationsList" requestModel:model useKeys:@[@"noticeType",@"userId"] success:^(id json) {
        NSLog(@"互动获取成功 %@",json);
    } failure:^(id errorJson) {
        NSLog(@"互动获取失败 %@",[errorJson objectForKey:@"msg"]);
    }];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -35, DLScreenWidth, DLScreenHeight + 35) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:_tableView];
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = @"花花";
    cell.contentLabel.text = @"小帅哥快点来玩啊、、";
    return cell;
}
@end
