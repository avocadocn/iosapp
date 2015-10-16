//
//  RankListItemView.h
//  app
//
//  Created by tom on 15/10/16.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RankDetileModel;
@interface RankListItemView : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *personName;
@property (nonatomic, strong)UILabel *personLike;
@property (nonatomic, strong)NSIndexPath *indexpath;

@property (nonatomic, strong)UIImageView *likeImage;

- (void)reloadRankCellWithRankModel:(RankDetileModel *)model andIndex:(NSString *)index;
@end
