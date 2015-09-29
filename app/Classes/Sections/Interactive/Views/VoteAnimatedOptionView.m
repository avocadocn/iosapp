//
//  VoteAnimatedOptionView.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteAnimatedOptionView.h"
#import <POP.h>

@interface VoteAnimatedOptionView()

/**
 *  显示百分比的label
 */
@property (nonatomic, strong) UILabel *percentageLabel;



@end

@implementation VoteAnimatedOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = 44;
//        self.backgroundColor = [UIColor greenColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
   
    // 添加按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(0, 0, DLScreenWidth, 40);
    [btn setTitleColor:RGB(57, 161, 255) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    [btn setBackgroundColor:[UIColor blackColor]];
//    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    self.button = btn;

    
    // 添加显示百分比的label
    UILabel *percentageLabel = [[UILabel alloc]init];
    percentageLabel.textColor = [UIColor lightGrayColor];
    UIFont *percentageLabelFont = [UIFont systemFontOfSize:12];
    percentageLabel.font = percentageLabelFont;
    NSString *defaultString = @"100%";
    CGSize maxPercentageLabelSize = CGSizeMake(DLScreenWidth, 12);
    NSDictionary *attr = @{NSFontAttributeName:percentageLabelFont};
    CGSize percentageLabelSize = [defaultString boundingRectWithSize:maxPercentageLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    percentageLabel.size = CGSizeMake(percentageLabelSize.width + 35, percentageLabelSize.height);
    percentageLabel.x = DLScreenWidth - percentageLabelSize.width - 50;
    percentageLabel.textAlignment = NSTextAlignmentRight;
    percentageLabel.centerY = self.centerY;
    [self addSubview:percentageLabel];
    
    self.percentageLabel = percentageLabel;
}

//- (void)btnAction:(UIButton *)sender
//{
//    NSLog(@"点击");
//}

-(void)setOptionPercentage:(NSNumber *)optionPercentage{
//    _optionPercentage = optionPercentage;
    CGFloat fl =[self.optionCount floatValue] / [optionPercentage floatValue];
    
    self.percentageLabel.text = [NSString stringWithFormat:@"%.f%%",fl * 100];
    
    [self openAnimation:fl];
}

- (void)builtInterfaceWithInter:(NSNumber *)num voteCount:(NSNumber *)voteCount
{
    NSLog(@"绘制动画");
    CGFloat tempNum = [num floatValue];
    CGFloat allCount = [voteCount floatValue];
    CGFloat width = 0.0;
    if (tempNum != 0) {
        width = tempNum / allCount * DLScreenWidth + 1;
        self.percentageLabel.text = [NSString stringWithFormat:@"%.1f%%",tempNum / [voteCount floatValue] * 100];
    } else {
        width = 0;
        self.percentageLabel.text = [NSString stringWithFormat:@"0%%"];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 44)];
    view.backgroundColor = self.voteViewColor;
    [self insertSubview:view atIndex:0];
}

/**
 *   画图动画
 */

-(void)openAnimation:(CGFloat)optionPercentage{
    
    NSLog(@"绘制动画");
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    view.backgroundColor = self.voteViewColor;
    [self insertSubview:view atIndex:0];
    
    CGFloat width = optionPercentage * DLScreenWidth;
    
    [UIView animateWithDuration:.5 animations:^{
        view.frame = CGRectMake(0, 0, width, 44);
    }];
    self.button.selected = YES;
    self.button.userInteractionEnabled = NO;
}

-(void)btnClicked:(id)sender{
    
}


-(void)setOptionName:(NSString *)optionName{
    _optionName = optionName;
    [self.button setTitle:optionName forState:UIControlStateNormal];
    [self.button setTitle:optionName forState:UIControlStateSelected];
}


@end
