//
//  HelpTableViewCell.h
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpCellFrame.h"
@class Interaction;
@interface HelpTableViewCell : UITableViewCell


/**
 *  投票的尺寸
 */
@property (nonatomic, strong) HelpCellFrame *helpCellFrame;

@property (nonatomic) Boolean isTemplate;
@property (nonatomic, strong)Interaction *model;
@property UIViewController* context;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTemplate:(Boolean)isTemplate;
@end
