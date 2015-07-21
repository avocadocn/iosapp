//
//  PhotoCell.m
//  app
//
//  Created by 申家 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PhotoCell.h"
#import "ChoosePhotoController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, TouchEvent)
{
    TouchEventNo,
    TouchEventYes
};

@interface PhotoCell ()
@property (nonatomic, assign)TouchEvent CellTouchState;
@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self builtInterface];
    }
    return self;
}
//搭建界面
- (void)builtInterface
{
    @autoreleasepool {
        ChoosePhotoController *choose = [ChoosePhotoController shareStateOfController];

        self.imageView = [UIImageView new];
        
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
        }];
        
        self.insertButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.insertButton setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
        
        // button 的点击事件
        self.insertButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            NSString *str = choose.selectNumLabel.text;
            NSInteger inte = [str integerValue];
            
            if (self.CellTouchState == TouchEventNo) {  //没有被点击过
                if (inte != 9) {
                    [self.insertButton setBackgroundImage:[UIImage imageNamed:@"OK"] forState:UIControlStateNormal];
                    //  [choose.selectArray insertObject:self.imageView.image atIndex:inte];
                    [choose.selectArray addObject:self.imageView.image];
                    
                    inte ++;
                    NSString *strs = [NSString stringWithFormat:@"%ld", inte];
                    choose.selectNumLabel.text = strs;
                    self.CellTouchState = TouchEventYes;
                }
                else
                 {
                     UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"请选取九张" message: nil
                                                                delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                     [al show];
                 }  //显示提示
            } else  ///被点击过了 要移除
            {
                [self.insertButton setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
                inte --;
                
                
                NSInteger num = 0;
                for (NSInteger  i = 0; i < [choose.selectArray count]; i++) {
                    UIImage *image = [choose.selectArray objectAtIndex:i];
                    if ([image isEqual:self.imageView.image]) {  //是同一张图片
                        
                        NSLog(@"%@", image);
                        num = i;
                        break;
                    }
                }
                
                [choose.selectArray removeObjectAtIndex:num];
                
                NSString * strs = [NSString stringWithFormat:@"%ld", inte];
                choose.selectNumLabel.text = strs; //设置红色标签的文字
                
                self.CellTouchState = TouchEventNo;
            }
            
            return [RACSignal empty];
        }];
        
        [self addSubview:self.insertButton];
        [self.insertButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width / 3.0, self.frame.size.width / 3.0));
        }];
    }
}

@end
