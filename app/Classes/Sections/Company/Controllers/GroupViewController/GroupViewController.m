//
//  GroupViewController.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

//#import "CompanyViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HMShop.h"
#import "HMShopCell.h"
#import <MJRefresh.h>
#import "HMWaterflowLayout.h"


#import "GroupDetileModel.h"
#import "TeamHomePageController.h"
#import "GroupViewController.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "GroupCardViewCell.h"
#import "TeamHomePageController.h"
#import "GroupSelectCell.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "GroupCardModel.h"
#import "CreateGroupController.h"
@interface GroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HMWaterflowLayoutDelegate>

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社团列表";
//    [self getRequestData];
    [self builtInterface];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRequestData) name:@"reloadGroup" object:nil];
    
//    [self.navigationController.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(returnButtonAction:) image:@"new_navigation_back@2x" highImage:@"new_navigation_back_helight@2x"];
}




- (void)returnButtonAction:(id)sender
{
//    CompanyViewController *company = [[CompanyViewController alloc]init];
    
//    [self.navigationController pushViewController:company animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"咦哈");
}

- (void)getRequestData
{
    // 获取群组应该有 targetid 的吧?
    
    [RestfulAPIRequestTool routeName:@"getCompanyGroupList" requestModel:nil useKeys:nil success:^(id json) {
        self.modelArray = [NSMutableArray array];
        NSLog(@"获取到的群组为%@", json);
        [self analyDataWithJson:json];
    } failure:^(id errorJson) {
        NSLog(@"获取群组失败, 原因为 %@", errorJson);
    }];
}

- (void)analyDataWithJson:(id)json
{
    NSArray *array = [json objectForKey:@"groups"];
    for (NSDictionary *dic in array) {
        GroupCardModel *model = [[GroupCardModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.modelArray addObject:model];
    }
    [self.groupListCollection reloadData];
}

- (void)builtInterface
{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(newAction) image:@"chatBar_more.png" highImage:@"chatBar_moreSelected.png"];
    
//    NSInteger interval = DLMultipleWidth(10.0);
    
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(interval, DLMultipleWidth(10.0) , interval, (interval / 2.0));
        layout.delegate = self;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.groupListCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.groupListCollection setBackgroundColor:[UIColor whiteColor]];
    [self.groupListCollection registerClass:[GroupCardViewCell class] forCellWithReuseIdentifier:@"groupCardCell"];
    [self.groupListCollection registerClass:[GroupSelectCell class] forCellWithReuseIdentifier:@"selectCell"];
    
    self.groupListCollection.backgroundColor = DLSBackgroundColor;
    self.groupListCollection.delegate = self;
    self.groupListCollection.dataSource = self;
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction:)];
    self.groupListCollection.footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refrshAction)];
    self.groupListCollection.header = header;
    [self.view addSubview:self.groupListCollection];
    
}

- (void)loadMoreAction:(id)sender // 加载
{
    [self.groupListCollection.footer endRefreshing];
}

- (void)refrshAction{  // 刷新
    [self.groupListCollection.header endRefreshing];
}


- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    GroupCardModel *group = [self.modelArray objectAtIndex:indexPath.row];
    NSString *str = group.name;
    CGRect rect = [self getRectWithFont:[UIFont systemFontOfSize:16] width:DLMultipleWidth(160.0) andString:str];
    NSInteger inter = rect.size.height  + 123;
    
    return inter / 200.0 * width;
}

- (CGRect)getRectWithFont:(UIFont *)font width:(CGFloat)num andString:(NSString *)string
{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(num, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DLMultipleWidth(111.0), DLMultipleHeight(126.0));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.modelArray count]) {
        GroupCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupCardCell" forIndexPath:indexPath];
        GroupCardModel *model = [self.modelArray objectAtIndex:indexPath.row];
        
        [cell cellReconsitutionWithModel:model];
        return cell;
        
    } else
        
    {
        GroupSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectCell" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modelArray count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < self.modelArray.count) {
        GroupCardModel *model = [self.modelArray objectAtIndex:indexPath.row];
        
        [model setAllInfo:YES];
        
        TeamHomePageController *groupDetile = [[TeamHomePageController alloc]init];
        
        
        groupDetile.groupCardModel = model;
        
        [self.navigationController pushViewController:groupDetile animated:YES];
        
    } else
    {
        // 创建小队
        CreateGroupController *create = [[CreateGroupController alloc]init];
        [self.navigationController pushViewController:create animated:YES];
    }
    
    /*
    TeamHomePageController *team = [[TeamHomePageController alloc]init];
    [self.navigationController pushViewController:team animated:YES];
    */
}

//- (BOOL)judgeMemberWithModel:(GroupCardModel *)model
//{
//    Account *acc = [AccountTool account];
//    NSArray *array  = model.member;
//    
//    for (NSDictionary *dic in array) {
//        if ([[dic objectForKey:@"_id"] isEqualToString:acc.ID]) {
//            return YES;
//        }
//    }
//    return NO;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [self getRequestData];
}

- (void)newAction
{
    CreateGroupController *create = [[CreateGroupController alloc]init];
    [self.navigationController pushViewController:create animated:YES];

}

@end
