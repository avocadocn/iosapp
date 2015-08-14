//
//  AttentionViewCell.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionViewCell : UITableViewCell


@property (strong, nonatomic)  UILabel *AttentionName;
@property (strong, nonatomic)  UIImageView *AttentionPhoto;
@property (strong, nonatomic)  UILabel *AttentionWork;

- (void)cellBuiltWithModel:(id)model;


@end
