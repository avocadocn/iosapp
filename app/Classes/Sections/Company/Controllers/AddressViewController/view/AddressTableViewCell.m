//
//  AddressTableViewCell.m
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AddressTableViewCell.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "AddressBookModel.h"
#import "UIImageView+DLGetWebImage.h"

@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self builtnterFaceWithSelectButton];
    }
    return self;
}

- (void)builtnterFaceWithSelectButton
{
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self addSubview:self.selectButton];
//    [self.selectButton setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"NO.png"] forState:UIControlStateNormal];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.height - 20, self.height - 20));
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
    [[[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:self.rac_prepareForReuseSignal]subscribeNext:^(id x) {
        if (!self.selected) {
            self.selected = YES;
            [self.selectButton setBackgroundImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
            NSLog(@"%@",self.personNameLabel.text);
            NSLog(@"%@",self.personEmailLabel.text);
            if ([self.delegate respondsToSelector:@selector(passValue:)]) {
                [self.delegate passValue:[NSString stringWithFormat:@"%@",self.personEmailLabel.text]];
            }
        } else {
            self.selected = NO;
            [self.selectButton setBackgroundImage:[UIImage imageNamed:@"NO.png"] forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(deleteValue:)]) {
                [self.delegate deleteValue:[NSString stringWithFormat:@"%@",self.personEmailLabel.text]];
            }
            NSLog(@"移除邀请对象");
        }
    
    }];
    
    self.personPhotoImageView = [UIImageView new];
    
    self.personPhotoImageView.layer.masksToBounds = YES;
    self.personPhotoImageView.layer.cornerRadius = 50 / 2.0;
    
    [self addSubview:self.personPhotoImageView];
//    [self.personPhotoImageView setBackgroundColor:[UIColor blackColor]];
    
    [self.personPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.width.mas_equalTo(50);
    }];
    
    self.personNameLabel = [UILabel new];
//    self.personNameLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.personNameLabel];
    [self.personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personPhotoImageView.mas_top).offset(5);
        make.left.mas_equalTo(self.personPhotoImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    self.personEmailLabel = [UILabel new];
//    self.personEmailLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:self.personEmailLabel];
    
    [self.personEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personNameLabel.mas_bottom);
        make.left.mas_equalTo(self.personNameLabel.mas_left);
        make.right.mas_equalTo(self.personNameLabel.mas_right);
        make.height.mas_equalTo(self.personNameLabel.mas_height);
    }];
//  选中图片OK.png,未选中图片2.png
    
}

- (void)cellReloadWithAddressModel:(AddressBookModel *)model
{
    [self.personPhotoImageView dlGetRouteWebImageWithString:model.photo placeholderImage:[UIImage imageNamed:@"1"]];
    self.personPhotoImageView.layer.masksToBounds = (self.frame.size.width - 10 )/ 2.0;
    self.personEmailLabel.text = model.phone;
    self.personNameLabel.text = model.realname;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
