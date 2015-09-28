//
//  SchoolFirstPageCell.m
//  app
//
//  Created by 申家 on 15/9/28.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "UIImageView+DLGetWebImage.h"
#import "SchoolFirstPageCell.h"
#import "SendSchollTableModel.h"
#import "SchoolTempModel.h"
@interface SchoolFirstPageCell ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BigWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BigHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smailWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smailHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smailWidth2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smailHeifht2;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIImageView *TitileImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *smailImage1;
@property (weak, nonatomic) IBOutlet UIImageView *smailImage2;
@property (weak, nonatomic) IBOutlet UIImageView *BigImage;
@property (weak, nonatomic) IBOutlet UIImageView *backArrow;

@end


@implementation SchoolFirstPageCell



- (void)awakeFromNib {
    // Initialization code

    self.backArrow.image = [UIImage imageNamed:@"Back Arrow @2x.png"];
    self.backArrow.clipsToBounds = YES;
    self.backArrow.contentMode = UIViewContentModeCenter;
    
    CGFloat width = (DLScreenWidth - 22) / 3.0 - 1;
    
    self.smailWidth1.constant = self.smailWidth2.constant = self.smailHeight1.constant = self.smailHeifht2.constant = width;
    self.BigWidth.constant = self.BigHeight.constant = width * 2;
    [self.tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)]];
}




- (void)TapAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
            
        case 1:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"JumpController" object:nil userInfo:dic];

        }
            break;
        case 2:
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"跳转" forKey:@"name"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PersonReport" object:nil userInfo:dic];
        }
            break;
            case 3:
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HappyBrithday" object:nil userInfo:nil];
        }
            break;
        default:
            break;
    }
    NSLog(@"点击");
}

- (void)setSchoolModel:(SendSchollTableModel *)schoolModel
{
    NSInteger i = schoolModel.photoArray.count;
    if (i == 1) {
        SchoolTempModel *first = [schoolModel.photoArray objectAtIndex:0];
        [self.BigImage dlGetRouteWebImageWithString:first.photo placeholderImage:nil];
    }
    if (i == 2) {
        SchoolTempModel *first = [schoolModel.photoArray objectAtIndex:0];
        [self.BigImage dlGetRouteWebImageWithString:first.photo placeholderImage:nil];
        SchoolTempModel *second = [schoolModel.photoArray objectAtIndex:1];
        [self.smailImage1 dlGetRouteWebImageWithString:second.photo placeholderImage:nil];
    }
    else {
        SchoolTempModel *first = [schoolModel.photoArray objectAtIndex:0];
        [self.BigImage dlGetRouteWebImageWithString:first.photo placeholderImage:nil];
//        self.BigImage.backgroundColor = [UIColor yellowColor];
        SchoolTempModel *second = [schoolModel.photoArray objectAtIndex:1];
        [self.smailImage1 dlGetRouteWebImageWithString:second.photo placeholderImage:nil];

        SchoolTempModel *teird = [schoolModel.photoArray objectAtIndex:2];
        [self.smailImage2 dlGetRouteWebImageWithString:teird.photo placeholderImage:nil];
    }
    
    
}
- (void)reloadWithIndexpath:(NSIndexPath *)index
{
    NSArray *array= [NSArray arrayWithObjects:@"同事圈",@"新人报道", @"生日祝福" ,nil];
    
    self.TitileImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"company%ld@2x", index.row + 1]];
    self.TitleLabel.text = [array objectAtIndex:index.row];
    
    self.tapView.tag = index.row + 1;


}

@end
