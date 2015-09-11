//
//  DetailActivityShowView.h
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Interaction;

@interface DetailActivityShowView : UIView

@property (nonatomic, strong)Interaction *model;

@property (nonatomic)BOOL orCreatBtn;

- (instancetype)initWithModel:(Interaction *)model;

@end
