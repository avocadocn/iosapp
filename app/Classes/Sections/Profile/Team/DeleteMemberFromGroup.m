//
//  DeleteMemberFromGroup.m
//  app
//
//  Created by 申家 on 15/9/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "RestfulAPIRequestTool.h"
#import "DeleteMemberFromGroup.h"
#import "AttentionViewCell.h"
#import "GroupDetileModel.h"
#import "AddressBookModel.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
@interface DeleteMemberFromGroup ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *myTableView;

@end

@implementation DeleteMemberFromGroup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"删除成员";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight) style:UITableViewStylePlain];
//    self.myTableView.editing = YES;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 10)];
    self.myTableView.tableFooterView = view;
    [self.myTableView registerClass:[AttentionViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.myTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataAction:) name:@"ReloadInsertMemberTableView" object:nil];
    
}

- (void)reloadDataAction:(NSNotification *)userInfo
{
    NSDictionary *dic = userInfo.userInfo;
    
    AddressBookModel *model = [[AddressBookModel alloc]init];
    model.ID = [dic objectForKey:@"UserId"];
    
    [self.modelArray addObject:model];
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    //不能是UITableViewCellEditingStyleNone
}


- (void)setModelArray:(NSMutableArray *)modelArray
{
    _modelArray = [NSMutableArray array];
    for (NSDictionary *dic in modelArray) {
        AddressBookModel *model = [[AddressBookModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_modelArray addObject:model];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    FMDBSQLiteManager* fmdb = [FMDBSQLiteManager shareSQLiteManager];
    Person* p = [fmdb selectPersonWithUserId:model.ID];
    if (p) {
        [cell cellBuiltWithModel:p];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AddressBookModel *model = self.modelArray[indexPath.row];

        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.model.ID, model.ID] forKeys:@[@"groupId", @"userId"]];
        
        [RestfulAPIRequestTool routeName:@"removeGroups" requestModel:dic useKeys:@[@"groupId", @"userId"] success:^(id json) {
            NSLog(@"成员移除成功  %@", json);
            
            [self.modelArray removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source.
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMemberTableView" object:nil userInfo:dic];
            [self.myTableView reloadData];
            
            
        } failure:^(id errorJson) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"成员移除失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [al show];
            NSLog(@"成员移除失败  %@", errorJson);
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}


@end
