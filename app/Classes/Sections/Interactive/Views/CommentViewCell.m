//
//  VoteCommentViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CommentViewCell.h"


@interface CommentViewCell()


@end

@implementation CommentViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.avatar.layer setCornerRadius:self.avatar.width / 2];
    [self.avatar.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommentModel:(CommentsModel *)commentModel{
    
    // 设置头像
    self.avatar.image  = [UIImage imageNamed:commentModel.avatarUrl];
   
    
    // 设置昵称
    self.name.text = commentModel.name;
   
    
    
    // 设置评论正文
    self.comment.text = commentModel.comment;
    
    
   
    
        CGFloat currentWidth = self.comment.width;
    
        CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
        NSDictionary *attr = @{NSFontAttributeName:self.comment.font};
        CGSize commentLabelSize = [commentModel.comment boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    
        self.commentLabelHeight.constant = commentLabelSize.height;
    
           
    
    
    
    
    
}

@end
