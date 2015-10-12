//
//  ViewController.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "BrithdayBlessController.h"
#import "HMWaterflowLayout.h"
#import <MJExtension.h>
#import "HMShop.h"
#import "HMShopCell.h"
#import <MJRefresh.h>
//#import <UIScrollView+MJRefresh.h>
@interface  BrithdayBlessController () <UICollectionViewDataSource, UICollectionViewDelegate, HMWaterflowLayoutDelegate>


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
    NSArray *shopArray = [HMShop objectArrayWithFilename:@"1.plist"];
    [self.shops addObjectsFromArray:shopArray];
    
    HMWaterflowLayout *layout = [[HMWaterflowLayout alloc] init];
    layout.delegate = self;
    
    // 2.创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //    [collectionView registerNib:[UINib nibWithNibName:@"HMShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [collectionView registerClass:[HMShopCell class] forCellWithReuseIdentifier:ID];
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
    } failure:^(id errorJson) {
        NSLog(@"获取生日失败");
    }];
}


- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shopArray = [HMShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shopArray];
        [self.collectionView reloadData];
        
    });
}

#pragma mark - <HMWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    HMShop *shop = self.shops[indexPath.item];
    return shop.h / shop.w * width;  //  对应图片的 高 宽  缩放
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    HMShop *shop = self.shops[indexPath.item];
    cell.indexpath = indexPath;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"华珊" forKey:@"name"];
    [dic setObject:@"计算机科学专业" forKey:@"major"];
    [dic setObject:@"155" forKey:@"like"];
    [dic setObject:shop.img forKey:@"img"];
//    [cell reloadCellWithModel:(AddressBookModel *)dic];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的为 %@", indexPath);
}


@end
