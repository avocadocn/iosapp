//
//  AcitvitysShowView.m
//  app
//
//  Created by 张加胜 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "AcitvitysShowView.h"
#import "CircleImageView.h"

@implementation AcitvitysShowView

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
        [self addOneItemWithImage:[UIImage imageNamed:@"1"] label:@"男神榜"];
        [self addOneItemWithImage:[UIImage imageNamed:@"1"] label:@"女神榜"];
        [self addOneItemWithImage:[UIImage imageNamed:@"1"] label:@"人气榜"];
        [self addOneItemWithImage:[UIImage imageNamed:@"1"] label:@"什么活动"];
    }
    return self;
}


-(void)layoutSubviews{
    // NSLog(@"%@",self.subviews[0]);
    NSUInteger count = self.subviews.count;
    CGFloat width = DLScreenWidth / count;
    CGFloat height = 100;
    CGFloat y = 0;
    for (int i = 0; i < count; i++) {
        CGFloat x = i * width;
        UIView *view = self.subviews[i];
        [view setFrame:CGRectMake(x, y, width, height)];
        
        CircleImageView *civ = view.subviews[0];
        civ.centerX = width / 2;
        civ.centerY = height / 2 - 8;
        
        UILabel *label = view.subviews[1];
        label.centerX = width / 2;
        label.y = CGRectGetMaxY(civ.frame) + 5;
    }
}


-(void)addOneItemWithImage:(UIImage *)image label:(NSString*)text{
  
    
    // itemView
    UIView *item = [[UIView alloc]init];
    [item setBackgroundColor:[UIColor whiteColor]];
    
    // 圆形icon
    CircleImageView *civ = [CircleImageView circleImageViewWithImage:image diameter:50.0f];
    [item addSubview:civ];
    
    // 描述label
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    UIFont *font =[UIFont systemFontOfSize:11.0f];
    [label setFont:font];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,font, nil];
    CGSize size = [text sizeWithAttributes:dict];
    // NSLog(@"%@",NSStringFromCGSize(size));
    label.size = size;
     [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [item addSubview:label];
    
    
    [self addSubview:item];
    
    
    
}

@end
