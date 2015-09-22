//
//  AmendGroupName.h
//  app
//
//  Created by 申家 on 15/9/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupDetileModel;
@protocol  AmendGroupNameDelegate<NSObject>

- (void)sendNewName:(NSString *)str;

@end

@interface AmendGroupName : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)id <AmendGroupNameDelegate>delegate;
@property (nonatomic, strong)GroupDetileModel*detileModel;

@end
