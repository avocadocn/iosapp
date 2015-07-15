//
//  AvatarCell.m
//  DLDemo
//
//  Created by 张加胜 on 15/7/15.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "AvatarCell.h"
#import "CircleImageView.h"


@interface AvatarCell()
@property(nonatomic ,strong)CircleImageView *imgView;

@end
@implementation AvatarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.imgView = [[CircleImageView alloc]init];
       
        
        [self addSubview:self.imgView];
    }
    return self;
}

-(void)setImg:(UIImage *)img{
    _img = img;
    [self.imgView setImg:img];
    
    
    // 设置圆形头像的起始点坐标
    self.imgView.x = self.width / 2 - self.imgView.width / 2;
    self.imgView.y = self.height / 2 - self.imgView.height / 2;
    
}

@end
