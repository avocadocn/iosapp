//
//  CustomMemberTableViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CustomMemberTableViewCell.h"


@interface CustomMemberTableViewCell() <UICollectionViewDataSource,UICollectionViewDelegate>



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
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.iconCollectionView.collectionViewLayout;
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
    [iconImageView setImage:[UIImage imageNamed:@"1"]];
    
    // 设置圆形icon
    [iconImageView.layer setCornerRadius:iconImageView.width / 2];
    [iconImageView.layer setMasksToBounds:YES];
    [cell.contentView addSubview:iconImageView];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd",indexPath.item);
}


#pragma mark - setter method
-(void)setMemberInfos:(NSArray *)memberInfos{
    
    _memberInfos = memberInfos;
   
}

@end
