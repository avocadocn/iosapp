//
//  RankItemCell.m
//  app
//
//  Created by 张加胜 on 15/7/22.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RankItemCell.h"


@interface RankItemCell()




@end

@implementation RankItemCell

- (void)awakeFromNib {
    // Initialization code
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle ]loadNibNamed:@"RankItemCell" owner:self options:nil];
        if (nibs.count > 0) {
            self = nibs.firstObject;
            
            
        }
    }
    return self;
}


@end
