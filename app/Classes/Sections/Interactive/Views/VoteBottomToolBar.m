//
//  VoteBottomToolBar.m
//  app
//
//  Created by 张加胜 on 15/8/12.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "VoteBottomToolBar.h"

@implementation VoteBottomToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    NSArray *nibs =  [[NSBundle mainBundle]loadNibNamed:@"VoteBottomToolBar" owner:self options:nil];
    self = [nibs firstObject];
   
    return self;
}

@end
