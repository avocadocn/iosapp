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
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.font = [UIFont systemFontOfSize:14];
    [self setTitle:name forState:UIControlStateNormal];
    [self setTitle:name forState:UIControlStateHighlighted];
    UIImage *leftImage =  [UIImage imageNamed:@"line"];
    [self setImage:leftImage forState:UIControlStateNormal];
    [self setImage:leftImage forState:UIControlStateHighlighted];
    [self setBackgroundColor:[UIColor whiteColor]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
     // zNSLog(@"%@",NSStringFromUIEdgeInsets(self.imageEdgeInsets));
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
}


@end
