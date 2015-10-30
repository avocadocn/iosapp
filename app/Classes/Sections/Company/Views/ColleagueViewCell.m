//
//  ColleagueViewCell.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "NSString+WPAttributedMarkup.h"
#import "WPHotspotLabel.h"
#import "WPAttributedStyleAction.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "WPHotspotLabel.h"
#import "AddressBookModel.h"
#import "ColleagueViewCell.h"
#import <Masonry.h>
#import "CircleImageView.h"
#import <ReactiveCocoa.h>
#import "CriticWordView.h"
#import "CircleContextModel.h"
#import "UIImageView+DLGetWebImage.h"
#import "UILabel+DLTimeLabel.h"
#import "Account.h"
#import "AccountTool.h"


#define LABELWIDTH 355.0
#define TEXTFONT 16
#define REPLYTEXT 14

@interface ColleagueViewCell ()



@end

static NSString *userId = nil;
@implementation ColleagueViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self builtInterface];
    }
    return self;
}
- (void)builtInterface
{
    UIView *superBigView = [UIView new];  //容器
    [superBigView setBackgroundColor:[UIColor whiteColor]];
    
    self.backgroundColor = RGBACOLOR(240, 241, 242, 1);

    self.circleImage = [CircleImageView circleImageViewWithImage:[UIImage imageNamed:@"2.jpg"] diameter:45];
    self.circleImage.userInteractionEnabled = YES;
    self.circleImage.frame = CGRectMake(8, 8, 45, 45); 
    [superBigView addSubview:self.circleImage];
    [self.circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superBigView).with.offset(8);
        make.top.mas_equalTo(superBigView).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    self.ColleagueNick = [UILabel new];
        [superBigView addSubview:self.ColleagueNick];
    [self.ColleagueNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.mas_equalTo(self.circleImage.mas_right).offset(10);
        make.top.equalTo(superBigView).with.offset(10);
    }];
    
    self.timeLabel = [UILabel new];
    
//    self.timeLabel.backgroundColor = [UIColor blueColor];
//    [self.timeLabel setText:@"7分钟前"];
    self.timeLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [superBigView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.bottom.mas_equalTo(self.circleImage.mas_bottom);
        make.left.mas_equalTo(self.ColleagueNick.mas_left);
    }];
    
    
    self.commondButton = [CriticWordView new];  //评论
//    self.commondButton.tag = self.tag;
//    [self.commondButton setBackgroundColor:[UIColor blueColor]];
    self.commondButton.criticIamge.image = [UIImage imageNamed:@"talk"];
    [superBigView addSubview:self.commondButton];
    [self.commondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superBigView.mas_left);
        make.height.mas_equalTo(34.5);
        make.bottom.equalTo(superBigView.mas_bottom);
        make.right.mas_equalTo(superBigView.centerX);
    }];
    
    self.praiseButton = [CriticWordView new];  //点赞
//    [self.praiseButton setBackgroundColor:[UIColor yellowColor]];

    self.praiseButton.criticIamge.image = [UIImage imageNamed:@"DonLike"];
    [superBigView addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(superBigView.mas_right);
        make.left.mas_equalTo(superBigView.mas_centerX);
        make.height.mas_equalTo(34.5);
        make.bottom.equalTo(superBigView.mas_bottom);
    }];
    
    UIView *lineView =[UIView new];
        lineView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    [self.praiseButton addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.praiseButton.mas_left);
        make.top.mas_equalTo(self.praiseButton.mas_top).offset(7);
        make.bottom.mas_equalTo(self.praiseButton.mas_bottom).offset(-7);
        make.width.mas_equalTo(.5);
    }];
    
    
    
    
    
    
    UIView *topLineView =[UIView new];
    topLineView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
//    topLineView.backgroundColor = [UIColor redColor];
    [superBigView addSubview:topLineView];
    [superBigView bringSubviewToFront:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(superBigView.mas_bottom).offset(-34.0);
        make.height.mas_equalTo(.5);
        make.width.mas_equalTo(400);
        make.left.mas_equalTo(superBigView.mas_left);
    }];
    
    NSInteger temp = arc4random() % 10;
    self.num = temp;
    
    self.wordFrom = [WPHotspotLabel new];
