//
//  FolderViewController.h
//  app
//
//  Created by 申家 on 15/8/4.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CuntomFolderView.h"

typedef NS_ENUM(NSInteger, EnumOfEditButton) {
    EnumOfEditButtonNo,
    EnumOfEditButtonYes
};

@interface FolderViewController : UIViewController

@property (nonatomic, strong)UILabel *editLabel;

@property (nonatomic, assign)EnumOfEditButton buttonState;

@property (nonatomic, strong)UIImageView *folderPhotoImage;  //照片

@property (nonatomic, strong)UIButton *selectPhotoButton;

@property (nonatomic, strong)CuntomFolderView *nickName;//昵称

@property (nonatomic, strong)CuntomFolderView *synopsis;//简介

@property (nonatomic, strong)CuntomFolderView *realName;//真实姓名

@property (nonatomic, strong)CuntomFolderView *gender;//性别

@property (nonatomic, strong)CuntomFolderView *brithday;//生日

@property (nonatomic, strong)CuntomFolderView *department;//部门

@property (nonatomic, strong)CuntomFolderView *phoneNumber;//手机号码

@property (nonatomic, strong)CuntomFolderView *constellation;//星座

@property (nonatomic, strong)UITableView *informationTableView;

@property (nonatomic, strong)NSArray *companyArray;

@property (nonatomic, strong)UIScrollView *scroll;


@end
