//
//  OtherActivityShowCell.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "OtherActivityShowCell.h"
#import <Masonry.h>

@interface OtherActivityShowCell()


// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation OtherActivityShowCell

- (void)awakeFromNib {
    // Initialization code
     // NSLog(@"-");
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    // NSLog(@"---%@",reuseIdentifier);
    NSArray *nibs = [[NSBundle mainBundle ]loadNibNamed:@"OtherActivityShowCell" owner:self options:nil];
    if (nibs.count > 0) {
        self = nibs.firstObject;
        // self.width = DLScreenWidth;
        // NSLog(@"%@",self.nameLabel);
        // 设置圆角矩形
        [self.backImageView.layer setCornerRadius:4.0f];
        [self.backImageView.layer setMasksToBounds:YES];
           }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
