//
//  CompanySmallCell.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanySmallCell.h"
#import "PrefixHeader.pch"
#import "CompanyDetailCell.h"
#import "ColleagueViewController.h"
//typedef NS_ENUM(NSInteger, EnumOfCellTitleState){
//    EnumOfCellTitleStateNo,
//    EnumOfCellTitleStateYes
//};


@interface CompanySmallCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
//@property (nonatomic, assign)EnumOfCellTitleState state;
@end

@implementation CompanySmallCell

- (void)sendValueForTouch:(NSInteger)num
{
//    ColleagueViewController *colleague = [[ColleagueViewController alloc]init];
//    UIViewController *view = self.superview;
//    [view.navigationController pushViewController:colleague animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterFace];
    }
    return self;
}
- (void)builtInterFace
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 20;
    self.SmallCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenWidth / 3.5) collectionViewLayout:layout];
    [self.SmallCollection setBackgroundColor:[UIColor whiteColor]];
    self.SmallCollection.delegate = self;
    self.SmallCollection.dataSource = self;
    [self.SmallCollection registerClass:[CompanyDetailCell class] forCellWithReuseIdentifier:@"DetailCell"];
    [self addSubview:self.SmallCollection];
    
    self.TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, DLScreenWidth / 3.5 + 2, DLScreenWidth - 20, 22)];
//    [self.TitleLabel setBackgroundColor:[UIColor redColor]];
    self.TitleLabel.text = @"汉子们还没想好去哪玩吗?还不过来看看";
    self.TitleLabel.textColor = [UIColor colorWithWhite:.2 alpha:.6];
    self.TitleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.TitleLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell" forIndexPath:indexPath];
    return cell;
}
//小 cell 的数量 ,根据数组中的元素数量决定
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat num = DLScreenWidth / 3.5 - 18;
    return CGSizeMake(num, num);
}

//处理传过来的数据
- (void)interCellWithModelArray:(NSArray *)modelArray
{
    
}

//- (void)awakeFromNib {
//}

@end
