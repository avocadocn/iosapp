//
//  CompanyTableViewCell.h
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyModel;

@interface CompanyTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *companyImageView;
@property (nonatomic, strong)UILabel *companyNameLabel;  //公司名称
@property (nonatomic, strong)UILabel *companySynopsnsLabel;  //公司简介
@property (nonatomic, strong)UIButton *chooseButton;

- (void)setCompanyCellWithModel:(CompanyModel *)model;

@end
