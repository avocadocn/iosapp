//
//  ViewController.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#import "ColleaguesInformationController.h"
#import "BirthdayBlessCell.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "BrithdayBlessController.h"
#import "HMWaterflowLayout.h"
#import <MJExtension.h>
#import "HMShop.h"
#import "HMShopCell.h"
#import <MJRefresh.h>
#import "AddressBookModel.h"
//#import <UIScrollView+MJRefresh.h>
@interface  BrithdayBlessController () <UICollectionViewDataSource, UICollectionViewDelegate, HMWaterflowLayoutDelegate>

@property (nonatomic, strong)NSMutableArray *modelArray;
@end

@implementation BrithdayBlessController

- (NSMutableArray *)shops
{
    if (_shops == nil) {
        self.shops = [NSMutableArray array];
    }
    return _shops;
}

static NSString *const ID = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netRequest];
    self.title = @"生日祝福";
    
    // 1.初始化数据
    
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
    layout.delegate = self;
    
    // 2.创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //    [collectionView registerNib:[UINib nibWithNibName:@"HMShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [collectionView registerClass:[BirthdayBlessCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
    // 3.增加刷新控件
    [self.collectionView setFooter:[MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)]];
}

- (void)netRequest
{
    [RestfulAPIRequestTool routeName:@"getBirthdayList" requestModel:nil useKeys:@[] success:^(id json) {
        NSLog(@" 获取到过生日的用户为%@", json);
        self.modelArray = [NSMutableArray array];
        for (NSDictionary *dic in json) {
            AddressBookModel *model = [[AddressBookModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.modelArray addObject:model];
        }
        [self.collectionView reloadData];
    } failure:^(id errorJson) {
        NSLog(@"获取生日失败");
    }];
}


- (void)loadMoreShops
{
}

#pragma mark - <HMWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
//    HMShop *shop = self.shops[indexPath.item];
//    return shop.h / shop.w * width;  //  对应图片的 高 宽  缩放
    return width;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BirthdayBlessCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    [cell reloadCellWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    coll.model = [[AddressBookModel alloc]init];
    coll.model = model;
    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navigationController pushViewController:coll animated:YES];

    
}


@end
