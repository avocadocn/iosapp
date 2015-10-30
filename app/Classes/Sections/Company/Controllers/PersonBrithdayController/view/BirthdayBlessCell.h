//
//  BirthdayBlessCell.h
//  app
//
//  Created by 申家 on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;

@interface BirthdayBlessCell : UICollectionViewCell

- (void)reloadCellWithModel:(AddressBookModel *)model;

@property (nonatomic, strong)NSIndexPath *indexPath;

@end