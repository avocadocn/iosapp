//
//  CompanyHeader.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanyHeader.h"

// 公司页面的header
@implementation CompanyHeader

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
    self.AddressBookLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, DLScreenWidth / 2 - 5, 45)];
    self.AddressBookLabel.backgroundColor = [UIColor whiteColor];
    self.AddressBookLabel.text = @"群组";
    self.AddressBookLabel.userInteractionEnabled = YES;
    self.AddressBookLabel.textAlignment = 1;
        self.AddressBookLabel.textColor = [UIColor colorWithWhite:.2 alpha:.5];
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressTapAction:)];
    [self.AddressBookLabel addGestureRecognizer:addressTap];
    [self addSubview:self.AddressBookLabel];
    
    self.groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(DLScreenWidth / 2 + 5, 8, DLScreenWidth / 2 - 5, 45)];
    self.groupLabel.userInteractionEnabled = YES;
    self.groupLabel.backgroundColor = [UIColor whiteColor];
    self.groupLabel.text = @"通讯录";
    self.groupLabel.textAlignment = 1;
    self.groupLabel.textColor = [UIColor colorWithWhite:.2 alpha:.5];
    
    UITapGestureRecognizer *groupTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupTapAction:)];
    [self.groupLabel addGestureRecognizer:groupTap];
    [self addSubview:self.groupLabel];
    self.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.5];
}
- (void)addressTapAction:(UITapGestureRecognizer *)tap
{
    
}
- (void)groupTapAction:(UITapGestureRecognizer *)tap
{
    
}

@end
