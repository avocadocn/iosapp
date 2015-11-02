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

static NSNumber *myNum;

@interface GroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HMWaterflowLayoutDelegate>

@end

@implementation GroupViewController

- (void)viewDidLoad {
    
    myNum = [NSNumber numberWithInteger:1];
    [super viewDidLoad];
    
    self.title = @"社团列表";
    self.modelArray = [NSMutableArray array];
    [self reloadLibraryFile];
//    [self getRequestData];
    [self builtInterface];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRequestDataAndPage:) name:@"reloadGroup" object:nil];
    
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

- (void)getRequestDataAndPage:(NSNumber *)num
{
    // 获取群组应该有 targetid 的吧?
    NSString *netAddress;
    switch (self.groupType) {
        case GroupTypeSingle:
        {
            netAddress = [NSString stringWithFormat:@"getGroupList"];
        }
            break;
            
        default:
        {
            netAddress = [NSString stringWithFormat:@"getCompanyGroupList"];
        }
            break;
    }
    
    if (!num) {
        num = [NSNumber numberWithInt:1];
    }
    
    NSDictionary *dic =[NSDictionary dictionaryWithObject:num forKey:@"page"];
    NSLog(@"网络请求的数据为%@", dic);
    [RestfulAPIRequestTool routeName:netAddress requestModel:dic useKeys:@[@"page"] success:^(id json) {
        NSInteger nu = [myNum integerValue];
        if (nu == 1) {
            [self.modelArray removeAllObjects];
        }

        NSLog(@"获取到的群组为%@", json);
        [self analyDataWithJson:json];
        myNum = [NSNumber numberWithInteger:++nu];
    } failure:^(id errorJson) {
        NSLog(@"获取群组失败, 原因为 %@", errorJson);
        [self reloadLibraryFile];
    }];
}

- (void)analyDataWithJson:(id)json
{
    NSArray *array = [json objectForKey:@"groups"];
    NSString *groupType;
    switch (self.groupType) {
        case GroupTypeSingle:
            groupType = [NSString stringWithFormat:@"single"];
            break;
            
        default:
            groupType = [NSString stringWithFormat:@"company"];
            break;
    }
    
    for (NSDictionary *dic in array) {
        GroupCardModel *model = [[GroupCardModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        [model save:groupType];
        [self.modelArray addObject:model];
    }
    
    [self.groupListCollection reloadData];
    
    NSFileManager *manger = [NSFileManager defaultManager];
    
    NSMutableArray *mutable = [NSMutableArray array];
    
    NSArray *temp = [json objectForKey:@"groups"];
    
    for (NSDictionary *dic in temp) {
        NSString *IDStr = [dic objectForKey:@"_id"];
        
        [mutable addObject:IDStr];
    }
    NSString *arrayAddressStr = [NSString stringWithFormat:@"%@/DLLibraryCache/%@-groupFile/groupList", DLLibraryPath, groupType];
    
    BOOL judge = [manger fileExistsAtPath:arrayAddressStr];
    
    if (!judge) {  //文件不存在
        
        [mutable writeToFile:arrayAddressStr atomically:YES];
        
    } else //文件存在
    {
        [manger removeItemAtPath:arrayAddressStr error:nil];
        
        [mutable writeToFile:arrayAddressStr atomically:YES];
    }
}

- (void)reloadLibraryFile
{
    NSString *groupType;
    switch (self.groupType) {
        case GroupTypeSingle:
            groupType = [NSString stringWithFormat:@"single"];
            break;
            
        default:
            groupType = [NSString stringWithFormat:@"company"];
            break;
    }
    NSString *str = [NSString stringWithFormat:@"%@/DLLibraryCache/%@-groupFile/groupList", DLLibraryPath, groupType];
    if ([NSArray arrayWithContentsOfFile:str]) {
        
    
    NSArray *array = [NSArray arrayWithContentsOfFile:str];
    self.modelArray = [NSMutableArray array];
    for (NSString *str in array) {
        
        GroupCardModel *model = [[GroupCardModel alloc]initWithString:str andType:groupType];
        [self.modelArray addObject:model];
    }
    
    [self.groupListCollection reloadData];
    }
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
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction:)];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    
    self.groupListCollection.footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refrshAction)];
    self.groupListCollection.header = header;
    [self.view addSubview:self.groupListCollection];
    
}

- (void)loadMoreAction:(id)sender // 加载
{
    [self getRequestDataAndPage:myNum];
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
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSArray *array = [self.groupListCollection indexPathsForVisibleItems];
//    for (NSIndexPath *indexPath in array) {
//        NSLog(@"%@", indexPath);
//        GroupCardViewCell *cell = [self.groupListCollection dequeueReusableCellWithReuseIdentifier:@"groupCardCell" forIndexPath:indexPath];
//        if (!cell.groupIntroLabel.text) {
//        GroupCardModel *model = [self.modelArray objectAtIndex:indexPath.row];
//        [cell cellReconsitutionWithModel:model];
//        }
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        GroupCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupCardCell" forIndexPath:indexPath];
        GroupCardModel *model = [self.modelArray objectAtIndex:indexPath.row];
        
//        NSLog(@" model 的 logo 为  %@", model.logo);
//    if (self.groupListCollection.dragging == NO && self.groupListCollection.decelerating == NO) {
        
        [cell cellReconsitutionWithModel:model];
//    }
    
    
        return cell;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getRequestDataAndPage:[NSNumber numberWithInteger:1]];
}

- (void)newAction
{
    CreateGroupController *create = [[CreateGroupController alloc]init];
    [self.navigationController pushViewController:create animated:YES];

}

@end
