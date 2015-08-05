//
//  TableHeaderView.m
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TableHeaderView.h"
#import "ApertureView.h"


@implementation TableHeaderView

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tableViewHeaderViewWithImage:image];
    }
    return self;
}


- (void)tableViewHeaderViewWithImage:(UIImage *)image
{
    CIFilter *filter = [CIFilter filterWithName:@""];
    [filter setValue:@"image" forKey:@"inputImage"];
    
    self.layer.contents = (__bridge id)image.CGImage;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    ApertureView *aper = [[ApertureView alloc]initWithFrame:CGRectMake(DLScreenWidth / (375 / 12.0), DLScreenHeight / (667 / 97.0), DLScreenWidth / (375 / 100.00), DLScreenWidth / (375 / 100.00)) andImage:image withBorderColor:[UIColor whiteColor]];
    [self addSubview:aper];
    
}


@end
