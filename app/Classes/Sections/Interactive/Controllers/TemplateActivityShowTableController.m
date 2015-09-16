//
//  TemplateActivityShowTableController.m
//  app
//
//  Created by tom on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TemplateActivityShowTableController.h"
#import "OtherActivityShowCell.h"
#import "OtherSegmentButton.h"
#import "TemplateDetailActivityShowController.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "getTemplateModel.h"
#import "Interaction.h"
#import <MJRefresh.h>

@interface TemplateActivityShowTableController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *modelArray;
@end

@implementation TemplateActivityShowTableController

static NSInteger pageLimit=10;
static NSString * const ID = @"OtherActivityShowCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addActivitysShowTable];
        [self.view setBackgroundColor:RGB(230, 230, 230)];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame=frame;
        [self addActivitysShowTable];
        [self.view setBackgroundColor:RGB(230, 230, 230)];
    }
    return self;
}
-(void)viewDidLoad{
    self.title = @"活动";
    self.modelArray = [NSMutableArray new];
    [self requestNet];
}

- (void)loadMoreData
{
    NSLog(@"load more data called");
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:1]];
    [model setLimit:[NSNumber numberWithInt:pageLimit]];
    Interaction* last =[self.modelArray lastObject];
    [model setCreateTime:last.createTime];
    [self.tableView.footer beginRefreshing];
    
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
        NSLog(@"success:-->%@",json);
        [self.tableView.footer endRefreshing];
    } failure:^(id errorJson) {
        NSLog(@"failed:-->%@",errorJson);
        [self.tableView.footer endRefreshing];
    }];
}

//进行网络数据获取
- (void)requestNet{
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:1]];
    [model setLimit:[NSNumber numberWithInt:pageLimit]];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
        NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
        NSLog(@"failed:-->%@",errorJson);
    }];
}
//解析返回的数据
- (void)analyDataWithJson:(id)json
{
    for (NSDictionary *dic  in json) {
        Interaction *inter = [[Interaction alloc]init];
        [inter setValuesForKeysWithDictionary:dic];
        [self.modelArray addObject:inter];
    }
    [self.tableView reloadData];
}

/**
 *  添加活动展示table
 */
-(void)addActivitysShowTable{
    
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[OtherActivityShowCell class] forCellReuseIdentifier:ID];
    // 设置分割线样式
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView setFrame:self.view.frame];
    //    NSLog(@"view frame is :%@",NSStringFromCGRect(self.view.frame));
    //将tableview的高度减小一个导航栏的高度
    tableView.height -= 64;
    //    NSLog(@"tableview frame is :%@",NSStringFromCGRect(tableView.frame));
    [tableView setBackgroundColor:self.view.backgroundColor];
//    [tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.footer = footer;
//    [self.tableView.footer setBackgroundColor:[UIColor redColor]];
    // NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.modelArray.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OtherActivityShowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    
    
    //    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
    //        NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    //        make.right.equalTo(self.tableView.mas_right);
    //    }];
    // NSLog(@"%@",NSStringFromCGRect(cell.frame));
    
    // Configure the cell...
    [cell reloadCellWithModel:[self.modelArray objectAtIndex:indexPath.row]];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 290 * DLScreenWidth / 375;
    
    Interaction* current =[self.modelArray objectAtIndex:indexPath.row];
    if (current.photos.count!=0) {
        NSInteger height = [[[current.photos objectAtIndex:0] objectForKey:@"height"] integerValue];
        NSInteger width = [[[current.photos objectAtIndex:0] objectForKey:@"width"] integerValue];
        if (width<DLScreenWidth) {
            height *= DLScreenWidth/width;
        }
        return 90 + height;
    }
    return 290;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TemplateDetailActivityShowController *controller = [[TemplateDetailActivityShowController alloc]init];
    if (self.modelArray) {
        controller.model = [self.modelArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

@end
