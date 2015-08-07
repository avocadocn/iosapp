//
//  AttentionViewCell.h
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *AttentionName;
@property (weak, nonatomic) IBOutlet UIImageView *AttentionPhoto;
@property (weak, nonatomic) IBOutlet UILabel *AttentionWork;

- (void)cellBuiltWithModel:(id)model;








@end
