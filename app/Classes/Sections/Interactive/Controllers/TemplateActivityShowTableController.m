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
#import <DGActivityIndicatorView.h>

@interface TemplateActivityShowTableController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *modelArray;
@end

@implementation TemplateActivityShowTableController

//一次请求的数据量
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


//下拉刷新时获取并加载更多数据
- (void)loadMoreData
{
//    NSLog(@"load more data called");
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:1]];
    [model setLimit:[NSNumber numberWithInteger:pageLimit]];
    Interaction* last =[self.modelArray lastObject];
    [model setCreateTime:last.createTime];
    
    [self.tableView.footer beginRefreshing];
//    [self loadingImageView];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
//        NSLog(@"success:-->%@",json);
//        [self.activityIndicatorView removeFromSuperview];
        [self.tableView.footer endRefreshing];
    } failure:^(id errorJson) {
//        NSLog(@"failed:-->%@",errorJson);
        [self.tableView.footer endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
    }];
}
- (void)refreshData{
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:1]];
    [model setLimit:[NSNumber numberWithInteger:pageLimit]];
    [self.tableView.header beginRefreshing];
//    [self loadingImageView];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        if ([json count]!=0) {
            self.modelArray = [NSMutableArray new];
            [self analyDataWithJson:json];
        }
        [self.tableView.header endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
        //        NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
        //        NSLog(@"failed:-->%@",errorJson);
        [self.tableView.header endRefreshing];
//        [self.activityIndicatorView removeFromSuperview];
    }];
}
//进行网络数据获取
- (void)requestNet{
    Account *acc= [AccountTool account];
    getTemplateModel * model = [getTemplateModel new];
    [model setUserId:acc.ID];
    [model setTemplateType:[NSNumber numberWithInt:1]];
    [model setLimit:[NSNumber numberWithInteger:pageLimit]];
    [RestfulAPIRequestTool routeName:@"getModelLists" requestModel:model useKeys:@[@"templateType",@"createTime",@"limit",@"userID"] success:^(id json) {
        [self analyDataWithJson:json];
//        NSLog(@"success:-->%@",json);
    } failure:^(id errorJson) {
//        NSLog(@"failed:-->%@",errorJson);
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
    [tableView registerNib:[UINib nibWithNibName:@"OtherActivityShowCell" bundle:nil] forCellReuseIdentifier:ID];
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
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.header = header;
    //添加底部下拉刷新
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //设置默认不显示文字，只在刷新过程中显示文字
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.footer = footer;
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
    [cell setIsTemplate:true];
    [cell reloadCellWithModel:[self.modelArray objectAtIndex:indexPath.row]];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return 290 * DLScreenWidth / 375;
    
    Interaction* current =[self.modelArray objectAtIndex:indexPath.row];
    if (current.photos.count!=0) {
        return 90 + DLScreenWidth*4/5;
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
