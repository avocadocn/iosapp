//
//  VoteCommentViewCell.h
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentsModel.h"

@interface CommentViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLabelHeight;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong)CommentsModel *commentModel;

@end
