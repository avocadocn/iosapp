//
//  CurrentActivitysShowCell.h
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Interaction;

@interface CurrentActivitysShowCell : UITableViewCell

/**
 *  互动类型的imageview
 */
@property (weak, nonatomic) IBOutlet UIImageView *InteractiveTypeIcon;

/**
 *  互动标题
 */
@property (weak, nonatomic) IBOutlet UILabel *InteractiveTitle;

/**
 *  互动正文内容
 */
@property (weak, nonatomic) IBOutlet UILabel *InteractiveText;


- (void)reloadCellWithModel:(id)model;


@end

