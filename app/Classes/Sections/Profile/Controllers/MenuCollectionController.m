//
//  MenuCollectionController.m
//  app
//
//  Created by 张加胜 on 15/8/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "MenuCollectionController.h"
#import "MenuCollectionViewCell.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "UIImageView+DLGetWebImage.h"
#import "Account.h"
#import "AccountTool.h"

@interface MenuCollectionController ()


/**
 *  所有的item的name集合
 */
@property (nonatomic, strong) NSArray *itemNames;
/**
 *  所有的icon的图片名集合
 */
@property (nonatomic, strong) NSArray *itemIcons;


@end

@implementation MenuCollectionController

static NSString * const reuseIdentifier = @"MenuCollectionViewCell";


-(void)loadView{
    
    CGFloat margin = 0.6;
    
    CGFloat width = (DLScreenWidth - 2 * margin) / 3;
    CGFloat height = 90 ;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(width, height)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [flowLayout setMinimumLineSpacing:margin];
    [flowLayout setMinimumInteritemSpacing:margin];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 2 * height + margin) collectionViewLayout:flowLayout];
    //    self.collectionView = [[UICollectionView alloc]initWithFrame:cgrec collectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemNames = @[@"我的信息",@"群组",@"消息",@"活动",@"投票",@"求助"];
    
    self.itemIcons = @[@"我的信息111@2X",@"社团111@2X",@"消息111@2X",@"活动111@2X",@"投票111@2X",@"求助111@2x"];
    
    
    self.collectionView.backgroundColor = GrayBackgroundColor;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    CGFloat margin = 0.6;
    CGFloat width = (DLScreenWidth - 2 * margin) / 3;
    CGFloat height = width * 90 / 125 ;
    [self.view setFrame:CGRectMake(0, 0, DLScreenWidth, 2 * 90 + margin)];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    Account *account = [AccountTool account];
    //    Person *p = [[FMDBSQLiteManager shareSQLiteManager]selectPersonWithUserId:account.ID];
    //    if (indexPath.row == 0) {
    //        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //        cell.menuCollectionCellName.text = @"我的信息";
    //        [cell.menuCollectionCellIcon dlGetRouteWebImageWithString:p.imageURL placeholderImage:[UIImage imageNamed:@"icon1" ]];
    //        return cell;
    //    } else {
    //        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //        cell.menuCollectionCellName.text = self.itemNames[indexPath.row];
    //        [cell.menuCollectionCellIcon setImage:[UIImage imageNamed:self.itemIcons[indexPath.row]]];
    //        return cell;
    //    }
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.menuCollectionCellName.text = self.itemNames[indexPath.row];
    [cell.menuCollectionCellIcon setImage:[UIImage imageNamed:self.itemIcons[indexPath.row]]];
    return cell;
    
    // Configure the cell
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(collectionController:didSelectedItemAtIndex:)]) {
        [self.delegate collectionController:self didSelectedItemAtIndex:indexPath.row];
    }
    
}



@end
