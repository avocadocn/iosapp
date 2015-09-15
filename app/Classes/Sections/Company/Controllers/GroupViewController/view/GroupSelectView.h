//
//  GroupSelectView.h
//  app
//
//  Created by 申家 on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSelectView : UIView


@property (nonatomic, strong)UILabel *tilteLabel;
@property (nonatomic, strong)UILabel *requitLabel;
@property (nonatomic, strong)UISwitch *switchLabel;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title requite:(NSString *)requite;

@end
