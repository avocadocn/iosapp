//
//  VoteInfoTableViewModel.h
//  app
//
//  Created by burring on 15/9/23.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteInfoTableViewModel : NSObject

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *index;

@property (nonatomic, copy) NSString * value;

@property (nonatomic, strong)NSArray *voters;
@end
