//
//  DetailActivityShowView.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DetailActivityShowView.h"

@implementation DetailActivityShowView

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
        [self setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
        [self setBounces:YES];
        [self buildInterface];
    }
    return self;
}


-(void)buildInterface{
    // 顶部带有图片的视图
    UIView *topPictureView = [[UIView alloc]init];
    [topPictureView setBackgroundColor:[UIColor whiteColor]];
   
    // 添加活动图片
    UIImageView *pictureView = [UIImageView new];
    [pictureView setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenWidth * 4/5)];
    [pictureView setBackgroundColor:[UIColor redColor]];
    UIImage *img = [UIImage imageNamed:@"2.jpg"];
    [pictureView setClipsToBounds:YES];
    [pictureView setImage:img];
    [pictureView setContentMode:UIViewContentModeScaleAspectFill];
    
    // 活动名称label
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    UILabel *name = [[UILabel alloc]init];
    name.textColor = [UIColor blackColor];
    [name setFont:font];
    NSString *nameText = @"林肯公园演唱会";
//    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,font, nil];
//    // CGSize size = [nameText sizeWithAttributes:attr];
//    NSLog(@"%@",NSStringFromCGSize(size));
    [name setText:nameText];
    [name setSize:CGSizeMake(DLScreenWidth, 14)];
    [name setTextAlignment:NSTextAlignmentCenter];
    name.centerX = DLScreenWidth / 2;
    name.y = CGRectGetMaxY(pictureView.frame) + 13;
    
    
    
    // 添加感兴趣按钮，需要根据图片自定义
    UIButton *interest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [interest setTitle:@"感兴趣" forState:UIControlStateNormal];
    [interest setSize:CGSizeMake(100, 25)];
    interest.centerX = DLScreenWidth / 2;
    interest.y = CGRectGetMaxY(name.frame) + 13;
    
    [topPictureView addSubview:pictureView];
    [topPictureView addSubview:name];
    [topPictureView addSubview:interest];
    
    // 设置顶部pic view的frame
    topPictureView.height = CGRectGetMaxY(interest.frame) + 13;
    topPictureView.width = DLScreenWidth;
    [topPictureView setOrigin:CGPointZero];
    
    [self addSubview:topPictureView];
    
    // 添加中部时间地址view
    UIView *middleView = [[UIView alloc]init];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    
    // 添加时间label
    UILabel *timeLabel = [[UILabel alloc]init];
    NSString *timeString = [NSString stringWithFormat:@"时间: %@",@"2015.07.23--2015.07.30"];
    
    NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    [mutableAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    [timeLabel setAttributedText:mutableAttrStr];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    
    // 设置label的frame
    [timeLabel setFrame:CGRectMake(10, 15, DLScreenWidth, 30)];
    
    // 添加分割线
    UIView *divisionLine = [[UIView alloc]init];
    [divisionLine setBackgroundColor:[UIColor lightGrayColor]];
    [divisionLine setAlpha:0.3f];
    divisionLine.width = DLScreenWidth - 2 * 9;
    divisionLine.height = 1;
    divisionLine.x = 9;
    divisionLine.y = CGRectGetMaxY(timeLabel.frame);
    
    // 添加地址label
    UILabel *addressLabel = [[UILabel alloc]init];
    //TODO
    
    // 设置中部view的frame
    middleView.y = CGRectGetMaxY(topPictureView.frame) + 12;
    middleView.x = 0;
    middleView.width = DLScreenWidth;
    middleView.height = 300;
    
    
    [middleView addSubview:timeLabel];
    [middleView addSubview:divisionLine];
    [self addSubview:middleView];
    
    // 设置contentoffset
    [self setContentSize:CGSizeMake(DLScreenWidth, CGRectGetMaxY(middleView.frame))];
}

@end
