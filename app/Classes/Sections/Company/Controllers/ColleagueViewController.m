//
//  ColleagueViewController.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ColleagueViewController.h"
#import "ColleagueViewCell.h"
#import <Masonry.h>
@interface ColleagueViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation ColleagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
    [self makeFalse];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 15;
    self.ColleagueCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.ColleagueCollection.delegate = self;
    self.ColleagueCollection.dataSource = self;
    [self.ColleagueCollection setBackgroundColor:[UIColor colorWithWhite:.93 alpha:1]];
    self.title = @"同事圈";
    [self.ColleagueCollection registerClass:[ColleagueViewCell class] forCellWithReuseIdentifier:@"ColleagueCell"];
    [self.view addSubview:self.ColleagueCollection];
    
}

- (void)makeFalse
{
    self.modelArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {  //制造假数据
        int d = arc4random() % 10;
        
        NSString *str = [NSString stringWithFormat:@"%d", d];
        [self.modelArray addObject:str];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", collectionViewLayout);
    
    return CGSizeMake(DLScreenWidth - 20,DLScreenWidth / 2); //这个的判断
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColleagueViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColleagueCell" forIndexPath:indexPath];
    
    return cell;
}

//暂时有十个动态
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
