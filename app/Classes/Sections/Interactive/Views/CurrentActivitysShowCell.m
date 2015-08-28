//
//  CurrentActivitysShowCell.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Interaction.h"
#import "CurrentActivitysShowCell.h"
#import "UIImageView+DLGetWebImage.h"

@interface CurrentActivitysShowCell()
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  发表时间
 */
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

/**
 *  来自
 */
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
/**
 *  人数
 */
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;





/**
 *  分割线
 */
@property (weak, nonatomic) IBOutlet UIView *separator;


/**
 *  交互类型的容器
 */
@property (weak, nonatomic) IBOutlet UIView *typeContainer;


@end

@implementation CurrentActivitysShowCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self.avatar.layer setCornerRadius:self.avatar.width / 2];
    self.avatar.layer.masksToBounds = YES;
    
    // 设置背景色为主题色
    [self.separator setBackgroundColor:RGB(235, 235, 235)];
    [self.typeContainer setBackgroundColor:RGB(235, 235, 235)];
    
}

- (void)reloadCellWithModel:(Interaction *)model
{
//    cell.InteractiveTypeIcon.image = [UIImage imageNamed:@"Interactive_help_icon"];
//    cell.InteractiveTitle.text = @"求助进行中";
//    cell.InteractiveText.text = @"刚锅锅怎么样才会爱我？";

    self.InteractiveText.text = model.theme;
    switch ([model.type integerValue]) {
        case 1:{
            self.InteractiveTitle.text = @"活动进行中";
            break;
        }
        case 2:{
            self.InteractiveTitle.text = @"投票进行中";
            break;
        }
        case 3:{
            self.InteractiveTitle.text = @"求助进行中";
            break;
        }
        default:
            break;
    }
    
//    self.InteractiveTypeIcon.image = [UIImage imageNamed:@"1"];
    [self.InteractiveTypeIcon dlGetRouteWebImageWithString:[NSString stringWithFormat:@"/%@", [[model.photos lastObject] objectForKey:@"uri"] ] placeholderImage:[UIImage imageNamed:@"1"]];
    
    self.publishTimeLabel.text = [model.activity objectForKey:@"startTime"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
