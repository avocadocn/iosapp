//
//  OtherActivityShowCell.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "OtherActivityShowCell.h"
#import <Masonry.h>
#import "UIImageView+DLGetWebImage.h"

@interface OtherActivityShowCell()


// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end

@implementation OtherActivityShowCell

- (void)awakeFromNib {
    // Initialization code
     // NSLog(@"-");
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    // NSLog(@"---%@",reuseIdentifier);
    NSArray *nibs = [[NSBundle mainBundle ]loadNibNamed:@"OtherActivityShowCell" owner:self options:nil];
    if (nibs.count > 0) {
        self = nibs.firstObject;
        
        [self.separator setBackgroundColor:RGB(230, 230, 230)];
        // self.width = DLScreenWidth;
        // NSLog(@"%@",self.nameLabel);
        // 设置圆角矩形
//        [self.backImageView.layer setCornerRadius:4.0f];
//        [self.backImageView.layer setMasksToBounds:YES];
        [self.nameLabel setTextColor:RGB(0x39, 0x37, 0x37)];
        [self.timeLabel setTextColor:RGB(0x9b, 0x9b, 0x9b)];
        [self.addressLabel setTextColor:RGB(0x9b, 0x9b, 0x9b)];
           }
    return self;
}
/*
 * 加载数据
 */
- (void)reloadCellWithModel:(Interaction *)model
{
    //清空垃圾数据
    self.nameLabel.text=@"";
    self.addressLabel.text=@"";
    self.timeLabel.text=@"";
    self.backImageView.image=[UIImage imageNamed:@"OtherActivity_backImage"];
    
    if (model.photos.count!=0) {
        @try {
//            float width = [[[model.photos objectAtIndex:0] objectForKey:@"width"] floatValue];
//            float height = [[[model.photos objectAtIndex:0] objectForKey:@"height"] floatValue];
//            if (width<DLScreenWidth) {
//                height*= DLScreenWidth/width;
//                width=DLScreenWidth;
//            }
//            if (width>DLScreenWidth){
//                height/= width/DLScreenWidth;
//                width=DLScreenWidth;
//            }
            self.backImageView.x=0;
            self.backImageView.y=10;
            self.backImageView.width=DLScreenWidth;
            self.backImageView.height=DLScreenWidth*4/5;
            NSLog(@"backImageView frame-->%@",NSStringFromCGRect(self.backImageView.frame));
//            [self.backImageView dlGetRouteWebImageWithString:[[model.photos objectAtIndex:0] objectForKey:@"uri"] placeholderImage:[UIImage imageNamed:@"OtherActivity_backImage"]];
            [self.backImageView dlGetRouteThumbnallWebImageWithString:[[model.photos objectAtIndex:0] objectForKey:@"uri"] placeholderImage:[UIImage imageNamed:@"OtherActivity_backImage"] withSize:CGSizeMake(DLScreenWidth, DLScreenWidth*4/5)];
        }
        @catch (NSException *exception) {
            NSLog(@"when trying load img error happen:\n%@",exception);
        }
        @finally {
            
        }
        
    }
    if (self.isTemplate) {
        self.nameLabel.text = model.theme;
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self getParsedDateStringFromString:model.startTime],[self getParsedDateStringFromString:model.endTime]];
        self.addressLabel.text = [[model.location keyValues] objectForKey:@"name"];
    }else{
        self.nameLabel.text = model.theme;
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[self getParsedDateStringFromString:[model.activity objectForKey:@"startTime"]],[self getParsedDateStringFromString:model.endTime]];
        self.addressLabel.text = [[model.activity objectForKey:@"location"] objectForKey:@"name"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 *对服务器返回的时间做处理
 * format: xx月xx日
 */
- (NSString*)getParsedDateStringFromString:(NSString*)dateString
{
    if (dateString==nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate * date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"MM月dd日"];
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

@end
