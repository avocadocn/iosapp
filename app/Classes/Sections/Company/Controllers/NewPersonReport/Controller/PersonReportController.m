//
//  ViewController.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#import "ColleaguesInformationController.h"

#import "AddressBookModel.h"
#import "PersonReportController.h"
#import "HMWaterflowLayout.h"
#import <MJExtension.h>
#import "HMShop.h"
#import "HMShopCell.h"
#import <MJRefresh.h>
#import "Account.h"
#import "AccountTool.h"
#import "AddressBookModel.h"
#import "RestfulAPIRequestTool.h"
#import "FreshModel.h"
#import <AFNetworking.h>


//#import <UIScrollView+MJRefresh.h>
@interface  PersonReportController () <UICollectionViewDataSource, UICollectionViewDelegate, HMWaterflowLayoutDelegate>

@property (nonatomic, strong)NSMutableArray *modelArray;
@end

@implementation PersonReportController

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
    
    self.title = @"新人报道";
    [self getRequestNet];
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

- (void)getRequestNet
{
    Account *acc = [AccountTool account];
    
//    FreshModel *model =[[FreshModel alloc]init];
//    [model setCompanyId:acc.cid];
//    [model setFreshman:NO];
//    [model setPage:@1];
    
    NSString *str = [NSString stringWithFormat:@"%@/users/list/%@?freshman=%d&page=%@", BaseUrl,acc.cid,YES,@1];
    NSLog(@"请求的网址为 %@", str);
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"x-access-token"];
    
    [manger GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"获取新人列表成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", dic);
        [self reloadCollectionViewWithJson:dic];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)reloadCollectionViewWithJson:(id)json
{
    self.modelArray = [NSMutableArray array];
    NSArray *array = [json objectForKey:@"users"];
    for (NSDictionary *dic in array) {
        AddressBookModel *model = [[AddressBookModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.modelArray addObject:model];
    }
    [self.collectionView reloadData];
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
    return 172.0 / shop.w * width;  //  对应图片的 高 宽  缩放
//    return DLMultipleHeight(172.0 + 40.0);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    HMShop *shop = self.shops[indexPath.item];
    cell.indexpath = indexPath;
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"华珊" forKey:@"name"];
//    [dic setObject:@"计算机科学专业" forKey:@"major"];
//    [dic setObject:@"155" forKey:@"like"];
//    [dic setObject:shop.img forKey:@"img"];
    [cell reloadCellWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的为 %@", indexPath);
    
    AddressBookModel *model = [self.modelArray objectAtIndex:indexPath.row];
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    coll.model = [[AddressBookModel alloc]init];
    coll.model = model;
    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navigationController pushViewController:coll animated:YES];

}


@end
