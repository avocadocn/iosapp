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
    [self.skipButton setTitle:@"立即注册        " forState: UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor colorWithRed:.9 green:.2 blue:0 alpha:1] forState:UIControlStateNormal];
    [self addSubview:self.skipButton];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-75);
        make.centerY.mas_equalTo(self).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    self.backgroundColor = DLSBackgroundColor;
    }
    
    UILabel *notFoundLabel = [UILabel new];
    
    NSInteger fontSize = 17;
    NSString *str = @"没有找到您的公司?";
    NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(10000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic context:nil];
    
    notFoundLabel.text = @"没有找到您的公司?";
    notFoundLabel.font = [UIFont systemFontOfSize:15];
    notFoundLabel.textColor = [UIColor colorWithWhite:.2 alpha:.8];
    [self addSubview:notFoundLabel];
    notFoundLabel.textAlignment = NSTextAlignmentRight;
    [notFoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.skipButton.mas_left);
        make.top.mas_equalTo(self.skipButton.mas_top);
        make.bottom.mas_equalTo(self.skipButton.mas_bottom);
        make.width.mas_equalTo(rect.size.width);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
