//
//  CompanyTableViewCell.m
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanyTableViewCell.h"
#import <Masonry.h>
#import "CompanyModel.h"
#import <UIImageView+WebCache.h>


@implementation CompanyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self builtInterface];
    }
    return self;
}

- (void)builtInterface
{
    @autoreleasepool {
        
        UIView *superView = [UIView new];
        
        [self addSubview:superView];
        self.backgroundColor = DLSBackgroundColor;
        [superView setBackgroundColor:[UIColor whiteColor]];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self).with.offset(10);
            make.right.mas_equalTo(self).with.offset(-10);
            make.bottom.mas_equalTo(self).with.offset(-10);
        }];

        self.companyImageView = [UIImageView new];
        self.companyImageView.layer.masksToBounds = YES;
        self.companyImageView.layer.cornerRadius = 25;
        [self addSubview:self.companyImageView];
//        self.companyImageView.backgroundColor = [UIColor blackColor];
        [self.companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(superView).with.offset(5);
            make.left.mas_equalTo(superView).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.companyNameLabel = [UILabel new];
//        [self.companyNameLabel setBackgroundColor:[UIColor blackColor]];
        [self addSubview:self.companyNameLabel];
        [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.companyImageView.mas_right).offset(10);
            make.top.mas_equalTo(superView).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(250, 25));
        }];
        
        self.companySynopsnsLabel = [UILabel new];
//        [self.companySynopsnsLabel setBackgroundColor:[UIColor blackColor]];
        [self addSubview:self.companySynopsnsLabel];
        [self.companySynopsnsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.companyNameLabel.mas_bottom).offset(2);
            make.left.mas_equalTo(self.companyNameLabel.mas_left);
            make.right.mas_equalTo(self.companyNameLabel.mas_right);
            make.height.mas_equalTo(self.companyNameLabel.mas_height);
        }];
        
        self.chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:self.chooseButton];
        [self.chooseButton setBackgroundColor:[UIColor blackColor]];
        [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(superView).with.offset(-10);
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCompanyCellWithModel:(CompanyModel *)model
{
    NSString *imageUrl = [model.imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.companyImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    self.companyNameLabel.text = model.company;
    self.companySynopsnsLabel.text = model.title;
    
}
@end
