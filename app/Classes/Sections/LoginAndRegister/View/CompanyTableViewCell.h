//
//  CompanyTableViewCell.h
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ChooseButtonClickState){
    ChooseButtonClickStateGray,
    ChooseButtonClickStateLight
};

@class CompanyModel;

@interface CompanyTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *companyImageView;
@property (nonatomic, strong)UILabel *companyNameLabel;  //公司名称
@property (nonatomic, strong)UILabel *companySynopsnsLabel;  //公司简介
@property (nonatomic, strong)UIButton *chooseButton;
@property (nonatomic, assign)ChooseButtonClickState clickState;
- (void)setCompanyCellWithModel:(CompanyModel *)model;

@end
