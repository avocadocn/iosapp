//
//  RankBottomShowView.h
//  app
//
//  Created by 张加胜 on 15/7/30.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankBottomShowView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *love1;
@property (weak, nonatomic) IBOutlet UIImageView *love2;
@property (weak, nonatomic) IBOutlet UIImageView *love3;

@property (nonatomic, strong)UIView *aMaskView;

@property (nonatomic, assign)NSInteger selectNum;

@end
