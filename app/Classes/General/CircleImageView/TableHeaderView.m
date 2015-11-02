//
//  TableHeaderView.m
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Person.h"
#import "FMDBSQLiteManager.h"
#import "TableHeaderView.h"
#import "ApertureView.h"
#import <Masonry.h>
#import "UIImageView+DLGetWebImage.h"


@implementation TableHeaderView

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        Person *per=  [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:image];
        
        [self maskImage:per.imageURL];
        [self tableViewHeaderViewWithImage:per];
    }
    return self;
}

- (void)maskImage:(NSString *)image
{
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.frame];
    //下载指定大小的图片
    [backImage dlGetRouteThumbnallWebImageWithString:image placeholderImage:nil withSize:backImage.size];
    [self addSubview:backImage];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.alpha = .8;
    effectview.frame = self.frame;
    effectview.height = self.frame.size.height + 1;
    [self addSubview:effectview];
    
//    UIView *view = [[UIView alloc]initWithFrame:self.frame];
//    UIImage *remp = [UIImage imageNamed:@"mask_sha.jpeg"];
    
//    view.layer.contents = (__bridge id)remp.CGImage;
//    view.alpha = .45;
//    [self addSubview:view];
    
    /*
    self.filter = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
    if (!self.context) {
        self.context = [CIContext contextWithOptions:nil];
    }
    
    [self.filter setValue:[[CIImage alloc] initWithImage:image] forKey:@"inputImage"];
    [self.filter setValue: [[CIImage alloc] initWithImage:[UIImage imageNamed:@"white.jpg"] ] forKey:@"inputMask"];
    [self.filter setValue:@4.f forKey:@"inputRadius"];
    
    CIImage *outputImage = [self.filter outputImage];
    CGImageRef imageRef = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    self.layer.contents = (__bridge id)returnImage.CGImage;
    
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:.2];
    
    [self addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
     
     */
}
- (void)tableViewHeaderViewWithImage:(Person *)image
{
    
//    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    ApertureView *aper = [[ApertureView alloc]initWithFrame:CGRectMake(DLScreenWidth / (375 / 10.0), DLScreenHeight / (667 / 97.0), DLScreenWidth / (375 / 100.00), DLScreenWidth / (375 / 100.00)) andImage:image.imageURL withBorderColor:[UIColor whiteColor]];
    [self addSubview:aper];
    
    self.headerTitleLabel = [UILabel new];
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    self.headerTitleLabel.text = image.nickName;
//    self.headerTitleLabel.attributedText = [self attributeString:per.name];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(aper.mas_bottom).offset(5);
        make.left.mas_equalTo(aper.mas_centerX);
        make.width.mas_equalTo(.5);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    UIView *pointView = [UIView new];
    [pointView setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    pointView.layer.masksToBounds = YES;
    pointView.layer.cornerRadius = 3;
    [self addSubview:pointView];
    
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineView.mas_centerX);
        make.centerY.mas_equalTo(lineView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    [self addSubview:self.headerTitleLabel];
    
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(aper.mas_centerY);
        make.left.mas_equalTo(aper.mas_right).offset(10);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    self.headerSingLabel = [UILabel new];
//    [self.headerSingLabel setBackgroundColor:[UIColor redColor]];
    
//    self.headerSingLabel.attributedText = [self attributeString:@"我捡肥皂, 我骄傲!"];
    self.headerSingLabel.font = [UIFont systemFontOfSize:15];
    self.headerSingLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.headerSingLabel];
    [self.headerSingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerTitleLabel.mas_bottom);
        make.left.mas_equalTo(self.headerTitleLabel.mas_left);
        make.right.mas_equalTo(self.headerTitleLabel.mas_right);
        make.height.mas_equalTo(self.headerTitleLabel.mas_height);
    }];
    
}

- (NSMutableAttributedString *)attributeString:(NSString *)str
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    [att addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithInt:4] range:NSMakeRange(0, str.length)];
    
    return att;
}


@end
