//
//  CurrentActivitysShowCell.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CurrentActivitysShowCell.h"

@interface CurrentActivitysShowCell()
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

// 来自
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
// 浏览量
@property (weak, nonatomic) IBOutlet UILabel *glanceNumberLabel;

@end

@implementation CurrentActivitysShowCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   // NSLog(@"000");
    NSArray *nibs = [[NSBundle mainBundle ]loadNibNamed:@"CurrentActivitysShowCell" owner:self options:nil];
    if (nibs.count > 0) {
        self = nibs.firstObject;
        // self.width = DLScreenWidth;
         // NSLog(@"%@",self.nameLabel);
        // 设置圆角矩形
        [self.container.layer setCornerRadius:4.0f];
        [self.container.layer setMasksToBounds:YES];
        
        UIImage *img = [UIImage imageNamed:@"1"];
        [self.avatar setImage:img];
        [self.avatar.layer setCornerRadius:self.avatar.size.height /2];
        [self.avatar.layer setMasksToBounds:YES];
        
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
