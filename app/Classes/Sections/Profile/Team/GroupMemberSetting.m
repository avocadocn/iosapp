//
//  GroupMemberSetting.m
//  app
//
//  Created by 申家 on 15/9/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "ApplyForGroup.h"
#import "DeleteMemberFromGroup.h"
#import "GroupMemberSetting.h"
#import "InviteGroupMember.h"
#import "GroupDetileModel.h"

@interface GroupMemberSetting ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *myTableView;



@end
static NSString *ID = @"fgs;ejnfjkeshjkfhjserf";
@implementation GroupMemberSetting

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"社团成员管理";
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 20)];
    view.backgroundColor = [UIColor whiteColor];
    self.myTableView.tableFooterView = view;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.view addSubview:self.myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"邀请成员", @"申请加入的成员", @"剔除成员"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = array[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"邀请成员");
            InviteGroupMember *member = [[InviteGroupMember alloc]init];
            member.detileModel = self.detileModel;
            [self.navigationController pushViewController:member animated:YES];
            
        }
            break;
        case 1:
        {
            NSLog(@"申请加入的成员");
            
            ApplyForGroup *apply = [[ApplyForGroup alloc]init];
            apply.detileModel = self.detileModel;
            [self.navigationController pushViewController:apply animated:YES];
            
        }
            break;
        case 2:
        {
            NSLog(@"剔除成员");
            DeleteMemberFromGroup *group = [[DeleteMemberFromGroup alloc] init];
            group.modelArray = (NSMutableArray *)[NSArray arrayWithArray:self.detileModel.member];
            group.model = self.detileModel;
            [self.navigationController pushViewController:group animated:YES];
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
