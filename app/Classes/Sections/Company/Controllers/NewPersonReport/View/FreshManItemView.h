//
//  FreshManItemView.h
//  app
//
//  Created by tom on 15/10/16.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressBookModel;

@interface FreshManItemView : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *personName;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, strong)UIImageView *likeImage;

- (void)reloadCellWithModel:(AddressBookModel *)model;


@end
