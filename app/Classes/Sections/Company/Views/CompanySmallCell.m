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

#import <Masonry.h>

static NSInteger indexNum = 0;
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
    @autoreleasepool {
        NSArray *array= [NSArray arrayWithObjects:@"同事圈",@"新人报道", @"生日祝福" ,nil];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 20;
        
        UIView *TitleView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleViewAction:)];
        indexNum ++;
        TitleView.tag = indexNum;
        [TitleView addGestureRecognizer:tap];
        CGFloat red = arc4random() % 100 / 100.0;
        CGFloat blue = arc4random() % 100 / 100.0;
        CGFloat green = arc4random() % 100 / 100.0;
        [TitleView setBackgroundColor:[UIColor colorWithRed:red green:blue blue:green alpha:1]];
        [self addSubview:TitleView];
        
        [TitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(self).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(DLScreenWidth / 3.5- 10, DLScreenWidth / 3.5 - 10));
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"company%ld", indexNum]];
        [TitleView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(TitleView.mas_centerX);
//            make.centerY.mas_equalTo(TitleView.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(TitleView., TitleView.width / 3.0));
            make.top.mas_equalTo(TitleView).with.offset(25);
            make.left.mas_equalTo(TitleView).with.offset(25);
            make.right.mas_equalTo(TitleView).with.offset(-25);
            make.bottom.mas_equalTo(TitleView).with.offset(-25);
        }];
        
        UILabel *titleViewLabel = [UILabel new];
        titleViewLabel.text = [array objectAtIndex:(indexNum - 1)];
        [titleViewLabel setTextColor:[UIColor whiteColor]];
        titleViewLabel.textAlignment = NSTextAlignmentCenter;
        titleViewLabel.font = [UIFont systemFontOfSize:15];
        [TitleView addSubview:titleViewLabel];
        [titleViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(3);
            make.left.mas_equalTo(TitleView.mas_left);
            make.right.mas_equalTo(TitleView.mas_right);
            make.height.mas_equalTo(20.0);
        }];
        
        self.SmallCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenWidth / 3.5) collectionViewLayout:layout];
//        self.SmallCollection = [UICollectionView new];
        self.SmallCollection.collectionViewLayout = layout;
        [self.SmallCollection setBackgroundColor:[UIColor whiteColor]];
        self.SmallCollection.delegate = self;
        self.SmallCollection.dataSource = self;
        [self.SmallCollection registerClass:[CompanyDetailCell class] forCellWithReuseIdentifier:@"DetailCell"];
        [self addSubview:self.SmallCollection];
//        [self.SmallCollection setBackgroundColor:[UIColor blackColor]];
        [self.SmallCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(TitleView.mas_right).offset(5);
            make.right.mas_equalTo(self).with.offset(0);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(TitleView.mas_bottom);
        }];
        
        self.TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, DLScreenWidth / 3.5 + 2, DLScreenWidth - 20, 22)];
        //    [self.TitleLabel setBackgroundColor:[UIColor redColor]];
        self.TitleLabel.text = @"汉子们还没想好去哪玩吗?还不过来看看";
        self.TitleLabel.textColor = [UIColor colorWithWhite:.2 alpha:.6];
        self.TitleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.TitleLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)titleViewAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:{
            //注册通知  //同事圈
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"JumpController" object:nil userInfo:dic];
            break;
        }
        case 2:  //  新人报道
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PersonReport" object:nil userInfo:dic];
            break;
        }
        case 3:{  //生日祝福
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HappyBrithday" object:nil userInfo:nil];
            break;
        }
        default:
            break;
    }
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
- (void)interCellWithModelArray:(id)model
{
    
}

//- (void)awakeFromNib {
//}

@end
