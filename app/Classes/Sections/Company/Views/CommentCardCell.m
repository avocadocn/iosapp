//
//  CommentCardCell.m
//  app
//
//  Created by 申家 on 15/9/11.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "CommentCardCell.h"
#import "UIImageView+DLGetWebImage.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
@interface CommentCardCell ()


@property (nonatomic, strong)UILabel *numLabel;
@end


@implementation CommentCardCell



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
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(DLScreenWidth  - 60, 0, 60, 60)];
    self.numLabel.textColor = RGBACOLOR(74, 74, 74, 1);
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numLabel];
}

- (void)reloadCellWithPhotoArray:(NSArray *)array
{
    
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld", array.count];

    NSInteger num = (self.frame.size.width - self.frame.size.height - 11) / 40;
    FMDBSQLiteManager *manger = [FMDBSQLiteManager shareSQLiteManager];
    
    int i = 0;
    for (NSDictionary *dic in array) {
        Person *per = [manger selectPersonWithUserId:[dic objectForKey:@"_id"]];
        
        CGFloat width = 40.0;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(11 + i* width, 15, width - 4, width - 4)];
        imageView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
        [imageView dlGetRouteThumbnallWebImageWithString:per.imageURL placeholderImage:nil withSize:imageView.size];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = (width - 4) / 2;
        [self addSubview:imageView];
        if (i == num) {
            break;
        }
        i++;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