//    self.wordFrom.text = @"来自 动梨基地";
    self.wordFrom.textColor = [UIColor colorWithWhite:.5 alpha:1];
    self.wordFrom.font = [UIFont systemFontOfSize:10];
    self.wordFrom.textAlignment = NSTextAlignmentLeft;
    [superBigView addSubview:self.wordFrom];
    
    [self.wordFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_top);
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(7);
        make.width.mas_equalTo(100);
        make.bottom.mas_equalTo(self.timeLabel.mas_bottom);
    }];
    
    self.userInterView = [[UIView alloc]initWithFrame:CGRectMake(DLMultipleWidth(8.0), 64.0, DLMultipleWidth(353.0), 300)];
//    [self.userInterView setBackgroundColor:[UIColor yellowColor]];
    [superBigView addSubview:self.userInterView];
    
    // 删除按钮
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
    [superBigView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superBigView.mas_top);
        make.right.mas_equalTo(superBigView.mas_right);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    self.deleteButton.alpha = 0;
    
    [self addSubview:superBigView];
    [superBigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self).with.offset(10);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)builtCommentViewWithSuperView:(UIView *)superView;
{
    
}

- (void)reloadCellWithModel:(CircleContextModel *)model andIndexPath:(NSIndexPath *)indexpath
{

    Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:model.postUserId];
    
    [self.circleImage dlGetRouteWebImageWithString:per.imageURL placeholderImage:nil];
    
//    self.circleImage.backgroundColor = [UIColor blueColor];
    self.circleImage.tag = indexpath.row + 11111;
    self.ColleagueNick.text = per.name;
    
    [self.timeLabel judgeTimeWithString:model.postDate]; //判断时间
    
    self.praiseButton.tag = indexpath.row + 1;
    [self.wordFrom getCompanyNameFromCid:model.postUserId];
    self.commondButton.tag = indexpath.row + 1;
    self.praiseButton.criticText.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.commentUsers.count];
    self.commondButton.criticText.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.comments.count];
    if (model.commentUsers) {
        NSLog(@"%@ \n 我的 id 为  %@ ", model.content, userId);
        [self judgeWithArray:model.commentUsers];
    }
}


//- (void)drawRect:(CGRect)rect
//{
//    NSLog(@"绘制");
//    Person *per = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:self.model.postUserId];
//    
//    [self.circleImage dlGetRouteWebImageWithString:per.imageURL placeholderImage:nil];
//    
//    //    self.circleImage.backgroundColor = [UIColor blueColor];
//    self.circleImage.tag = self.indexPath.row + 11111;
//    self.ColleagueNick.text = per.name;
//    
//    [self.timeLabel judgeTimeWithString:self.model.postDate]; //判断时间
//    
//    self.praiseButton.tag = self.indexPath.row + 1;
//    [self.wordFrom getCompanyNameFromCid:self.model.postUserId];
//    self.commondButton.tag = self.indexPath.row + 1;
//    self.praiseButton.criticText.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.model.commentUsers.count];
//    self.commondButton.criticText.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.model.comments.count];
//    if (self.model.commentUsers) {
//        NSLog(@"%@ \n 我的 id 为  %@ ", self.model.content, userId);
//        [self judgeWithArray:self.model.commentUsers];
//    }
//    [self.userInterView insertSubview:self.tempView atIndex:0];
//
//}
- (void)judgeWithArray:(NSArray *)array
{
    if ([self judgePraiseWithArray:array]) {
        self.praiseButton.criticIamge.image = [UIImage imageNamed:@"Like"];
    } else
    {
        self.praiseButton.criticIamge.image = [UIImage imageNamed:@"DonLike"];
    }
}

- (BOOL)judgePraiseWithArray:(NSArray *)array
{
    NSLog(@"赞的人有 %@", array);
    if (!userId) {
        userId = [AccountTool account].ID;
    }
    for (NSDictionary *dic in array) {
        NSString *str = [dic objectForKey:@"_id"];
        if ([userId isEqualToString:str]) {
            NSLog(@"我赞过");
            
            return YES;
        }
    }
    return NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:
        {
            NSLog(@"点赞");
            break;
        }
        case 2:{
            NSLog(@"评论");
            
            
            break;
        }
        default:
            break;
    }
}


