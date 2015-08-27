//
//  CompanyViewController.m
//  DonDemo
//
//  Created by jason on 15/7/10.
//  Copyright (c) 2015年 jason. All rights reserved.
//

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


@interface CompanyViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation CompanyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self builtInterface]; //铺设截面
    
}
- (void)builtInterface
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout alloc];
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 65);
    layout.minimumLineSpacing = 15;
    self.BigCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    
    self.BigCollection.delegate = self;
    self.BigCollection.dataSource = self;
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
    return CGSizeMake(DLScreenWidth, DLScreenWidth / 3.5 + 30);
}
// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CompanySmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallCell" forIndexPath:indexPath];
    
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
