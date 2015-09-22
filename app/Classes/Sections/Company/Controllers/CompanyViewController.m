//
//  CompanyViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//
#import "SchoolTempModel.h"
#import <AFNetworking.h>
#import "AddressBookModel.h"
#import "CompanyViewController.h"
#import <ReactiveCocoa.h>
#import "CompanySmallCell.h"
#import "PrefixHeader.pch"
#import "CompanyHeader.h"
#import "ColleagueViewController.h"
#import "PrefixHeader.pch"
#import "CompanyModel.h"
#import "PersonReportController.h"
#import "BrithdayBlessController.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "SendSchollTableModel.h"

@interface CompanyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray *photoArray;

@end

@implementation CompanyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self builtInterface]; //铺设截面
    [self netRequest];
//    [self getRequestNet];
    
}
- (void)builtInterface
{
    self.photoArray = [NSMutableArray arrayWithArray:@[@"dacxcx", @"grdg", @"dwad"]];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout alloc];
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 85);
    layout.minimumLineSpacing = 11;
    self.BigCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.BigCollection.delegate = self;
    self.BigCollection.dataSource = self;
//    self.BigCollection.backgroundColor = [UIColor cyanColor];
    [self.BigCollection registerClass:[CompanySmallCell class] forCellWithReuseIdentifier:@"SmallCell"]; //注册重用池
    [self.BigCollection setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.5]];
    [self.BigCollection registerClass:[CompanyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BigHeader"];
    
    [self.view addSubview:self.BigCollection];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpPageAction:) name:@"JumpController" object:nil];  //  接受跳转通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpPageAction:) name:@"PersonReport" object:nil];  //
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpPageAction:) name:@"HappyBrithday" object:nil];  //
    
}
- (void)jumpPageAction:(NSNotification *)noti //用来跳转页面的通知
{
    NSString *str = [NSString stringWithFormat:@"%@", noti.name];
    if ([str isEqualToString:@"JumpController"]) {
        ColleagueViewController *coll = [[ColleagueViewController alloc]init];
        [self.navigationController pushViewController:coll animated:YES];
    } else if ([str isEqualToString:@"PersonReport"])
    {
        PersonReportController *report = [[PersonReportController alloc]init];
        [self.navigationController pushViewController:report animated:YES];
    } else if ([str isEqualToString:@"HappyBrithday"])
    {
        BrithdayBlessController *brith = [[BrithdayBlessController alloc]init];
        [self.navigationController pushViewController:brith animated:YES];
        
        NSLog(@"生日祝福");
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DLScreenWidth, 6 + DLMultipleWidth(109.0) + DLMultipleWidth(30.0));
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CompanySmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallCell" forIndexPath:indexPath];
    cell.tag = indexPath.row + 1;
    if ([[self.photoArray objectAtIndex:indexPath.row] isKindOfClass:[SendSchollTableModel class]])
    {
        SendSchollTableModel *model = [self.photoArray objectAtIndex:indexPath.row];
        [cell interCellWithModel:model];
    }
    
    [cell reloadWithIndexpath:indexPath];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CompanyHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BigHeader" forIndexPath:indexPath];
    header.viewCon = self;
    return header;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    SendSchollTableModel *model = [self.photoArray objectAtIndex:section];
    
    return self.photoArray.count;
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return self.photoArray.count;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)netRequest {
    AddressBookModel *model = [[AddressBookModel alloc] init];
    
    [model setLimit:100.00];
    [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:model useKeys:@[@"latestContentDate",@"lastContentDate",@"limit"] success:^(id json) {
        NSLog(@"请求成功-- %@",json);
//        [self reloadTableViewWithJson:json];
//        [self.photoArray addObject:[self getPhotoArrayFromJson:json]];
        [self.photoArray replaceObjectAtIndex:0 withObject:[self getPhotoArrayFromJson:json]];
        [self getRequestNet];
//        [self.BigCollection reloadData];
    } failure:^(id errorJson) {
        NSLog(@"请求失败 %@",errorJson);
    }];
}

- (SendSchollTableModel *)getPhotoArrayFromJson:(id)json
{
    SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
    
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        NSDictionary *content = [dic objectForKey:@"content"];
        NSArray *array = [content objectForKey:@"photos"];
        if (array.count) {
            NSDictionary *tempDic = [array firstObject];
            SchoolTempModel *school = [[SchoolTempModel alloc]init];
            [school setValuesForKeysWithDictionary:tempDic];
            [photoArray addObject:school];
            
        }
        if (photoArray.count == 6) {
//            SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
//            model.photoArray = [NSArray arrayWithArray:photoArray];
//            model.titleName = @"同事圈";
//            model.detileName = @"不一样的精彩";
            model.photoArray = [NSMutableArray arrayWithArray:photoArray];
            
            return model;
        }
        
    }
    model.photoArray = [NSMutableArray arrayWithArray:photoArray];
    
    return nil;
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
                NSLog(@"获取新人列表成功");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@", dic);
        
        SendSchollTableModel *model = [self getImageFromDic:dic];
        
        [self.photoArray replaceObjectAtIndex:1 withObject:model];
        
//        [self.photoArray addObject:model];
        [self.BigCollection reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (SendSchollTableModel *)getImageFromDic: (NSDictionary *)dic
{
    SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
    NSMutableArray *photoArray = [NSMutableArray array];
    
    NSArray *array = [dic objectForKey:@"users"];
    int i = 0;
    for (NSDictionary *tempDic in array) {
//        photoArray
        SchoolTempModel *school = [[SchoolTempModel alloc]init];
        [school setValuesForKeysWithDictionary:tempDic];
        [photoArray addObject:school];
        if (i == 5) {
            
            model.photoArray = [NSArray arrayWithArray:photoArray];
            return model;
        }
        i++;
    }
    model.photoArray = [NSArray arrayWithArray:photoArray];
    return model;
    
}

//成功

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
