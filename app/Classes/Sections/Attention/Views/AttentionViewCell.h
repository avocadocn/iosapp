//
//  AttentionViewCell.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;

@class Person;

@interface AttentionViewCell : UITableViewCell


@property (strong, nonatomic)  UILabel *AttentionName;
@property (strong, nonatomic)  UIImageView *AttentionPhoto;
@property (strong, nonatomic)  UILabel *AttentionWork;
@property (strong, nonatomic) UIButton *joinButton;
- (void)cellBuiltWithModel:(Person *)model;

@end
