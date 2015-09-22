//
//  CompanySmallCell.h
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendSchollTableModel;

@interface CompanySmallCell : UICollectionViewCell
@property (strong, nonatomic) UICollectionView *SmallCollection;  //  横划 CollectionView
@property (strong, nonatomic) UILabel *TitleLabel;   //"标题 Label"
@property (strong, nonatomic) UIView *TitleView;  //标题  汉子们还没想好去哪玩吗?还不过来看看
// 纵向的扁平 cell

- (void)interCellWithModel:(SendSchollTableModel *)modelDic;

- (void)reloadWithIndexpath:(NSIndexPath *)index;

@end
