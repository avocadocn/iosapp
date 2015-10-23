//
//  TableHeaderView.h
//  app
//
//  Created by 申家 on 15/8/5.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;
@interface TableHeaderView : UIView

@property (nonatomic, strong)CIFilter *filter;

@property (nonatomic, strong)CIContext *context;

@property (nonatomic, strong)UILabel *headerTitleLabel;

@property (nonatomic, strong)UILabel *headerSingLabel;

@property (nonatomic, strong)AddressBookModel *userModel;

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image;

- (void)tableViewHeaderViewWithImage:(Person *)image;

@end
