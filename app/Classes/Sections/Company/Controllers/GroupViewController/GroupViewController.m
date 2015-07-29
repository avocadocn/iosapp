//
//  GroupViewController.m
//  app
//
//  Created by 申家 on 15/7/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupViewController.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "GroupCardViewCell.h"


@interface GroupViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
      
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeFalseData];
    [self builtInterface];
}

- (void)makeFalseData
{
    self.modelArray = [NSMutableArray array];
    NSInteger inte = arc4random() % 15;
    for (int i = 0; i < inte; i++) {
        NSString *str = @"我的滑板鞋时尚时尚最时尚";
        [self.modelArray addObject:str];
    }
}

- (void)builtInterface
{
    
    NSInteger interval = 10;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.minimumInteritemSpacing = interval;
//    layout.minimumLineSpacing = interval;
    layout.sectionInset = UIEdgeInsetsMake(interval, interval , interval, interval);
    
    
    
    self.groupListCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.groupListCollection setBackgroundColor:[UIColor whiteColor]];
    [self.groupListCollection registerClass:[GroupCardViewCell class] forCellWithReuseIdentifier:@"groupCardCell"];
    self.groupListCollection.backgroundColor = DLSBackgroundColor;
    self.groupListCollection.delegate = self;
    self.groupListCollection.dataSource = self;
    [self.view addSubview:self.groupListCollection];
    
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85, 135);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupCardCell" forIndexPath:indexPath];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modelArray count];
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