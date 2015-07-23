//
//  OtherSegmentButton.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "OtherSegmentButton.h"

@implementation OtherSegmentButton

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
        self.size = CGSizeMake(80, 23);
    }
    return self;
}

-(void)setName:(NSString *)name{
    _name = name;
    
    
    // 左侧线段
    UIImage *line = [UIImage imageNamed:@"line"];
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 3, 15)];
    lineView.x = 4;
    lineView.centerY = self.centerY;
    [lineView setImage:line];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.text = name;
    CGFloat offset =CGRectGetMaxX(lineView.frame) + 6;
    [label setFrame:CGRectMake(offset , 0, self.size.width - offset, 23)];
    label.centerY = self.centerY;
    [label setFont:[UIFont systemFontOfSize:15]];
    
    
    
    
    [self addSubview:lineView];
    [self addSubview:label];
}

-(void)layoutSubviews{
    [super layoutSubviews];
   }


@end
