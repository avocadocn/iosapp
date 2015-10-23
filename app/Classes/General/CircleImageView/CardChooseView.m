//
//  CardChooseView.m
//  app
//
//  Created by 太阳 on 15/7/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CardChooseView.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

static NSInteger height = 45;

/*  The Height of CardChooseView's cell;
 */

@implementation CardChooseView

- (instancetype)initWithTitleArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        [self builtInterfaceWithArray:array];
    }
    return self;
}

- (void)builtInterfaceWithArray:(NSArray *)array
{
    @autoreleasepool {
        self.frame = CGRectMake(0, DLScreenHeight, DLScreenWidth, ([array count] + 1) * height + 5);
        
        if (!self.cardFontNum) {
            self.cardFontNum = 17;
        }
        if (!self.appearTime)
        {
            self.appearTime = 0.5f;
        }
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];  //取消按钮点击事件
        [self.cancelButton setTitle:@"取消" forState: UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        self.cancelButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            [self.delegate CardDissmiss];
            [UIView animateWithDuration:.3 animations:^{
                self.maskView.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self.appearTime animations:^{
                    self.center = CGPointMake(DLScreenWidth / 2.0, DLScreenHeight + self.frame.size.height );  // 坐标移动
                } completion:^(BOOL finished) {
                    [self.maskView removeFromSuperview];
                    [self removeFromSuperview];
                }];
            }];
            
            return [RACSignal empty];
        }];
        [self addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(height);
        }];
        self.backgroundColor = DLSBackgroundColor;
        int j = 0;
        
        //  添加小 button
        for (NSInteger i = [array count] - 1; i >= 0; i--) {  //倒叙排列
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [self addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.cancelButton.mas_top).offset(-5 - i * height);
                make.left.mas_equalTo(self.cancelButton.mas_left);
                make.right.mas_equalTo(self.cancelButton.mas_right);
                make.height.mas_equalTo(height - 1);
            }];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitle:[array objectAtIndex:j] forState:UIControlStateNormal];
            button.tag = j + 1;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            button.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                [self.delegate cardActionWithButton:button];
                [self disappear];
//                [self.delegate CardDissmiss];
                return [RACSignal empty];
            }];
            [self addSubview:button];
            j++;
        }
        self.maskView = [UIView new];
        self.maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
        [self.maskView addGestureRecognizer:tap];
        [self.maskView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)show
{
    [self.superview addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo((DLScreenHeight) - self.frame.size.height);
    }];
    
    [UIView animateWithDuration:self.appearTime animations:^{
        self.center = CGPointMake(self.frame.size.width / 2.0, (DLScreenHeight ) - self.frame.size.height / 2.0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            [self.maskView setBackgroundColor:[UIColor colorWithWhite:.1 alpha:.5]];
        }];
    }];
}

- (void)disappear
{
    [self.delegate CardDissmiss];
    [UIView animateWithDuration:.3 animations:^{
        self.maskView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.appearTime animations:^{
            self.center = CGPointMake(DLScreenWidth / 2.0, DLScreenHeight + self.frame.size.height );  // 坐标移动
            
            
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }];
}




@end
