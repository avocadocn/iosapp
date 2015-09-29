//
//  SchoolFirstPageCell.h
//  app
//
//  Created by 申家 on 15/9/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendSchollTableModel;

@interface SchoolFirstPageCell : UICollectionViewCell

@property (nonatomic, strong)SendSchollTableModel *schoolModel;

- (void)reloadWithIndexpath:(NSIndexPath *)index;
@end
