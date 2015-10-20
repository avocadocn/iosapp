//
//  BirthdayBlessCell.m
//  app
//
//  Created by 申家 on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//
#import "UIImageView+DLGetWebImage.h"
#import "AddressBookModel.h"
#import "BirthdayBlessCell.h"
#import <Masonry.h>
@interface BirthdayBlessCell ()

@property (nonatomic, strong)UILabel *RankList;

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *personName;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, strong)UIImageView *likeImage;
@property (nonatomic, strong)UILabel *personBirthday;
@end

@implementation BirthdayBlessCell
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
    [self setBackgroundColor:[UIColor whiteColor]];
    self.imageView = [UIImageView new];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(DLMultipleHeight(-40.0));
    }];
    
    // 2.名字
    UIView *view = [UIView new];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    self.personName = [UILabel new];
    self.personName.textAlignment = NSTextAlignmentLeft;
    self.personName.font = [UIFont systemFontOfSize:13];
    self.personName.textColor = [UIColor colorWithWhite:.3 alpha:1];
    [view addSubview:self.personName];
    
    [self.personName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(view.mas_left).offset(5);
        make.right.mas_equalTo(view.mas_centerX);
        make.bottom.mas_equalTo(view.mas_centerY);
    }];
    
    self.personBirthday = [UILabel new];
    self.personBirthday.font = [UIFont systemFontOfSize:11];
    self.personBirthday.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [view addSubview:self.personBirthday];
    [self.personBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personName.mas_bottom);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(self.personName.mas_left);
        make.width.mas_equalTo(100);
    }];
    
    
    self.likeImage = [UIImageView new];
    self.likeImage.userInteractionEnabled = YES;
    self.likeImage.image = [UIImage imageNamed:@"BirthdayGift"];
    [view addSubview:self.likeImage];
    
    [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(5);
        make.right.mas_equalTo(view.mas_right).offset(-5);
        
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(15.0), DLMultipleWidth(15.0)));
        //        make.centerY.mas_equalTo(view.mas_centerY);
    }];
}

- (void)reloadCellWithModel:(AddressBookModel *)model
{
    //    // 1.图片
    [self.imageView dlGetRouteThumbnallWebImageWithString:model.photo placeholderImage:nil withSize:CGSizeMake(200*2, 200*2)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.personName.text = model.nickname;
    self.personBirthday.text = [self getBrithdayWithStr:model.birthday];
}

- (NSString *)getBrithdayWithStr:(NSString *)str
{
    NSArray *Tarray = [str componentsSeparatedByString:@"T"];
    NSString *year = [Tarray firstObject];
    NSArray *mouth = [year componentsSeparatedByString:@"-"];
    NSString *returnStr = [NSString stringWithFormat:@"%@月%@日生日", mouth[1], mouth[2]];
    return returnStr;
}
@end
