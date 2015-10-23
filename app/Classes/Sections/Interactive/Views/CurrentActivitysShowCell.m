//
//  CurrentActivitysShowCell.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Interaction.h"
#import "CurrentActivitysShowCell.h"
#import "UIImageView+DLGetWebImage.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "UILabel+DLTimeLabel.h"
@interface CurrentActivitysShowCell()
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  发表时间
 */
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

/**
 *  来自
 */
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
/**
 *  人数
 */
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;





/**
 *  分割线
 */
@property (weak, nonatomic) IBOutlet UIView *separator;


/**
 *  交互类型的容器
 */
@property (weak, nonatomic) IBOutlet UIView *typeContainer;


@end

@implementation CurrentActivitysShowCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self.avatar.layer setCornerRadius:self.avatar.width / 2.0];
    self.avatar.layer.masksToBounds = YES;
    
    // 设置背景色为主题色
    [self.separator setBackgroundColor:RGB(235, 235, 235)];
    [self.typeContainer setBackgroundColor:RGB(242, 242, 242)];
    
}

- (void)reloadCellWithModel:(Interaction *)model
{
    self.peopleCountLabel.text = [NSString stringWithFormat:@"参加:%ld",model.members.count];
    Person *person = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:model.poster[@"_id"]];
    self.nameLabel.text = person.name;
    [self.avatar dlGetRouteThumbnallWebImageWithString:person.imageURL placeholderImage:nil withSize:CGSizeMake(50.0, 50.0)];
    switch ([model.type integerValue]) {
        case 1:{
            self.InteractiveText.text = model.theme;
            self.InteractiveTitle.text = @"活动进行中";
            self.publishTimeLabel.text = [self getParsedDateStringFromString:[model.activity objectForKey:@"startTime"]];
            self.InteractiveTypeIcon.image = [UIImage imageNamed:@"Rectangle 177 + calendar + Fill 133"];
            break;
        }
        case 2:{
            self.InteractiveText.text = model.theme;
            self.publishTimeLabel.text = [self getParsedDateStringFromString:model.createTime];
            self.InteractiveTitle.text = @"投票进行中";
            self.InteractiveTypeIcon.image = [UIImage imageNamed:@"Rectangle 177 + chart + Fill 164"];
            break;
        }
        case 3:{
            self.InteractiveText.text = model.content;
            self.publishTimeLabel.text = [self getParsedDateStringFromString:model.createTime];
            self.InteractiveTitle.text = @"求助进行中";
            self.InteractiveTypeIcon.image = [UIImage imageNamed:@"求助 + Shape Copy 8"];
            break;
        }
    }

//    [self.fromLabel getCompanyNameFromCid:model.cid]; 
    self.fromLabel.text = person.companyName;
}

- (NSString*)getParsedDateStringFromString:(NSString*)dateString
{
    if (dateString==nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate * date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString* str = [formatter stringFromDate:date];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    str = [formatter stringFromDate:destinationDateNow];
    return str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
