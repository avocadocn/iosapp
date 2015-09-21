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
#import "FMDBSQLiteManager.h"
#import "Person.h"
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
    Person *person = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:model.poster[@"_id"]];
    self.nameLabel.text = person.name;
    [self.avatar dlGetRouteWebImageWithString:person.imageURL placeholderImage:[UIImage imageNamed:@"icon1"]];
    switch ([model.type integerValue]) {
        case 1:{
            self.InteractiveText.text = model.theme;
            self.InteractiveTitle.text = @"活动进行中";
            self.InteractiveTypeIcon.image = [UIImage imageNamed:@"Rectangle 177 + calendar + Fill 133"];
            break;
        }
        case 2:{
            self.InteractiveText.text = model.theme;
            self.InteractiveTitle.text = @"投票进行中";
            self.InteractiveTypeIcon.image = [UIImage imageNamed:@"Rectangle 177 + chart + Fill 164"];
            break;
        }
        case 3:{
            self.InteractiveText.text = model.content;
            self.InteractiveTitle.text = @"求助进行中";
            self.InteractiveTypeIcon.image = [UIImage imageNamed:@"求助 + Shape Copy 8"];
            break;
        }
        default:
            break;
    }
    
//    [self.InteractiveTypeIcon dlGetRouteWebImageWithString:[NSString stringWithFormat:@"/%@", [[model.photos lastObject] objectForKey:@"uri"] ] placeholderImage:[UIImage imageNamed:@"1"]];
    
    self.publishTimeLabel.text = [model.activity objectForKey:@"startTime"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
