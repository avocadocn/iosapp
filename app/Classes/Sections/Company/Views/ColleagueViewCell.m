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
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:.5 alpha:.5].CGColor;
    CircleImageView *imageView = [CircleImageView circleImageViewWithImage:[UIImage imageNamed:@"2.jpg"] diameter:45];
    imageView.frame = CGRectMake(8, 8, 45, 45);
    [self addSubview:imageView];
    
    self.ColleagueNick = [UILabel new];
//    [self.ColleagueNick setBackgroundColor:[UIColor blackColor]];
    self.ColleagueNick.text = @"杨同";
        [self addSubview:self.ColleagueNick];
    [self.ColleagueNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.top.equalTo(self).with.offset(10);
    }];
    
    self.ColleagueWord = [UILabel new];
//    [self.ColleagueWord setBackgroundColor:[UIColor blueColor]];
    self.ColleagueWord.text = @"一场说走就走的旅行...";
    self.ColleagueWord.textColor = [UIColor colorWithWhite:.2 alpha:.8];
    self.ColleagueWord.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.ColleagueWord];
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
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.top.mas_equalTo(self).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-8);
    }];
    
    self.praiseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.praiseButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        // button avtion...
        return [RACSignal empty];
    }];
    [self.praiseButton setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.2]];
    [self.praiseButton setTitle:@"赞" forState:UIControlStateNormal];
    [self addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width / 2, 40));
        make.bottom.equalTo(self).with.offset(0);
    }];
    self.commondButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commondButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        // button avtion...
        return [RACSignal empty];
    }];
    [self.commondButton setTitle:@"发表评论" forState: UIControlStateNormal];
    [self.commondButton setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.2]];
    [self addSubview:self.commondButton];
    [self.commondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width / 2, 40));
        make.bottom.equalTo(self).with.offset(0);
        make.left.mas_equalTo(self.praiseButton.mas_right);
    }];
    int temp = arc4random() % 10;
    
    if (temp != 0) { // 有照片
        for (int i = 0; i < temp; i++) {
            UIImage *image = [UIImage imageNamed:@"2.jpg"];
            NSInteger inte = 75;
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(62 + i % 3 * (inte + 10), inte + i / 3 * (inte + 10), inte + 5 , inte + 5)];
            imageview.image = image;
            [self addSubview:imageview];
        }
    }
}

//- (void)awakeFromNib {
//    // Initialization code
//    
//    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"collCell" owner:nil options:nil];
//    NSLog(@"%@", array);
//    
//    
//}

@end
