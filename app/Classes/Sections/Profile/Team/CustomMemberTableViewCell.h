//
//  CustomMemberTableViewCell.h
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMemberTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *memberInfos;

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end
