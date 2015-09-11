//
//  AcitvitysShowView.m
//  app
//
//  Created by 张加胜 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ActivitysShowView.h"
#import "CircleImageView.h"



@implementation ActivitysShowView

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
        [self setFrame:CGRectMake(0, 0, DLScreenWidth, 100)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 添加item
        [self addOneItemWithImage:[UIImage imageNamed:@"Oval 349 Copy"] label:@"男神榜"];
        [self addOneItemWithImage:[UIImage imageNamed:@"Oval 349"] label:@"女神榜"];
        [self addOneItemWithImage:[UIImage imageNamed:@"Oval 349 Copy 3 + Oval 349 Copy 4"] label:@"社团榜"];
        [self addOneItemWithImage:[UIImage imageNamed:@"Oval 349 Copy 5 + Oval 349 Copy 2"] label:@"热门"];
    }
    return self;
}


-(void)layoutSubviews{
    // NSLog(@"%@",self.subviews[0]);
    
    
    
    // 计算尺寸
    NSUInteger count = self.subviews.count;
    CGFloat width = DLScreenWidth / count;
    CGFloat height = 100;
    CGFloat y = 0;
    for (int i = 0; i < count; i++) {
        CGFloat x = i * width;
        UIButton *btn = self.subviews[i];
        [btn setFrame:CGRectMake(x, y, width, height)];
        [btn setTag:(i + 1) * 100];
        
        CircleImageView *civ = btn.subviews[0];
        civ.centerX = width / 2;
        civ.centerY = height / 2 - 8;
        
        UILabel *label = btn.subviews[1];
        label.centerX = width / 2;
        label.y = CGRectGetMaxY(civ.frame) + 5;
    }
}


-(void)addOneItemWithImage:(UIImage *)image label:(NSString*)text{
  
    
    // itemView
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setBackgroundColor:[UIColor whiteColor]];
    
    // 圆形icon
    CircleImageView *civ = [CircleImageView circleImageViewWithImage:image diameter:70.0f];
    [item addSubview:civ];
    
    // 描述label
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    UIFont *font =[UIFont systemFontOfSize:12.0f];
    [label setFont:font];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,font, nil];
    CGSize size = [text sizeWithAttributes:dict];
    // NSLog(@"%@",NSStringFromCGSize(size));
    label.size = size;
     [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [item addSubview:label];
    
    
    [self addSubview:item];
    [item addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100: // 男神榜
            [self.delegate activitysShowView:self btnClickedByIndex:0];
            break;
            
        case 200: // 女神榜
            [self.delegate activitysShowView:self btnClickedByIndex:1];
            break;
        
        case 300: // 人气榜
            [self.delegate activitysShowView:self btnClickedByIndex:2];
            break;
        
        case 400: // 什么活动
            [self.delegate activitysShowView:self btnClickedByIndex:3];
            break;
            
        default:
            break;
    }

    
}



@end
