//
//  VerifiCodeController.h
//  app
//
//  Created by 申家 on 15/8/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifiCodeController : UIViewController
@property (nonatomic, strong)UILabel *phoneNumber;

@property (nonatomic, strong)UILabel *requestAgain;

@property (nonatomic, strong)NSTimer *myTimer;

@end
