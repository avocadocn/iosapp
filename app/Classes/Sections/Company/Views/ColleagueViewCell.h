//
//  ColleagueViewCell.h
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColleagueViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ColleaguePhoto;
@property (weak, nonatomic) IBOutlet UILabel *ColleagueNick;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ColleagueWord;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end
