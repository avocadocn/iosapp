//
//  ReportViewController.h
//  app
//
//  Created by tom on 15/11/2.
//  Copyright © 2015年 Donler. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REPORT_TITLE @"title"
#define REPORT_ID @"id"

typedef enum {
    ReportTypePorn,//色情
    ReportTypeSensitiveMessage,//敏感信息
    ReportTypeGarbageSell,//垃圾营销
    ReportTypeFraud,//诈骗
    ReportTypePersonalAttack,//人身攻击
    ReportTypeLeakInformation,//泄露信息
    ReportTypeFakeInformation,//虚假信息
}ReportType;

typedef enum {
    ReportSectionUser,
    ReportSectionActivity,
    ReportSectionHelp,
    ReportSectionVote,
    ReportSectionCircle,
    ReportSectionComment
}ReportSection;

@interface ReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic) ReportSection reportSection;
@property (nonatomic, strong)NSDictionary* data;
@end