- (void)getViewWithModel:(CircleContextModel *)model andTag:(NSInteger)tag
{
    
    
    NSInteger overHeight = 0;
    UIView *view = [[UIView alloc]init];
    view.tag = tag += 10001;
    
    UIView *modelDetileView = [[UIView alloc]init];
    
    NSString *contentStr = model.content;
//    NSLog(@"用户发表的文字为 %@", contentStr);
    
    if (contentStr){
        
        UILabel *label = [self getLabelFromString:contentStr andHeight:overHeight];
        UILabel *detileLabel = [self getLabelFromString:contentStr andHeight:overHeight];
        
        [modelDetileView addSubview:detileLabel];
        [view addSubview:label];
        overHeight += label.frame.size.height ;
    }
    
    CGFloat width = DLMultipleWidth(87.0);
    
    NSArray *array = model.photos;//图片 array
    NSInteger picNum = [array count];
    CGFloat picHeight = 0;
    if (picNum == 1) {
        width = DLMultipleWidth(166.0);
        picHeight = width;
    }
    if (picNum != 0 && picNum != 1) {
        NSLog(@"图片有 %ld 张", (long)picNum);
        picHeight = ((picNum + 2) / 3 )  * width; //图片view的高
    }
    int b = 0;
    NSMutableArray *tempPhotoArray = [NSMutableArray array];
    for (NSDictionary *imageDic in array) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, (overHeight + 2) + b / 3 * width, width - 6, width - 6)];
        [imageView dlGetRouteWebImageWithString:[NSString stringWithFormat:@"/%@", [imageDic objectForKey:@"uri"]] placeholderImage:nil];
        //            imageView.backgroundColor = [UIColor orangeColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        imageView.tag = b + 1;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)]];
        
        [view addSubview:imageView];
        UIImageView *detileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, (overHeight + 2) + b / 3 * width, width - 6, width - 6)];
        detileImageView.image = [self OriginImage:imageView.image scaleToSize:imageView.size];
        detileImageView.backgroundColor = [UIColor yellowColor];
        detileImageView.contentMode = UIViewContentModeScaleAspectFill;
        detileImageView.clipsToBounds = YES;
        [detileImageView dlGetRouteWebImageWithString:[NSString stringWithFormat:@"/%@", [imageDic objectForKey:@"uri"]] placeholderImage:nil];
        
        //            detileImageView.image = [UIImage imageNamed:@"1"];
        
        //            [imageView.rac_willDeallocSignal subscribeNext:^(UIImage *image) {
        //                if (image) {
        //                    NSLog(@"已获得图片");
        //                }
        //            }];
        
        [modelDetileView addSubview:detileImageView];
        [tempPhotoArray addObject:[NSString stringWithFormat:@"/%@", [imageDic objectForKey:@"uri"]]];
        b++;
    }
    if (!tempPhotoArray.count) {
        [tempPhotoArray addObject:@"空的"];
    }
//    [self.photoArray addObject:tempPhotoArray];
    overHeight += picHeight;
    
