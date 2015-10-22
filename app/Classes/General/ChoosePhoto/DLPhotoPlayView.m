//
//  DLPhotoPlayView.m
//  app
//
//  Created by 申家 on 15/10/22.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import "DLPhotoPlayView.h"

@implementation DLPhotoPlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStartFrame:(CGSize)frame andImageArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        [self builtInterFace];
    }
    return self;
}

- (void)builtInterFace
{
    
}
@end
