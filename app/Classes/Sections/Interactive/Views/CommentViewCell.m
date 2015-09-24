//
//  VoteCommentViewCell.m
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "CircleContextModel.h"
#import "CommentViewCell.h"
#import "UIImageView+DLGetWebImage.h"
#import "CircleCommentModel.h"
#import "AddressBookModel.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "CommentsModel.h"
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

-(void)setCommentModel:(CircleContextModel *)commentModel{
    
    NSLog(@"%@",commentModel.poster);
        NSLog(@"%@",commentModel.poster);
   Person *p = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:commentModel.poster.ID];
//
////    // 设置头像
    [self.avatar dlGetRouteWebImageWithString:p.imageURL placeholderImage:[UIImage imageNamed:@"boy"]];
//
//    [self.avatar dlGetRouteWebImageWithString:commentModel.poster.photo placeholderImage:nil];
////
//    // 设置昵称
    self.name.text = p.name;
//
    
    // 设置评论正文
    self.comment.text = commentModel.content;
    
    CGFloat currentWidth = self.comment.width;
    
    CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
    NSDictionary *attr = @{NSFontAttributeName:self.comment.font};
    CGSize commentLabelSize = [commentModel.content boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    self.commentLabelHeight.constant = commentLabelSize.height;
    
}
- (void)setModel:(CommentsModel *)model {
    if (model.posterId != nil) {
        Person *p = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:model.posterId];
        ////    // 设置头像
        [self.avatar dlGetRouteWebImageWithString:p.imageURL placeholderImage:[UIImage imageNamed:@"boy"]];
        //
        //    [self.avatar dlGetRouteWebImageWithString:commentModel.poster.photo placeholderImage:nil];
        ////
        //    // 设置昵称
        self.name.text = p.name;
        // 设置评论正文
        self.comment.text = model.content;
        
        CGFloat currentWidth = self.comment.width;
        
        CGSize maxCommentLabelSize = CGSizeMake(currentWidth, MAXFLOAT);
        NSDictionary *attr = @{NSFontAttributeName:self.comment.font};
        CGSize commentLabelSize = [model.content boundingRectWithSize:maxCommentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
        
        self.commentLabelHeight.constant = commentLabelSize.height;

    }
    
}

@end
