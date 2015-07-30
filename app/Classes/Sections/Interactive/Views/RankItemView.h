//
//  RankItemView.h
//  app
//
//  Created by 张加胜 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *LoveImageView;
@property (weak, nonatomic) IBOutlet UILabel *loveCount;

@end
