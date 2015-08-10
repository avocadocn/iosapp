//
//  TableHeaderView.h
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIView

@property (nonatomic, strong)CIFilter *filter;

@property (nonatomic, strong)CIContext *context;

@property (nonatomic, strong)UILabel *headerTitleLabel;

@property (nonatomic, strong)UILabel *headerSingLabel;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

- (void)tableViewHeaderViewWithImage:(UIImage *)image;


@end
