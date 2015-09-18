//
//  GroupViewController.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

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
@interface GroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
      
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组";
    [self getRequestData];
    [self builtInterface];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRequestData) name:@"reloadGroup" object:nil];
}

- (void)getRequestData
{
    self.modelArray = [NSMutableArray array];
    // 获取群组应该有 targetid 的吧?
    
    [RestfulAPIRequestTool routeName:@"getGroupList" requestModel:nil useKeys:nil success:^(id json) {
//        NSLog(@"获取到的群组为%@", json);
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
    
    NSInteger interval = DLMultipleWidth(10.0);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(interval, DLMultipleWidth(10.0) , interval, (interval / 2.0));
    
    self.groupListCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.groupListCollection setBackgroundColor:[UIColor whiteColor]];
    [self.groupListCollection registerClass:[GroupCardViewCell class] forCellWithReuseIdentifier:@"groupCardCell"];
    [self.groupListCollection registerClass:[GroupSelectCell class] forCellWithReuseIdentifier:@"selectCell"];
    
    self.groupListCollection.backgroundColor = DLSBackgroundColor;
    self.groupListCollection.delegate = self;
    self.groupListCollection.dataSource = self;
    [self.view addSubview:self.groupListCollection];
    
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
    return [self.modelArray count] + 1;
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

@end
