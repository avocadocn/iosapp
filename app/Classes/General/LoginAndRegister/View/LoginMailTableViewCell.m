//
//  LoginMailTableViewCell.m
//  app
//
//  Created by 申家 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "LoginMailTableViewCell.h"
#import <Masonry.h>

@implementation LoginMailTableViewCell

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
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.skipButton setTitle:@"立即注册" forState: UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor colorWithRed:.9 green:.2 blue:0 alpha:1] forState:UIControlStateNormal];
    [self addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).with.offset(0);
        make.centerY.mas_equalTo(self).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    self.backgroundColor = DLSBackgroundColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
