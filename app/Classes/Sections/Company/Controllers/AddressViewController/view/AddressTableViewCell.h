//
//  AddressTableViewCell.h
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressBookModel;
@protocol addressTableViewDelegate <NSObject>
-(void)passValue:(NSString *)phoneNumber;

@end
@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *personNameLabel;

@property (nonatomic, strong)UILabel *personEmailLabel;

@property (nonatomic, strong)UIImageView *personPhotoImageView;

@property (nonatomic, strong)UIButton *selectButton;

@property (nonatomic, assign)id<addressTableViewDelegate>delegate;
- (void)cellReloadWithAddressModel:(AddressBookModel *)model;

@end
