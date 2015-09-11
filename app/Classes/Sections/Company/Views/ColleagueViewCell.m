//
//  ColleagueViewCell.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "WPHotspotLabel.h"
#import "AddressBookModel.h"
#import "ColleagueViewCell.h"
#import <Masonry.h>
#import "CircleImageView.h"
#import <ReactiveCocoa.h>
#import "CriticWordView.h"
#import "CircleContextModel.h"
#import "UIImageView+DLGetWebImage.h"
#import "UILabel+DLTimeLabel.h"
#import "Account.h"
#import "AccountTool.h"

static NSString *userId = nil;
@implementation ColleagueViewCell

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

    UIView *superBigView = [UIView new];  //容器
    [superBigView setBackgroundColor:[UIColor whiteColor]];
    
    self.backgroundColor = RGBACOLOR(240, 241, 242, 1);
//    superBigView.layer.cornerRadius = 5;
//    superBigView.layer.masksToBounds = YES;
//    superBigView.layer.borderWidth = 1;
//    superBigView.layer.borderColor = [UIColor colorWithWhite:.5 alpha:.5].CGColor;
    self.circleImage = [CircleImageView circleImageViewWithImage:[UIImage imageNamed:@"2.jpg"] diameter:45];
    self.circleImage.frame = CGRectMake(8, 8, 45, 45); 
    [superBigView addSubview:self.circleImage];
    [self.circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superBigView).with.offset(8);
        make.top.mas_equalTo(superBigView).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    self.ColleagueNick = [UILabel new];
//    [self.ColleagueNick setBackgroundColor:[UIColor blackColor]];
//    self.ColleagueNick.text = @"杨同";
        [superBigView addSubview:self.ColleagueNick];
    [self.ColleagueNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.mas_equalTo(self.circleImage.mas_right).offset(10);
        make.top.equalTo(superBigView).with.offset(10);
    }];
    
    self.timeLabel = [UILabel new];
    
//    self.timeLabel.backgroundColor = [UIColor blueColor];
//    [self.timeLabel setText:@"7分钟前"];
    self.timeLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [superBigView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.bottom.mas_equalTo(self.circleImage.mas_bottom);
        make.left.mas_equalTo(self.ColleagueNick.mas_left);
    }];
    
    
    self.commondButton = [CriticWordView new];  //评论
//    self.commondButton.tag = self.tag;
//    [self.commondButton setBackgroundColor:[UIColor blueColor]];
    self.commondButton.criticIamge.image = [UIImage imageNamed:@"talk"];
    [superBigView addSubview:self.commondButton];
    [self.commondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superBigView.mas_left);
        make.height.mas_equalTo(34.5);
        make.bottom.equalTo(superBigView.mas_bottom);
        make.right.mas_equalTo(superBigView.centerX);
    }];
    
    self.praiseButton = [CriticWordView new];  //点赞
//    [self.praiseButton setBackgroundColor:[UIColor yellowColor]];

    self.praiseButton.criticIamge.image = [UIImage imageNamed:@"DonLike"];
    [superBigView addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(superBigView.mas_right);
        make.left.mas_equalTo(superBigView.mas_centerX);
        make.height.mas_equalTo(34.5);
        make.bottom.equalTo(superBigView.mas_bottom);
    }];
    
    UIView *lineView =[UIView new];
        lineView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [self.praiseButton addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.praiseButton.mas_left);
        make.top.mas_equalTo(self.praiseButton.mas_top).offset(7);
        make.bottom.mas_equalTo(self.praiseButton.mas_bottom).offset(-7);
        make.width.mas_equalTo(.5);
    }];
    
    
    
    
    
    
    UIView *topLineView =[UIView new];
    topLineView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//    topLineView.backgroundColor = [UIColor redColor];
    [superBigView addSubview:topLineView];
    [superBigView bringSubviewToFront:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(superBigView.mas_bottom).offset(-34.0);
        make.height.mas_equalTo(.5);
        make.width.mas_equalTo(400);
        make.left.mas_equalTo(superBigView.mas_left);
    }];
    
    NSInteger temp = arc4random() % 10;
    self.num = temp;
    
    self.wordFrom = [WPHotspotLabel new];
//    self.wordFrom.text = @"来自 动梨基地";
    self.wordFrom.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.wordFrom.font = [UIFont systemFontOfSize:10];
    self.wordFrom.textAlignment = NSTextAlignmentLeft;
    [superBigView addSubview:self.wordFrom];
    
    [self.wordFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_top);
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(7);
        make.width.mas_equalTo(100);
        make.bottom.mas_equalTo(self.timeLabel.mas_bottom);
    }];
    
    self.userInterView = [[UIView alloc]initWithFrame:CGRectMake(DLMultipleWidth(8.0), 64.0, DLMultipleWidth(353.0), 300)];
//    [self.userInterView setBackgroundColor:[UIColor yellowColor]];
    [superBigView addSubview:self.userInterView];
    
    
    [self addSubview:superBigView];
    [superBigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self).with.offset(10);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)builtCommentViewWithSuperView:(UIView *)superView;
{
    
}

- (void)reloadCellWithModel:(CircleContextModel *)model andIndexPath:(NSIndexPath *)indexpath
{
//    [self.circleImage dlGetRouteWebImageWithString:[model.poster objectForKey:@"photo"] placeholderImage:nil];
    self.circleImage.backgroundColor = [UIColor blueColor];
    self.ColleagueNick.text = model.poster.nickname;
    
    [self.timeLabel judgeTimeWithString:model.postDate]; //判断时间
    
    self.praiseButton.tag = indexpath.row + 1;
    [self.wordFrom getCompanyNameFromCid:model.cid];
    self.commondButton.tag = indexpath.row + 1;
    self.praiseButton.criticText.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.commentUsers.count];
    self.commondButton.criticText.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.comments.count];
    if (model.commentUsers) {
        NSLog(@"%@ \n 我的 id 为  %@ ", model.content, userId);
        [self judgeWithArray:model.commentUsers];
    }
}

- (void)judgeWithArray:(NSArray *)array
{
    if ([self judgePraiseWithArray:array]) {
        self.praiseButton.criticIamge.image = [UIImage imageNamed:@"Like"];
    } else
    {
        self.praiseButton.criticIamge.image = [UIImage imageNamed:@"DonLike"];
    }
}


- (BOOL)judgePraiseWithArray:(NSArray *)array
{
    NSLog(@"赞的人有 %@", array);
    if (!userId) {
        userId = [AccountTool account].ID;
    }
    for (NSDictionary *dic in array) {
        NSString *str = [dic objectForKey:@"_id"];
        if ([userId isEqualToString:str]) {
            NSLog(@"我赞过");
            
            return YES;
        }
    }
    return NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:
        {
            NSLog(@"点赞");
            break;
        }
        case 2:{
            NSLog(@"评论");
            
            
            break;
        }
        default:
            break;
    }
}

@end
