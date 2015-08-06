//
//  EventRemindCell.m
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "EventRemindCell.h"
#import <Masonry.h>


@implementation EventRemindCell

//- (void)awakeFromNib {
//    // Initialization code
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self builtInterface];
    }
    return self;
}
- (void)builtInterface
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectButton];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(DLMultipleWidth(11));
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(24.0), DLMultipleWidth(24.0)));
    }];
    
    self.remindTimeLabel = [UILabel new];
    self.remindTimeLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.remindTimeLabel];
    
    [self.remindTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectButton.mas_top);
        make.left.mas_equalTo(self.selectButton.mas_right).offset(12);
        make.width.mas_equalTo(100);
        make.bottom.mas_equalTo(self.selectButton.mas_bottom);
    }];
}
- (void)selectButtonAction:(UIButton *)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"OK"] forState:UIControlStateNormal];
}
- (void)builtInterfaceWithArray:(NSMutableArray *)array andIndexpath:(NSIndexPath *)indexpath
{
    self.remindTimeLabel.text = [array objectAtIndex:indexpath.row];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
