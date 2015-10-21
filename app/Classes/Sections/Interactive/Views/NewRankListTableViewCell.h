//
//  NewRankListTableViewCell.h
//  app
//
//  Created by tom on 15/10/20.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRankListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImg;

@end
