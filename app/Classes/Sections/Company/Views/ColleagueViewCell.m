//
//  ColleagueViewCell.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ColleagueViewCell.h"
#import <Masonry.h>
#import "CircleImageView.h"
#import <ReactiveCocoa.h>
#import "CriticWordView.h"



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
    
    UIView *superBigView = [UIView new];  //放 cell上所有小控件的大 view
    [superBigView setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackgroundColor:[UIColor colorWithWhite:.8 alpha:.3]];
    superBigView.layer.cornerRadius = 5;
    superBigView.layer.masksToBounds = YES;
    superBigView.layer.borderWidth = 1;
    superBigView.layer.borderColor = [UIColor colorWithWhite:.5 alpha:.5].CGColor;
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
    self.ColleagueNick.text = @"杨同";
        [superBigView addSubview:self.ColleagueNick];
    [self.ColleagueNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.mas_equalTo(self.circleImage.mas_right).offset(10);
        make.top.equalTo(superBigView).with.offset(10);
    }];
    /*
    self.ColleagueWord = [UILabel new];
    
    self.ColleagueWord.textColor = [UIColor colorWithWhite:.2 alpha:.8];
    self.ColleagueWord.numberOfLines = 0;
    self.ColleagueWord.font = [UIFont systemFontOfSize:14];
    self.ColleagueWord.backgroundColor = [UIColor blackColor];
    self.ColleagueWord.text = @"我的吾水水水水谁谁谁水水水水谁谁谁水水水水水水水水问无为谓吾吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓哇哇哇哇哇哇哇哇问无为谓吾问无吾问无为吾问无为谓问问爱";
    [self.ColleagueWord setTextColor:[UIColor whiteColor]];
    [superBigView addSubview:self.ColleagueWord];
    [self.ColleagueWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.circleImage.mas_left);
        make.right.mas_equalTo(superBigView.mas_right).offset(-10);
        make.top.mas_equalTo(self.circleImage.mas_bottom).offset(5); // 顶部为底部
//        make.height.mas_equalTo(30);
    }];
    
    self.photoView = [UIView new];
    [self.photoView setBackgroundColor:[UIColor greenColor]];
    
    [superBigView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ColleagueWord.mas_bottom).offset(DLMultipleHeight(10.0));
        make.left.mas_equalTo(self.ColleagueWord.mas_left);
        make.right.mas_equalTo(self.ColleagueWord.mas_right);
        make.height.mas_equalTo(DLScreenWidth / 3.0 * self.num);
    }];
    
    */
    /*
    UIView *tempView= [UIView new];
    [tempView setBackgroundColor:[UIColor blackColor]];
    
    [superBigView addSubview:tempView];
    
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ColleagueWord.mas_bottom);
        make.left.mas_equalTo(self.ColleagueWord.mas_left);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(10);
    }];
    */
    self.timeLabel = [UILabel new];
    
//    self.timeLabel.backgroundColor = [UIColor blueColor];
    [self.timeLabel setText:@"7分钟前"];
    self.timeLabel.textColor = [UIColor colorWithWhite:.2 alpha:.5];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [superBigView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.top.mas_equalTo(self.ColleagueNick.mas_bottom);
        make.left.mas_equalTo(self.ColleagueNick.mas_left);
    }];
    
    
    self.commondButton = [CriticWordView new];  //评论
    self.commondButton.tag = 2;
//    [self.commondButton setBackgroundColor:[UIColor blueColor]];
    self.commondButton.criticIamge.image = [UIImage imageNamed:@"talk"];
    [superBigView addSubview:self.commondButton];
    [self.commondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight(40.0), DLMultipleHeight(20.0)));
        make.bottom.equalTo(superBigView.mas_bottom).offset(-5);
        make.right.mas_equalTo(superBigView.mas_right).offset(-10);
    }];
    
    self.praiseButton = [CriticWordView new];  //点赞
//    [self.praiseButton setBackgroundColor:[UIColor yellowColor]];
    self.praiseButton.tag = 1;
    self.praiseButton.criticIamge.image = [UIImage imageNamed:@"DonLike"];
    [superBigView addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.commondButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight(40.0), DLMultipleHeight(20.0)));
        make.bottom.equalTo(self.commondButton.mas_bottom);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *tapPre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.praiseButton addGestureRecognizer:tapPre];
    [self.commondButton addGestureRecognizer:tap];
    
    NSInteger temp = arc4random() % 10;
    self.num = temp;
    
    
    self.wordFrom = [UILabel new];
    self.wordFrom.text = @"来自 动梨基地";
    self.wordFrom.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.wordFrom.font = [UIFont systemFontOfSize:10];
    self.wordFrom.textAlignment = NSTextAlignmentLeft;
    [superBigView addSubview:self.wordFrom];
    
    [self.wordFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.circleImage.mas_left);
        make.right.mas_equalTo(superBigView.centerX);
        make.bottom.mas_equalTo(superBigView.mas_bottom).offset(-5);
    }];
    
    self.userInterView = [[UIView alloc]initWithFrame:CGRectMake(DLMultipleWidth(8.0), DLMultipleHeight(55.0), DLMultipleWidth(353.0), 300)];
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

- (void)reloadCellWithModel:(id)model
{
    NSArray *viewArray =  [self.userInterView subviews];
    for (UIView *aView in viewArray) {
        [aView removeFromSuperview];
    }
    NSArray *array = [model objectForKey:@"array"];
    
    NSInteger inte = DLScreenWidth / 3.5;
    int i = 0;
        for (UIImage *image in array) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i % 3 * (inte + 10), i / 3 * (inte + 10), inte + 5, inte + 5)];
        imageView.image = image;
        [self.photoView addSubview:imageView];
        i++;
    }
    self.photoView.height = inte * (i / 3 + 1);
    self.state = YES;
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
