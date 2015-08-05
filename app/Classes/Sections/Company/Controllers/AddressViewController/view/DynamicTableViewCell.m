//
//  DynamicTableViewCell.m
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import <Masonry.h>


@implementation DynamicTableViewCell

//- (void)awakeFromNib {
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setBackgroundColor:[UIColor colorWithWhite:.95 alpha:.9]];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth / (375 / 60.0), 0, .5, 25)];
    [lineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [self addSubview:lineView];
    
    UIView *pointView = [UIView new];
    [pointView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = 3;
    [self addSubview:pointView];
    
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineView.mas_centerX);
        make.centerY.mas_equalTo(lineView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    self.cellBackGroundView = [UIImageView new];
    [self addSubview:self.cellBackGroundView];

    [self.cellBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(DLScreenHeight / (667 / 200.0));
    }];
    
    UIView *whiteBackView = [UIView new];
    [whiteBackView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:whiteBackView];
    
    [whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellBackGroundView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(DLScreenHeight / (667 / 80.0));
    }];
    
    self.cellNameLabel = [UILabel new];
    self.cellNameLabel.textAlignment = NSTextAlignmentLeft;

    [whiteBackView addSubview:self.cellNameLabel];
    [self.cellNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteBackView.mas_top);
        make.left.mas_equalTo(whiteBackView.mas_left).offset(15);
        make.right.mas_equalTo(whiteBackView.mas_right);
        make.height.mas_equalTo(DLScreenHeight / (667 /35.0));
    }];
    
    UIImageView *timeImage = [UIImageView new];
    timeImage.image = [UIImage imageNamed:@"time"];

    [self addSubview:timeImage];
    CGFloat width = 667 / ((80 - 35) / 2.0);
    
    [timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellNameLabel.mas_bottom);
        make.left.mas_equalTo(self.cellNameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake((DLScreenHeight / width), (DLScreenHeight / width)));
    }];
    
    UIImageView *address = [UIImageView new];
    address.image = [UIImage imageNamed:@"address"];
    [self addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeImage.mas_bottom);
        make.left.mas_equalTo(self.cellNameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake((DLScreenHeight / width), (DLScreenHeight / width)));
    }];
    
    self.cellTimeLabel = [UILabel new];
    self.cellTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.cellTimeLabel.font = [UIFont systemFontOfSize:15];
    self.cellTimeLabel.textColor = [UIColor colorWithWhite:.3 alpha:1];

    [self addSubview:self.cellTimeLabel];
    [self.cellTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeImage.mas_top);
        make.left.mas_equalTo(timeImage.mas_right);
        make.bottom.mas_equalTo(timeImage.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    self.cellAddressLabel = [UILabel new];
    self.cellAddressLabel.textAlignment = NSTextAlignmentLeft;
    self.cellAddressLabel.font = [UIFont systemFontOfSize:15];
    self.cellAddressLabel.textColor = [UIColor colorWithWhite:.3 alpha:1];

    [self addSubview:self.cellAddressLabel];
    
    [self.cellAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(address.mas_top);
        make.left.mas_equalTo(address.mas_right);
        make.bottom.mas_equalTo(address.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
}

- (void)reloadCellWithModel:(id)model
{
    
    self.cellBackGroundView.image = [UIImage imageNamed:@"DaiMeng.jpg"];
    self.cellNameLabel.text = @"炎热八月, 小彤彤陪你度过不眠之夜";
    
    self.cellAddressLabel.text = @"康定路106号";
    self.cellTimeLabel.text = @"7月18日-7月19日";
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
