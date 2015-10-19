//
//  RankListItemView.m
//  app
//
//  Created by tom on 15/10/16.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "Person.h"

#import "FMDBSQLiteManager.h"
#import "UIImageView+DLGetWebImage.h"
#import "Masonry.h"
#import "AddressBookModel.h"
#import "RankListItemView.h"
#import "RankDetileModel.h"
#import "Group.h"
typedef NS_ENUM(NSInteger, PersonAttitude) {
    PersonAttitudeDontLike,
    PersonAttitudeLike
};
@interface RankListItemView ()
@property (nonatomic, assign)PersonAttitude attitude;
@property (nonatomic, strong)UILabel *RankList;
@end
@implementation RankListItemView

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
        make.bottom.mas_equalTo(self.mas_bottom).offset(DLMultipleHeight(-50.0));
        
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
    
    self.personLike = [UILabel new];
    self.personLike.textAlignment = NSTextAlignmentRight;
    self.personLike.font = [UIFont systemFontOfSize:14];
    self.personLike.userInteractionEnabled = YES;
    [view addSubview:self.personLike];
    [self.personLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right).offset(-10);
        make.top.mas_equalTo(view.mas_top);
        make.bottom.mas_equalTo(view.mas_centerY);
        
    }];
    self.likeImage = [UIImageView new];
    self.likeImage.userInteractionEnabled = YES;
    self.likeImage.image = [UIImage imageNamed:@"Like"];
    [view addSubview:self.likeImage];
    
    [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.right.mas_equalTo(self.personLike.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(20.0), DLMultipleWidth(20.0)));
    }];
    
    self.RankList = [UILabel new];
//    [self.RankList setBackgroundColor:[UIColor redColor]];
    self.RankList.font = [UIFont systemFontOfSize:12];
    self.RankList.textAlignment = NSTextAlignmentRight;
    [view addSubview:self.RankList];
    
    [self.RankList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personLike.mas_bottom);
        make.left.mas_equalTo(self.likeImage.mas_left);
        make.right.mas_equalTo(self.personLike.mas_right);
//        make.height.mas_equalTo(16);
    }];
    self.voteRect = [UIView new];
    [self.voteRect setBackgroundColor:[UIColor clearColor]];
    [view addSubview:self.voteRect];
    [self.voteRect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(self.likeImage.mas_left);
        make.right.mas_equalTo(self.personLike.mas_right);
        make.bottom.mas_equalTo(self.RankList.mas_bottom);
    }];
    
}

- (void)votePressed:(id)sender
{
    NSLog(@"vote clicked!");
    if ([self.delegate respondsToSelector:@selector(voteForPeople)]) {
        [self.delegate voteForPeople];
    }
}

- (void)reloadRankCellWithRankModel:(RankDetileModel *)model andIndex:(NSString *)index
{
    self.personName.text = model.name;
    [self.imageView dlGetRouteThumbnallWebImageWithString:model.logo placeholderImage:nil withSize:CGSizeMake(200, 200)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    if (model.type==PARSE_TYPE_MEN||model.type==PARSE_TYPE_WOMEN) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(votePressed:)];
        [self.voteRect addGestureRecognizer:singleTap];
        self.personLike.text = model.vote;
    }
    else if (model.type==PARSE_TYPE_TEAM){
        self.personLike.text = [NSString stringWithFormat:@"%@",model.score];
    }
    self.RankList.text = [NSString stringWithFormat:@"排名: %@", index];
}

@end
