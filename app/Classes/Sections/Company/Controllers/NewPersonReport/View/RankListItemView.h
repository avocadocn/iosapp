//
//  RankListItemView.h
//  app
//
//  Created by tom on 15/10/16.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankListController.h"
@class RankDetileModel;
@interface RankListItemView : UICollectionViewCell <RankListControllerDelegate>

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *personName;
@property (nonatomic, strong)UILabel *personLike;
@property (nonatomic, strong)NSIndexPath *indexpath;

@property (nonatomic, strong)UIImageView *likeImage;
@property (nonatomic, strong)UIView* voteRect;
@property (nonatomic,strong) id<RankListControllerDelegate>delegate;

- (void)reloadRankCellWithRankModel:(RankDetileModel *)model andIndex:(NSString *)index;
@end
