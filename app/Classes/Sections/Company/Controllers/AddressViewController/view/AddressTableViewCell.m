//
//  AddressTableViewCell.m
//  app
//
//  Created by 申家 on 15/8/3.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import <AddressBookUI/AddressBookUI.h>
#import "AddressTableViewCell.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "AddressBookModel.h"
#import "UIImageView+DLGetWebImage.h"

@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self builtnterFaceWithSelectButton];
    }
    return self;
}

- (void)builtnterFaceWithSelectButton
{
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self addSubview:self.selectButton];
//    [self.selectButton setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"NO.png"] forState:UIControlStateNormal];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.height - 20, self.height - 20));
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
    [self.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.personPhotoImageView = [UIImageView new];
    
    self.personPhotoImageView.layer.masksToBounds = YES;
    self.personPhotoImageView.layer.cornerRadius = 50 / 2.0;
    
    [self addSubview:self.personPhotoImageView];
//    [self.personPhotoImageView setBackgroundColor:[UIColor blackColor]];
    
    [self.personPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.width.mas_equalTo(50);
    }];
    
    self.personNameLabel = [UILabel new];
//    self.personNameLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.personNameLabel];
    [self.personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personPhotoImageView.mas_top).offset(5);
        make.left.mas_equalTo(self.personPhotoImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    self.personEmailLabel = [UILabel new];
//    self.personEmailLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:self.personEmailLabel];
    
    [self.personEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.personNameLabel.mas_bottom);
        make.left.mas_equalTo(self.personNameLabel.mas_left);
        make.right.mas_equalTo(self.personNameLabel.mas_right);
        make.height.mas_equalTo(self.personNameLabel.mas_height);
    }];
//  选中图片OK.png,未选中图片2.png
    
}
- (void)selectButtonAction:(UIButton *)sender
{
    if (self.selectButtonState) { // 被选中了
        self.selectButtonState = NO;
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
    } else {
        self.selectButtonState = YES;
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    }
    [self.delegate sendIndexPath:self.indexPath];

}
- (void)cellReloadWithAddressModel:(AddressBookModel *)model
{
    [self.personPhotoImageView dlGetRouteThumbnallWebImageWithString:model.photo placeholderImage:[UIImage imageNamed:@"1"] withSize:CGSizeMake(50.0, 50.0)];
    self.personPhotoImageView.layer.masksToBounds = (self.frame.size.width - 10 )/ 2.0;
    self.personEmailLabel.text = model.phone;
    self.personNameLabel.text = model.realname;
    if (model.selectState) {
        
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    } else {
        
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)reloCellWithAddressBook:(id)person andStateString:(NSString *)str
{
    
    NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty); // FirstName
    NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);// LastName
    //    phoneNumber
    ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
    NSData *userImage=(__bridge NSData*)(ABPersonCopyImageData((__bridge ABRecordRef)(person))); //获取当前联系人头像图片
    if (userImage != nil) {
        self.personPhotoImageView.image = [UIImage imageWithData:userImage];
    } else {
        self.personPhotoImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
    {
        NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
        if (tmpPhoneIndex.length >= 13) {
            self.personEmailLabel.text = tmpPhoneIndex;
            
        }else {
        }
    }
    
    if (tmpLastName && tmpFirstName) {   // lastname 不一定有
        self.personNameLabel.text = [NSString stringWithFormat:@"%@ %@",tmpFirstName,tmpLastName];
    } else if (tmpFirstName){
        self.personNameLabel.text = [NSString stringWithFormat:@"%@",tmpFirstName];
    } else {
        self.personNameLabel.text = [NSString stringWithFormat:@"%@",tmpLastName];
    }
    
    switch ([str integerValue]) {
        case 0:{//未被选中
            self.selectButtonState = NO;
            [self.selectButton setBackgroundImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
            break;
        }
            case 1://选中
        {
            self.selectButtonState = YES;
            [self.selectButton setBackgroundImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
}

- (void)setEditState:(BOOL)editState
{
    if (!editState) {
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset (- 25);
        }];
    }
}

- (void)setMyModel:(AddressBookModel *)myModel
{
    self.personNameLabel.text = myModel.realname;
    self.personEmailLabel.text = myModel.phone;
    
    if (myModel.selectState) {
        self.selectButtonState = YES;
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    } else
    {
        self.selectButtonState = NO;
        [self.selectButton setBackgroundImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
    }
    
    if (myModel.imageData != nil) {
        self.personPhotoImageView.image = [UIImage imageWithData:myModel.imageData];
    } else {
        self.personPhotoImageView.image = [UIImage imageNamed:@"placeholder"]; //心机boy
    }
}

@end
