//
//  FillInformationCon.h
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelView.h"

typedef NS_ENUM(NSInteger, EnumUserSex){
    EnumUserSexMan,
    EnumUserSexWoman
};

@interface FillInformationCon : UIViewController


@property (nonatomic, strong)UITextField *nameTextField;

@property (nonatomic ,strong)UIImageView *userPhoto;

@property (nonatomic, strong)LabelView *userName;

@property (nonatomic, strong)LabelView *userGender;

@property (nonatomic, strong)UIButton *manButton;

@property (nonatomic, strong)UIButton *womanButton;

@property (nonatomic, assign)EnumUserSex sex;

@end
