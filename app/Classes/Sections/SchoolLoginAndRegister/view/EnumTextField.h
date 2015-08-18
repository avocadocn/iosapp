//
//  EnumTextField.h
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyBoardState){
    KeyBoardStateNo,
    KeyBoardStateYes
};

@interface EnumTextField : UITextField

@property (nonatomic, assign)KeyBoardState keyBorad;

@end
