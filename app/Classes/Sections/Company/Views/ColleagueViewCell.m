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
    CircleImageView *imageView = [CircleImageView circleImageViewWithImage:[UIImage imageNamed:@"2.jpg"] diameter:45];
    imageView.frame = CGRectMake(8, 8, 45, 45);
    [superBigView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.top.equalTo(superBigView).with.offset(10);
    }];
    
    self.ColleagueWord = [UILabel new];
//    [self.ColleagueWord setBackgroundColor:[UIColor blueColor]];
    self.ColleagueWord.text = @"一场说走就走的旅行...";
    self.ColleagueWord.textColor = [UIColor colorWithWhite:.2 alpha:.8];
    self.ColleagueWord.font = [UIFont systemFontOfSize:14];
    [superBigView addSubview:self.ColleagueWord];
    [self.ColleagueWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth - imageView.frame.size.width * 2 - 40, 20));
        make.top.mas_equalTo(self.ColleagueNick.mas_bottom); // 顶部为底部
    }];
    
    
    self.timeLabel = [UILabel new];
    
//    self.timeLabel.backgroundColor = [UIColor blueColor];
    [self.timeLabel setText:@"7分钟前"];
    self.timeLabel.textColor = [UIColor colorWithWhite:.2 alpha:.5];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [superBigView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.top.mas_equalTo(superBigView).with.offset(10);
        make.right.mas_equalTo(superBigView.mas_right).with.offset(-8);
    }];
    
    self.praiseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.praiseButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        // button avtion...
        return [RACSignal empty];
    }];
    [self.praiseButton setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.2]];

    [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    [superBigView addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superBigView.mas_left);
        make.size.mas_equalTo(CGSizeMake((DLScreenWidth - 20) / 2, 40));
        
        make.bottom.equalTo(superBigView).with.offset(0);
    }];
    self.commondButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commondButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        // button avtion...
        return [RACSignal empty];
    }];
    [self.commondButton setTitle:@"发表评论" forState: UIControlStateNormal];
    [self.commondButton setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.2]];

    [superBigView addSubview:self.commondButton];
    [self.commondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((DLScreenWidth - 20) / 2, 40));
        make.bottom.equalTo(superBigView).with.offset(0);
        make.left.mas_equalTo(self.praiseButton.mas_right);
    }];
    NSInteger temp = arc4random() % 10;
    self.num = temp;
    if (self.num != 0) { // 有照片
        for (NSInteger i = 0; i < self.num; i++) {
            @autoreleasepool {
            UIImage *image = [UIImage imageNamed:@"2.jpg"];
            NSInteger inte = DLScreenWidth / 5;
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(62 + i % 3 * (inte + 10), inte + i / 3 * (inte + 10), inte + 5 , inte + 5)];
            imageview.image = image;
            [superBigView addSubview:imageview];
            }
        }
    }
    [self addSubview:superBigView];
    [superBigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(10);
        make.right.mas_equalTo(self).with.offset(-10);
        make.top.mas_equalTo(self).with.offset(10);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)reloadCellWithModel:(id)model
{
    
}

@end
