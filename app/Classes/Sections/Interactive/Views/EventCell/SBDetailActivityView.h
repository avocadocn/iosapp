//
//  SBDetailActivityView.h
//  app
//
//  Created by burring on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;
@interface SBDetailActivityView : UIView

@property (nonatomic, strong)Interaction *model;

@property (nonatomic)BOOL orCreatBtn;

- (instancetype)initWithModel:(Interaction *)model;

@end

