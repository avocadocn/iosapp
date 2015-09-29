//
//  AttentionViewCell.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Person.h"
#import "FMDBSQLiteManager.h"

#import "AttentionViewCell.h"
#import <Masonry.h>
#import "UIImageView+DLGetWebImage.h"
#import "AddressBookModel.h"
#import "CompanyModel.h"

@implementation AttentionViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}

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
    self.AttentionPhoto = [UIImageView new];
    self.AttentionPhoto.layer.masksToBounds = YES;
    self.AttentionPhoto.layer.cornerRadius = DLMultipleHeight(22.5);
    [self addSubview:self.AttentionPhoto];
    
    [self.AttentionPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(DLMultipleWidth(12.0));
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight(45.0), DLMultipleHeight(45.0)));
    }];
    
    self.AttentionName = [UILabel new];
    self.AttentionName.font = [UIFont systemFontOfSize:14];
    self.AttentionName.textColor = [UIColor colorWithWhite:.15 alpha:1];
    [self addSubview:self.AttentionName];
    
    [self.AttentionName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.AttentionPhoto.mas_top);
        make.left.mas_equalTo(self.AttentionPhoto.mas_right).offset(DLMultipleWidth(12.0));
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.AttentionPhoto.mas_centerY);
    }];
    
    self.AttentionWork = [UILabel new];
    self.AttentionWork.textColor = [UIColor colorWithWhite:.3 alpha:1];
    self.AttentionWork.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.AttentionWork];
    
    [self.AttentionWork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.AttentionName.mas_bottom);
        make.left.mas_equalTo(self.AttentionName.mas_left);
        make.right.mas_equalTo(self.AttentionName.mas_right);
        make.bottom.mas_equalTo(self.AttentionPhoto.mas_bottom);
    }];
    
    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left).offset(DLMultipleWidth(20.0));
        make.height.mas_equalTo(.5);
    }];
    
    self.joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"insert"] forState:UIControlStateNormal];
//    [self.joinButton setBackgroundColor:[UIColor yellowColor]];
    self.joinButton.frame = CGRectMake(DLScreenWidth - 50, 12, 30, 30);
    [self addSubview:self.joinButton];
//    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(12);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
//        make.right.mas_equalTo(self.mas_right).offset(-12);
//        make.width.mas_equalTo(self.height - 24);
//    }];
    
}

- (void)cellBuiltWithModel:(Person *)per
{
    [self.joinButton removeFromSuperview];
    
    [self.AttentionPhoto dlGetRouteWebImageWithString:per.imageURL placeholderImage:nil];
    
    
    self.AttentionName.text = per.name;
//    CompanyModel *company = model.company;
    
//    self.AttentionWork.text = per;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
