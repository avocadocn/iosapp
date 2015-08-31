//
//  VoteCommentsModel.h
//  app
//
//  Created by 张加胜 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject


/**
 *  昵称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatarUrl;
/**
 *  评论
 */
@property (nonatomic, copy) NSString *comment;





@end
