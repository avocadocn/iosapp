//
//  CompanyEmailComplete.h
//  app
//
//  Created by 申家 on 15/7/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyEmailComplete : UIViewController

@property (nonatomic, strong)NSString *inviteKey;
@property (nonatomic, strong)NSString *comEmail;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
//- (instancetype)initWithString:(NSString *)str;

@end
