//
//  AttentionViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "PersonalDynamicController.h"

#import "AttentionViewController.h"
#import "AttentionViewCell.h"
#import "ColleaguesInformationController.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "AddressBookModel.h"
#import "CompanyModel.h"

@interface AttentionViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

static AttentionViewController *att = nil;

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeFalseValue];
    [self builtInterface];
    
}

+ (AttentionViewController *)shareInsten
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        if (!att) {
            att = [[AttentionViewController alloc]init];
        }
    });
    return att;
}

- (void)makeFalseValue
{
    self.modelArray = [NSMutableArray array];
    
    Account *acc = [AccountTool account];
    acc.userId = acc.ID;
    // 获取关注列表
    [RestfulAPIRequestTool routeName:@"getCorcernList" requestModel:acc useKeys:@[@"userId"] success:^(id json) {
//        NSLog(@"获取用户关注列表成功 %@", json);
        [self getDetailInforFromJson:json];
    } failure:^(id errorJson) {
        NSLog(@"获取用户列表失败  %@", errorJson);
    }];
}

- (void)getDetailInforFromJson:(id)array
{
    __block int i = 0;
    for (NSMutableDictionary *dic in array) {
        [dic setObject:[dic objectForKey:@"_id"] forKey:@"userId"];
        [RestfulAPIRequestTool routeName:@"getUserInfo" requestModel:dic useKeys:@[@"userId"] success:^(id json) {
            
            AddressBookModel *addressModel = [[AddressBookModel alloc]init];
            CompanyModel *companyModel = [[CompanyModel alloc]init];
            [companyModel setValuesForKeysWithDictionary:[json objectForKey:@"company"]];
            [addressModel setValuesForKeysWithDictionary:json];
            [addressModel setCompany:companyModel];
            addressModel.attentState = YES;
            
            [self.modelArray addObject:addressModel];
            i++;
            if (i == [array count]) {
                [self.attentionTableView reloadData];
            }
            
        } failure:^(id errorJson) {
            NSLog(@"没有获取到关注的用户信息 %@", errorJson);
        }];
    }
}

- (void)builtInterface{
    
    self.attentionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
    self.attentionTableView.delegate = self;
    self.attentionTableView.dataSource = self;
    self.attentionTableView.separatorColor = [UIColor clearColor];
    
    [self.attentionTableView registerClass:[AttentionViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.attentionTableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    [cell cellBuiltWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    PersonalDynamicController *fold = [[PersonalDynamicController alloc]init];
    fold.userModel = [[AddressBookModel alloc]init];
    fold.userModel = model;
    
    
    [self.navigationController pushViewController:fold animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.modelArray count];
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DLMultipleHeight(67.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
