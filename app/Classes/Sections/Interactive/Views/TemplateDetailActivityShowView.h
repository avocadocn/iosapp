//
//  TemplateDetailActivityShowView.h
//  app
//
//  Created by tom on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;

@interface TemplateDetailActivityShowView : UIView

@property (nonatomic, strong)Interaction *model;

- (instancetype)initWithModel:(Interaction *)model;

@end
