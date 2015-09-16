//
//  RankBottomShowView.m
//  app
//
//  Created by 张加胜 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RankBottomShowView.h"



@implementation RankBottomShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [self.avatar.layer setCornerRadius:self.avatar.width / 2];
    self.avatar.layer.masksToBounds = YES;

    self.aMaskView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth, 0, 150, 60)];
    self.aMaskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.aMaskView];
    
    
//    self.love3.backgroundColor = [UIColor blackColor];
//    
//    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
//    view.backgroundColor = [UIColor blueColor];
//    [self insertSubview:view belowSubview:self.love1];


}

@end
