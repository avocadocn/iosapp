//
//  CompanyHeader.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CompanyHeader.h"
#import "AddressViewController.h"
#import "GroupViewController.h"
#import "View+MASAdditions.h"
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f
#define IS_IPHONE_4_SCREEN [[UIScreen mainScreen] bounds].size.height >= 480.0f && [[UIScreen mainScreen] bounds].size.height < 568.0f
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
    CGFloat width = 11;
    
    self.AddressBookLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 10, DLScreenWidth / 2 - 5 - width, 64)];
    self.AddressBookLabel.backgroundColor = [UIColor whiteColor];
    self.AddressBookLabel.text = @"   群组";
    self.AddressBookLabel.font = [UIFont systemFontOfSize:14];
    self.AddressBookLabel.userInteractionEnabled = YES;
    self.AddressBookLabel.textAlignment = 1;
//        self.AddressBookLabel.textColor = [UIColor colorWithWhite:.2 alpha:.5];
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressTapAction:)];
    [self.AddressBookLabel addGestureRecognizer:addressTap];
    [self addSubview:self.AddressBookLabel];
    
    self.groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(DLScreenWidth / 2 + 5, 10, DLScreenWidth / 2 - 5 - width, 64)];
    self.groupLabel.userInteractionEnabled = YES;
    self.groupLabel.backgroundColor = [UIColor whiteColor];
    self.groupLabel.text = @"    通讯录";
    self.groupLabel.font = [UIFont systemFontOfSize:14];
    self.groupLabel.textAlignment = 1;
//    self.groupLabel.textColor = [UIColor colorWithWhite:.2 alpha:.5];
    
    UITapGestureRecognizer *groupTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupTapAction:)];
    [self.groupLabel addGestureRecognizer:groupTap];
    [self addSubview:self.groupLabel];
    self.backgroundColor = RGBACOLOR(234, 236, 236, 1);

//    self.backgroundColor = [UIColor greenColor];
    [self creatImageViews];
}

- (void)creatImageViews {
    self.gropView = [[UIImageView alloc] initWithFrame:CGRectMake(DLScreenWidth / 7.5, 30, 30, 30)];
    self.gropView.contentMode = UIViewContentModeCenter;
    self.gropView.clipsToBounds = YES;
//    [self.gropView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.gropView.x);
//        make.top.mas_equalTo(self.gropView.y);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
    self.gropView.image = [UIImage imageNamed:@"shetuan@2x"];
//    self.gropView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.gropView];
    self.contactsView.contentMode = UIViewContentModeCenter;
    self.contactsView.clipsToBounds = YES;
    self.contactsView = [[UIImageView alloc] initWithFrame:CGRectMake(DLScreenWidth / 2 + DLScreenWidth / 7.5, 30, 30, 27)];
//    self.contactsView.backgroundColor = [UIColor cyanColor];
    self.contactsView.image = [UIImage imageNamed:@"通讯录 @2x"];
    [self addSubview:self.contactsView];
}
- (void)addressTapAction:(UITapGestureRecognizer *)tap
{
    GroupViewController *group = [[GroupViewController alloc]init];
    [self.viewCon.navigationController pushViewController:group animated:YES];
    
}
- (void)groupTapAction:(UITapGestureRecognizer *)tap
{
    AddressViewController *address = [[AddressViewController alloc]init];
    [self.viewCon.navigationController pushViewController:address animated:YES];
}

@end
