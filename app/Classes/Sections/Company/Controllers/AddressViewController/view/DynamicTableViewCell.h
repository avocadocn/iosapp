//
//  DynamicTableViewCell.h
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicTableViewCell : UITableViewCell


@property (nonatomic, strong)UILabel *cellNameLabel;  //炎热八月:

@property (nonatomic, strong)UILabel *cellTimeLabel;  //7月18日 - 7月19日

@property (nonatomic, strong)UILabel *cellAddressLabel;  //康定路454号

@property (nonatomic, strong)UIImageView *cellBackGroundView; //背景图片

- (void)reloadCellWithModel:(id)model;

@end
