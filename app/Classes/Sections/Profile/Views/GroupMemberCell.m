//
//  GroupMemberCell.m
//  app
//
//  Created by 申家 on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//
#import "UIImageView+DLGetWebImage.h"
#import "GroupMemberCell.h"
#import "FMDBSQLiteManager.h"
#import <Masonry.h>
#import "Person.h"

@interface GroupMemberCell ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *name;
@end
@implementation GroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}

- (void)builtInterface
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat num = 20;
//    CGFloat width = (DLScreenWidth - 3) / 4.0 - num * 2;
    CGFloat width = 58.0;
    self.imageView = [UIImageView new];
    self.imageView.layer.borderColor = RGBACOLOR(236, 236, 236, 1).CGColor;
    self.imageView.layer.borderWidth = 1;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    self.imageView.layer.masksToBounds = YES;
//    self.imageView.layer.cornerRadius = width / 2.0;
    self.imageView.layer.cornerRadius = 5;
    
    self.name = [UILabel new];
    self.name.textColor = [UIColor colorWithWhite:.2 alpha:1];
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(num - 10);
        make.right.mas_equalTo(self.mas_right).offset(- num + 10);
    }];
    
}


- (void)setUserId:(NSString *)userId
{
    Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:userId];
    
    [self.imageView dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:CGSizeMake(100, 100)];
    self.name.text = per.name;
}

@end
