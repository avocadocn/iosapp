//
//  RepeaterGroupController.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RepeaterGroupController.h"
#import "GroupCardViewCell.h"
#import "photoSectionHeader.h"

@interface RepeaterGroupController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation RepeaterGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeFalseData];
    [self builtInterface];
}

- (void)makeFalseData
{
    self.modelArray = [NSMutableArray array];
    NSArray *array = @[@"已经转发的小队", @"选择您要转发的小队"];
    for (NSString *str in array) {
        
        NSDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:str forKey:@"title"];
        NSMutableArray *tempArray = [NSMutableArray array];
        NSInteger inte = arc4random() % 15;
        for (int i = 0; i < inte; i++) {
            [tempArray addObject:@"动梨基地"];
        }
        [dic setValue:tempArray forKey:@"array"];
        [self.modelArray addObject:dic];
    }
}

- (void)builtInterface
{
    
    NSInteger interval = 10;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(interval, interval , interval, interval);
    layout.headerReferenceSize = CGSizeMake(DLScreenWidth, 30);
    self.groupListCollection = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.groupListCollection setBackgroundColor:[UIColor whiteColor]];
    [self.groupListCollection registerClass:[GroupCardViewCell class] forCellWithReuseIdentifier:@"groupCardCell"];
    self.groupListCollection.backgroundColor = DLSBackgroundColor;
    self.groupListCollection.delegate = self;
    self.groupListCollection.dataSource = self;
    
    [self.groupListCollection registerClass:[photoSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section"];
    
    [self.view addSubview:self.groupListCollection];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    photoSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section" forIndexPath:indexPath];
    [header setBackgroundColor:[UIColor clearColor]];
    NSDictionary *dic = [self.modelArray objectAtIndex:indexPath.section];
    NSString *str = [dic objectForKey:@"title"];
    header.label.text = str;
    header.label.textColor = [UIColor orangeColor];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DLMultipleWidth(111.0), DLMultipleHeight(126.0));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"groupCardCell" forIndexPath:indexPath];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.modelArray objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"array"];
    
    return [array count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}

@end
