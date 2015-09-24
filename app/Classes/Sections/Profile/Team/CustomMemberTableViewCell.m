//
//  CustomMemberTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AddressBookModel.h"
#import "FolderViewController.h"

#import "Person.h"
#import "CustomMemberTableViewCell.h"
#import "FMDBSQLiteManager.h"
#import "UIImageView+DLGetWebImage.h"
@interface CustomMemberTableViewCell() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)FMDBSQLiteManager *manger;

@end

@implementation CustomMemberTableViewCell
static NSString * const ID = @"CustomMemberTableViewCell";

- (void)awakeFromNib {
    // Initialization code
   
    [self.iconCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.memberInfos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.manger) {
        self.manger = [FMDBSQLiteManager shareSQLiteManager];
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.iconCollectionView.collectionViewLayout;
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
    
    NSDictionary *dic = [self.memberInfos objectAtIndex:indexPath.row];
    Person *per = [self.manger selectPersonWithUserId:[dic objectForKey:@"_id"]];
    
    [iconImageView dlGetRouteWebImageWithString:per.imageURL placeholderImage:nil];
    
    
    // 设置圆形icon
    [iconImageView.layer setCornerRadius:iconImageView.width / 2];
    [iconImageView.layer setMasksToBounds:YES];
    [cell.contentView addSubview:iconImageView];

    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd",indexPath.item);
    NSDictionary *dic = [self.memberInfos objectAtIndex:indexPath.item];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"JumpToFolderController" object:nil userInfo:dic];
}





// 刷新 cell
#pragma mark - setter method
-(void)setMemberInfos:(NSArray *)memberInfos{
    
    _memberInfos = memberInfos;
    
    [self.iconCollectionView reloadData];
    
    /**
     
     [
     {
     _id=55dc110314a37c242b6486d4,
     time=2015-09-17T03: 02: 56.900Z
     }
     ],
     **/
   
}

@end
