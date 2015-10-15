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
#import "VoteTableController.h"
#import "DetailActivityShowController.h"
#import "HelpTableViewController.h"
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
    NSString *path = [NSString stringWithFormat:@"%@/%@-interaction",  DLLibraryPath, acc.ID];
    NSArray *array = [manger contentsOfDirectoryAtPath:path error:nil];
    NSLog(@"本地的 interaction 文件为 %@", array);
    self.modelArray = [NSMutableArray array];
    for (NSString *str in array) {
        InformationModel *model = [[InformationModel alloc]initWithInforString:@"interaction" andIDString:str];
        [self.modelArray addObject:model];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //  1: 活动有人参加了、投票有人参与了、求助有人回答了
    //  2: 被邀请参加活动、投票、求助
    //  3: 求助的回答被采纳了
    //  4: 评论有回复
    //  5: 评论被赞了
    //  6: 被邀请进小队
    //  7: 入群申请被通过
    //  8: XX申请入X群，待处理(群主)
    //  9: XX申请入X群，已被其它管理员处理

    InformationModel *model = self.modelArray[indexPath.row];
    NSLog(@"这个通知的内容为  %@", model.action);
    NSInteger num = [model.action integerValue];
    switch (num) {
        case 1:
        {
            NSLog(@"活动有人参加了、投票有人参与了、求助有人回答了");
            NSInteger interactionType = [model.interactionType integerValue];
            switch (interactionType) {
                case 1:{  // 活动详情
                    DetailActivityShowController * activityController = [[DetailActivityShowController alloc]init];
                    activityController.interactionType = model.interactionType;
                    activityController.interaction = model.interaction;
                    activityController.orTrue = YES;
                    
//                    activityController.model = inter;
                    [self.navigationController pushViewController:activityController animated:YES];
                }
                    break;
                case 2:{  // 投票详情
                    VoteTableController *voteController = [[VoteTableController alloc]init];  /// 投票
                    voteController.voteArray = [NSMutableArray array];
                    voteController.interactionType = model.interactionType;
                    voteController.interaction = model.interaction;
//                    [voteController.voteArray addObject:inter];
                    [self.navigationController pushViewController:voteController animated:YES];
                    
                }
                    break;
                case 3:  // 求助详情
                {
                    HelpTableViewController *helpController = [[HelpTableViewController alloc]init];  // 求助
                    helpController.interactionType = model.interactionType;
                    helpController.interaction = model.interaction;
                    
//                    helpController.model = inter;
                    [self.navigationController pushViewController:helpController animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            case 4:
        {
            NSLog(@"评论有回复");
        } break;
        case 6:{
            NSLog(@"被邀请进小队");
        } break;
            case 7:
        {
            NSLog(@"入群申请被通过");
        } break;
            case 8:
        {
            NSLog(@"XX申请入X群，待处理(群主)");
        } break;
            
        default:
            break;
    }
    
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
