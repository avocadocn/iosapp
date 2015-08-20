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
        self.width = DLScreenWidth;
        self.height = 44;
        
        [self setupView];
    }
    return self;
}

- (void)setupView{
   
    // 添加按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = self.frame;
    [btn setTitleColor:RGB(57, 161, 255) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(235, 235, 235) forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor clearColor]];
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
    percentageLabel.size = percentageLabelSize;
    percentageLabel.x = DLScreenWidth - percentageLabelSize.width - 8;
    percentageLabel.centerY = self.centerY;
    [self addSubview:percentageLabel];
    
    self.percentageLabel = percentageLabel;
}

//- (void)btnAction:(UIButton *)sender
//{
//    NSLog(@"点击");
//}

-(void)setOptionPercentage:(NSInteger)optionPercentage{
//    _optionPercentage = optionPercentage;
    self.percentageLabel.text = [NSString stringWithFormat:@"%zd%%",optionPercentage];
    
    [self openAnimation:optionPercentage];
}

- (void)builtInterfaceWithInter:(NSInteger)num
{
    CGFloat width = num / 100.0 * DLScreenWidth;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 44)];
    view.backgroundColor = self.voteViewColor;
    [self insertSubview:view atIndex:0];
}

/**
 *   画图动画
 */

-(void)openAnimation:(NSInteger)optionPercentage{
    /*
    
    // 定义aPath
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(1, 0)];
    [aPath addLineToPoint:CGPointMake(1, 44)];
    [aPath addLineToPoint:CGPointMake(0, 44)];
    [aPath closePath];
    
    // 定义bPath
    CGFloat width = optionPercentage / 100.0 * DLScreenWidth;
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    [bPath moveToPoint:CGPointMake(0, 0)];
    [bPath addLineToPoint:CGPointMake(width, 0)];
    [bPath addLineToPoint:CGPointMake(width, 44)];
    [bPath addLineToPoint:CGPointMake(0, 44)];
    [bPath closePath];
    
    // 画出图形
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.drawsAsynchronously = YES;
    shape.frame = self.frame;
    shape.path = aPath.CGPath;
    shape.lineWidth = 0;
    shape.lineCap = kCALineCapRound;
    shape.lineJoin = kCALineJoinRound;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.fillColor = DLRandomColor.CGColor;
//    [self.layer addSublayer:shape];
    
    [self.layer insertSublayer:shape atIndex:0];
    
    // aPath to bPath
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)aPath.CGPath;
    pathAnimation.toValue = (id)bPath.CGPath;
    pathAnimation.duration = 0.5f;
    pathAnimation.autoreverses = NO;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shape addAnimation:pathAnimation forKey:@"animationKey"];
    
    shape.path = bPath.CGPath;
    */
    CGFloat width = optionPercentage / 100.0 * DLScreenWidth;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    view.backgroundColor = self.voteViewColor;
    [self insertSubview:view atIndex:0];

    [UIView animateWithDuration:.5 animations:^{
        view.frame = CGRectMake(0, 0, width, 44);
    }];
}

-(void)btnClicked:(id)sender{
   }


-(void)setOptionName:(NSString *)optionName{
    _optionName = optionName;
    [self.button setTitle:optionName forState:UIControlStateNormal];
    [self.button setTitle:optionName forState:UIControlStateSelected];
}


@end
