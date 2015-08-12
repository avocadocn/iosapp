//
//  HMShopCell.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMShopCell.h"
#import "HMShop.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


typedef NS_ENUM(NSInteger, PersonAttitude) {
    PersonAttitudeDontLike,
    PersonAttitudeLike
};

@interface HMShopCell()

@property (nonatomic, assign)PersonAttitude attitude;

@end

@implementation HMShopCell


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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
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
        make.left.mas_equalTo(view.mas_left).offset(3);
        make.right.mas_equalTo(view.mas_centerX);
        make.bottom.mas_equalTo(view.mas_centerY);
    }];
    
    self.personMajor = [UILabel new];
    self.personMajor.textAlignment = NSTextAlignmentLeft;
    self.personMajor.font = [UIFont systemFontOfSize:11];
    self.personMajor.textColor = [UIColor colorWithWhite:.4 alpha:1];
    [view addSubview:self.personMajor];
    
    [self.personMajor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personName.mas_bottom);
        make.left.mas_equalTo(self.personName.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
    }];
    
    self.personLike = [UILabel new];
    self.personLike.textAlignment = NSTextAlignmentRight;
    self.personLike.font = [UIFont systemFontOfSize:14];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeButtonAction:)];
    self.personLike.userInteractionEnabled = YES;
    
    [self.personLike addGestureRecognizer:tap];
    [self addSubview:self.personLike];
    [self.personLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.right.mas_equalTo(view.mas_right);
        make.width.mas_equalTo(DLMultipleWidth(40.0));
        make.bottom.mas_equalTo(view.mas_centerY);
    }];
    self.likeImage = [UIImageView new];
    self.likeImage.image = [UIImage imageNamed:@"DonLike"];

    [view addSubview:self.likeImage];
    
    [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.right.mas_equalTo(self.personLike.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(20.0), DLMultipleWidth(20.0)));
    }];
    
}

- (void)reloadCellWithModel:(id)model
{
    //    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [model objectForKey:@"img"]]] placeholderImage:[UIImage imageNamed:@"loading"]];

    self.personName.text = [model objectForKey:@"name"];
    self.personMajor.text = [model objectForKey:@"major"];
    self.personLike.text = [model objectForKey:@"like"];
}



- (void)likeButtonAction:(UITapGestureRecognizer *)sender
{
    if (self.attitude == PersonAttitudeDontLike) {
        self.likeImage.image = [UIImage imageNamed:@"Like"];
        NSInteger num = [self.personLike.text integerValue];
        self.personLike.text = [NSString stringWithFormat:@"%ld", ++num];
        self.attitude = PersonAttitudeLike;
    } else {
        self.likeImage.image = [UIImage imageNamed:@"DonLike"];
        NSInteger num = [self.personLike.text integerValue];
        self.personLike.text = [NSString stringWithFormat:@"%ld", --num];
        self.attitude = PersonAttitudeDontLike;
    }
    NSLog(@"小伙子,我欣赏你! +%ld" , self.indexpath.row);
}


@end
