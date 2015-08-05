//
//  CurrentActivitysShowCell.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CurrentActivitysShowCell.h"

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

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//   // NSLog(@"000");
//    NSArray *nibs = [[NSBundle mainBundle ]loadNibNamed:@"CurrentActivitysShowCell" owner:self options:nil];
//    if (nibs.count > 0) {
//        self = nibs.firstObject;
//       
//        
//        UIImage *img = [UIImage imageNamed:@"1"];
//        [self.avatar setImage:img];
//        [self.avatar.layer setCornerRadius:self.avatar.size.height /2];
//        [self.avatar.layer setMasksToBounds:YES];
//        
//    }
//    return self;
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
