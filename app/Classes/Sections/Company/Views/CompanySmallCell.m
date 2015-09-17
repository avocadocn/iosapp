//
//  CompanySmallCell.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "SchoolTempModel.h"
#import "CompanySmallCell.h"
#import "PrefixHeader.pch"
#import "CompanyDetailCell.h"
#import "ColleagueViewController.h"
#import "SendSchollTableModel.h"
#import <Masonry.h>

static NSInteger indexNum = 1;
//typedef NS_ENUM(NSInteger, EnumOfCellTitleState){
//    EnumOfCellTitleStateNo,
//    EnumOfCellTitleStateYes
//};


@interface CompanySmallCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
//@property (nonatomic, assign)EnumOfCellTitleState state;

@property (nonatomic, strong)UILabel *titleViewLabel;
@property (nonatomic, strong)NSMutableArray *modelArray;
@property (nonatomic, strong)UIImageView *imageView;
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
        
        
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  //heng
        layout.minimumLineSpacing = 6;
//        layout.sectionInset = UIEdgeInsetsMake(0, 6, 0, 0);
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.TitleView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleViewAction:)];
        
//        self.TitleView.tag = indexNum;
        [self.TitleView addGestureRecognizer:tap];

        
        [self addSubview:self.TitleView];
        // 背景
        [self.TitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.top.mas_equalTo(self).with.offset(7);
            make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(109.0), DLMultipleWidth(109.0)));
        }];  // itemd大小
        
        self.imageView = [UIImageView new];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"company%ld", (long)indexNum - 1]];
        [self.TitleView addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(TitleView.mas_centerX);
//            make.centerY.mas_equalTo(TitleView.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(TitleView., TitleView.width / 3.0));
            make.top.mas_equalTo(self.TitleView).with.offset(25);
            make.left.mas_equalTo(self.TitleView).with.offset(25);
            make.right.mas_equalTo(self.TitleView).with.offset(-25);
            make.bottom.mas_equalTo(self.TitleView).with.offset(-25);
        }];
        
        self.titleViewLabel = [UILabel new];
        [self.titleViewLabel setTextColor:[UIColor whiteColor]];
        self.titleViewLabel.textAlignment = NSTextAlignmentCenter;
        self.titleViewLabel.font = [UIFont systemFontOfSize:15];

        [self.TitleView addSubview:self.titleViewLabel];
        [self.titleViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(3);
            make.left.mas_equalTo(self.TitleView.mas_left);
            make.right.mas_equalTo(self.TitleView.mas_right);
            make.height.mas_equalTo(20.0);
        }];
        
        self.SmallCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenWidth / 3.5 ) collectionViewLayout:layout];
//        self.SmallCollection = [UICollectionView new];
//        self.SmallCollection.backgroundColor = [UIColor greenColor];
        self.SmallCollection.collectionViewLayout = layout;
        [self.SmallCollection setBackgroundColor:[UIColor whiteColor]];
        self.SmallCollection.delegate = self;
        self.SmallCollection.dataSource = self;
        [self.SmallCollection registerClass:[CompanyDetailCell class] forCellWithReuseIdentifier:@"DetailCell"];
        [self addSubview:self.SmallCollection];
//        [self.SmallCollection setBackgroundColor:[UIColor blackColor]];
        [self.SmallCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.TitleView.mas_right).offset(7);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.TitleView.mas_top);
            make.bottom.mas_equalTo(self.TitleView.mas_bottom);
        }];

        self.TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 6 + DLMultipleWidth(109.0), DLScreenWidth - 20, DLMultipleWidth(30.0))];
        //    [self.TitleLabel setBackgroundColor:[UIColor redColor]];
        self.TitleLabel.textColor = [UIColor colorWithWhite:.2 alpha:.6];
        self.TitleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.TitleLabel];
        
        self.backgroundColor = [UIColor whiteColor];
//        indexNum ++;
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
    SchoolTempModel *model = [self.modelArray objectAtIndex:indexPath.row];
    [cell reloadDetilCell:model];
    
    return cell;
}
//小 cell 的数量 ,根据数组中的元素数量决定
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat num = DLMultipleWidth(109.0);
    return CGSizeMake(num, num);
}

- (void)reloadWithIndexpath:(NSIndexPath *)index
{
    NSArray *titleArray = @[@"不一样的精彩", @"汉子们扔掉肥皂,迎接小鲜肉", @"好多童鞋就要过生日啦,还不去送上祝福!"];
            self.TitleLabel.text = [titleArray objectAtIndex:index.row];
    NSArray *array= [NSArray arrayWithObjects:@"同事圈",@"新人报道", @"生日祝福" ,nil];
    NSArray *colorArray = [NSArray arrayWithObjects:
                           
                           RGBACOLOR(240, 213, 50, 1),
                           RGBACOLOR(100, 259, 234, 1),
                           RGBACOLOR(222, 164, 37, 1), nil];
    
    UIColor *color = [colorArray objectAtIndex:index.row];
    
    [self.TitleView setBackgroundColor:color];
    
    self.TitleView.tag = index.row + 1;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"company%ld", (long)indexNum + 1]];
    self.titleViewLabel.text = [array objectAtIndex:index.row];
}

//处理传过来的数据
- (void)interCellWithModel:(SendSchollTableModel *)modelDic
{
    
    
    self.modelArray = [NSMutableArray arrayWithArray:modelDic.photoArray];
    [self.SmallCollection reloadData];
}

//- (void)awakeFromNib {
//}

@end
