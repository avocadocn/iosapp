//
//  CompanyViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//
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
//    [self netRequest];
    
}
- (void)builtInterface
{
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
    return CGSizeMake(DLScreenWidth, DLScreenWidth / 3.5 + 38);
}
// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CompanySmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallCell" forIndexPath:indexPath];
    cell.tag = indexPath.row + 1;
    SendSchollTableModel *model = [self.photoArray objectAtIndex:0];
    [cell interCellWithModel:model];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CompanyHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BigHeader" forIndexPath:indexPath];
    header.viewCon = self;
    return header;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)netRequest {
    AddressBookModel *model = [[AddressBookModel alloc] init];
    
    [model setLimit:100.00];
    [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:model useKeys:@[@"latestContentDate",@"lastContentDate",@"limit"] success:^(id json) {
        NSLog(@"请求成功-- %@",json);
//        [self reloadTableViewWithJson:json];
        self.photoArray = [NSMutableArray arrayWithObject:[self getPhotoArrayFromJson:json]];
        [self.BigCollection reloadData];
    } failure:^(id errorJson) {
        NSLog(@"请求失败 %@",errorJson);
    }];
}

- (SendSchollTableModel *)getPhotoArrayFromJson:(id)json
{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSDictionary *dic in json) {
        NSDictionary *content = [dic objectForKey:@"content"];
        NSArray *array = [content objectForKey:@"photos"];
        if (array.count) {
            [photoArray addObject:[array firstObject]];
        }
        if (photoArray.count == 9) {
            SendSchollTableModel *model = [[SendSchollTableModel alloc]init];
            model.photoArray = [NSArray arrayWithArray:photoArray];
            model.titleName = @"同事圈";
            model.detileName = @"不一样的精彩";
            
            return model;
        }
        
    }
    return nil;
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
