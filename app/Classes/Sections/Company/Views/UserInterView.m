//
//  UserInterView.m
//  app
//
//  Created by 申家 on 15/8/14.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "UserInterView.h"
#define labelWeith self.frame.size.width

static NSInteger textFont = 15;

@implementation UserInterView

- (instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterfaceWithDic:dic];
    }
    return self;
}

- (void)builtInterfaceWithDic:(NSDictionary *)dic
{
    NSString *str = [dic objectForKey:@"word"];
    SHLUILabel *label = [[SHLUILabel alloc]init];

    label.text = str;
    label.font = [UIFont systemFontOfSize:textFont];
    //得到了高
    CGFloat hei = [label getAttributedStringHeightWidthValue:labelWeith];
    
    
    
}


@end
