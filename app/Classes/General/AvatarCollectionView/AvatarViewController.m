//
//  AvatarViewController.m
//  DLDemo
//
//  Created by 张加胜 on 15/7/15.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "AvatarViewController.h"
#import "AvatarCell.h"

@interface AvatarViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic)UICollectionView *collectionView;

@end

@implementation AvatarViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    // 初始化collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 150) collectionViewLayout:flowLayout];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:collectionView];
    
    
    // 设置代理和数据源方法
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    
    self.collectionView = collectionView;
    
    
    // 注册可重用单元格
    [self.collectionView registerClass:[AvatarCell class] forCellWithReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell setImg:[UIImage imageNamed:@"1"]];

    return cell;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