//    modelDetileView.frame = CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), overHeight);
    
    [model setDetileView:modelDetileView];
    
    NSMutableArray *interArray = model.comments;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (CircleContextModel *interTempDic in interArray) {  //评论
        
        NSString *str = interTempDic.content;
        NSLog(@"得到的评论详情为 %@", str);
        if (str) {
            
            CGFloat tempWidth = 5;
            CGRect rect = [self getRectWithFont:[UIFont systemFontOfSize:REPLYTEXT] width:DLMultipleWidth(LABELWIDTH) - tempWidth andString:str];
            WPHotspotLabel *interLabel = [[WPHotspotLabel alloc]initWithFrame:CGRectMake(tempWidth, 0, DLMultipleWidth(LABELWIDTH) - tempWidth, rect.size.height + 6)];
            interLabel.numberOfLines = 0;
            NSDictionary *style4 = @{@"body":[UIFont systemFontOfSize:REPLYTEXT],
                                     @"abody":@[RGBACOLOR(80, 125, 175, 1) ,[WPAttributedStyleAction styledActionWithAction:^{
                                         [self jumpPageWithDic:interTempDic andPoster:@"poster"];
                                     }]]
                                     ,
                                     @"myBody":@[RGBACOLOR(51, 51, 51, 1),[WPAttributedStyleAction styledActionWithAction:^{
//                                         [self.myText becomeFirstResponder];
//                                         [self.inputTextView becomeFirstResponder];
//                                         self.object = CommentReviewers;
//                                         self.inputTextView.text = nil;
//                                         self.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@:", interTempDic.poster.nickname];
//                                         tergetUserId = interTempDic.poster.ID;
//                                         contentId = interTempDic.targetContentId;
//                                         self.selectIndex = [NSNumber numberWithInteger:(tag - 10000)] ;

                                         NSLog(@"this is my body");
                                     }]],
                                     @"postBody":@[RGBACOLOR(80, 125, 175, 1) ,[WPAttributedStyleAction styledActionWithAction:^{
                                         [self jumpPageWithDic:interTempDic andPoster:@"target"];
                                     }]]
                                     };
            interLabel.font = [UIFont systemFontOfSize:REPLYTEXT];
            BOOL tempState = [interTempDic.isOnlyToContent boolValue];
            if (tempState){
                
                NSString *attStr = [NSString stringWithFormat:@"<abody>%@</abody>:<myBody>%@</myBody>", interTempDic.poster.nickname, str];
                interLabel.attributedText = [attStr attributedStringWithStyleBook:style4];
            } else
            {
                NSString *att = [NSString stringWithFormat:@"<abody>%@</abody>回复<postBody>%@</postBody>:<myBody>%@</myBody>",interTempDic.poster.nickname, interTempDic.target.nickname, interTempDic.content];
                interLabel.attributedText = [att attributedStringWithStyleBook:style4];
            }
            
            //            [interLabel sizeToFit];
            //            interLabel.backgroundColor = RGBACOLOR(247, 247, 247, 1);
            UIView *aTempView = [[UIView alloc]initWithFrame:CGRectMake(0, overHeight + 6, DLMultipleWidth(LABELWIDTH), rect.size.height + 6)];
            [aTempView addSubview:interLabel];
            aTempView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
            
            [view addSubview:aTempView];
            overHeight += rect.size.height + 3;
        } else
        {
            [tempArray addObject:interTempDic];
        }
        
    }
    [interArray removeObjectsInArray:tempArray];
    view.frame = CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), overHeight);
    NSDictionary *viewDic = [NSDictionary dictionaryWithObjects:@[view, [NSString stringWithFormat:@"%ld", (long)overHeight]] forKeys:@[@"view", @"height"]];
    
    NSArray *viewArray = [self.userInterView subviews];
    for (id view in viewArray) {
        [view removeFromSuperview];
    }
    [self.userInterView addSubview:view];
    
    
//    [self.userInterArray addObject:viewDic];
    //        tempI ++;
    
}





- (UILabel *)getLabelFromString:(NSString *)contentStr andHeight:(CGFloat)overHeight
{
    CGRect rect = [self getRectWithFont:[UIFont systemFontOfSize:TEXTFONT] width:DLMultipleWidth(LABELWIDTH) andString:contentStr];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(LABELWIDTH), rect.size.height )];
    label.numberOfLines = 0;
    //            label.backgroundColor = [UIColor greenColor];
    label.text = contentStr;
    label.font = [UIFont systemFontOfSize:TEXTFONT];
    return label;
}

- (CGRect)getRectWithFont:(UIFont *)font width:(CGFloat)num andString:(NSString *)string
{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(num, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}

-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)jumpPageWithDic:(CircleContextModel *)dic andPoster:(NSString *)string
{
//    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
//    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    //    AddressBookModel *model = [[AddressBookModel alloc]init];
//    //    [model setValuesForKeysWithDictionary:[dic objectForKey:string]];
//    
//    coll.model = [[AddressBookModel alloc]init];
//    coll.model = dic.poster;
//    [self.navigationController pushViewController:coll animated:YES];
    NSLog(@"跳跃");
}

- (void)setModel:(CircleContextModel *)model
{
    _model = model;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}
- (void)setTempView:(UIView *)tempView
{
    _tempView = tempView;
}

@end
