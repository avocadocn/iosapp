//
//  InteractionView.m
//  app
//
//  Created by burring on 15/9/8.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "InteractionView.h"
#import "MessageTableViewCell.h"
#import "AccountTool.h"
#import "Account.h"
#import "RestfulAPIRequestTool.h"
#import "getIntroModel.h"
#import "InformationModel.h"

@interface InteractionView ()
@property  (nonatomic, strong)NSMutableArray *modelArray;

@end

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
        [self reloadLocalData];
    }
    return self;
}
- (void)netWorkRequest {
    Account *account = [AccountTool account];
    getIntroModel *model = [[getIntroModel alloc] init];
    [model setUserId:account.ID];
    [model setNoticeType:@"interaction"];
    [RestfulAPIRequestTool routeName:@"getPersonalInteractionList" requestModel:model useKeys:@[@"content"] success:^(id json) {
        NSLog(@"获取互动列表成功 %@",json);
        
        for (NSDictionary *dic in json) {
            InformationModel *infor = [[InformationModel alloc]init];
            [infor setValuesForKeysWithDictionary:dic];
            [infor save:@"interaction"];
        }
        
        
    } failure:^(id errorJson) {
        NSLog(@"获取互动列表失败 %@",[errorJson objectForKey:@"msg"]);
    }];
    
}

- (void)reloadLocalData
{
    Account *acc = [AccountTool account];
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@-interaction", acc.ID, DLLibraryPath];
    NSArray *array = [manger contentsOfDirectoryAtPath:path error:nil];
    NSLog(@"本地的 interaction 文件为 %@", array);
    self.modelArray = [NSMutableArray array];
    for (NSString *str in array) {
        InformationModel *model = [[InformationModel alloc]initWithInforString:@"interaction" andIDString:str];
        [self.modelArray addObject:model];
    }
    [self.tableView reloadData];
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
    return self.modelArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
//    cell.titleLabel.text = @"花花";
//    cell.contentLabel.text = @"小帅哥快点来玩啊、、";
    cell.model = self.modelArray[indexPath.row];
    return cell;
}
@end
