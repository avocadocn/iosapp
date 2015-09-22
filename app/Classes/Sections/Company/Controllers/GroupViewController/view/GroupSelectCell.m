//
//  GroupSelectCell.m
//  app
//
//  Created by 申家 on 15/8/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "GroupSelectCell.h"
#import <Masonry.h>

@implementation GroupSelectCell

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
    NSArray *array = @[@"insert", @"search"];
    NSArray *titleArray = @[@"创建Band", @"搜索Band"];
    self.CellImageView = [UIImageView new];
    self.CellImageView.image = [UIImage imageNamed:[array objectAtIndex:0]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//    self.CellImageView.userInteractionEnabled = YES;
    self.CellImageView.tag = 1;
//    [self.CellImageView addGestureRecognizer:tap];
    self.CellImageView.layer.masksToBounds = YES;
    self.CellImageView.layer.cornerRadius = DLMultipleWidth(23.5);
    
    [self addSubview:self.CellImageView];
    
    [self.CellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(DLMultipleHeight(25.0));
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(47.0), DLMultipleWidth(47.0)));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    UILabel *label = [UILabel new];
    label.text = [titleArray objectAtIndex:0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.CellImageView.mas_bottom).offset(DLMultipleHeight(15.0));
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = .5;
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:{
            NSLog(@"创建小队");
            
            break;
        }
        default:
            break;
    }
    
}

@end
