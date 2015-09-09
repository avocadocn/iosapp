//
//  MessageTableViewCell.h
//  app
//
//  Created by burring on 15/9/8.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *projectPicture;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
