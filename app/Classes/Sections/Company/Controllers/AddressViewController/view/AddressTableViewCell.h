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

- (void)sendIndexPath:(NSIndexPath *)indexPath;

//-(void)passValue:(NSString *)phoneNumber;
//-(void)deleteValue:(NSString *)phoneNumber;


@end
@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *personNameLabel;

@property (nonatomic, strong)UILabel *personEmailLabel;

@property (nonatomic, strong)UIImageView *personPhotoImageView;

@property (nonatomic, strong)UIButton *selectButton;

@property (nonatomic, assign)id<addressTableViewDelegate>delegate;

@property (nonatomic, assign)BOOL editState;

@property (nonatomic, assign)BOOL selectButtonState;

@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)cellReloadWithAddressModel:(AddressBookModel *)model;

- (void)reloCellWithAddressBook:(id)person andStateString:(NSString *)str;

@end
