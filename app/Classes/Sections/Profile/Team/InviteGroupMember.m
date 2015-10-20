//
//  InviteGroupMember.m
//  app
//
//  Created by 申家 on 15/9/18.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "AddressViewController.h"
#import "InviteGroupMember.h"
#import "InvatingViewController.h"
#import "GroupDetileModel.h"
@interface InviteGroupMember ()

@end

@implementation InviteGroupMember

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLScreenWidth / (375 / 260.0))];
    image.image = [UIImage imageNamed:@"BG@2X"];
    [self.view addSubview:image];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 +DLScreenWidth / (375 / 260.0) + 30, DLScreenWidth, 21)];
    name.font = [UIFont systemFontOfSize:18];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = self.detileModel.name;
    [self.view addSubview:name];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 64 +DLScreenWidth / (375 / 260.0) + 58, DLScreenWidth - 18 * 2, 42)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB(81, 70, 71);
    label.text = @"快来邀请你的小伙伴加入,成功后一起体验不一样的校园生活!";
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(243, 243, 243, 1);
    
    NSArray *arr = @[@"微信@2x", @"社团@2x", @"手机好友@2x"];
    self.title = @"邀请成员";
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in arr) {
        UIImage *im = [UIImage imageNamed:str];
        [array addObject:im];
    }
    
    CGFloat num = DLMultipleWidth(70.0);
    [self builtInterfaceWithNameArray:@[@"微信好友",@"社团好友",@"手机好友"] imageArray:array andrect:CGRectMake(0, 0, num, num * 1.85) andCenterY:(64 + DLScreenWidth / (375 / 260.0) + 138 + 35 + 20)];
    
}
- (void)builtInterfaceWithNameArray:(NSArray *)nameArray imageArray:(NSArray *)imageArray andrect:(CGRect)rect andCenterY:(NSInteger)num
{
    //    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth * 2, 0, DLScreenWidth, DLScreenHeight)];
    
    int i = 0;
    CGFloat rote = rect.size.width / 2.0333;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(( DLScreenWidth - [nameArray count] * (rect.size.width + rote)) / 2.0, 0, [nameArray count] * (rect.size.width + rote), rect.size.height)];
    
    view.centerY = num;
    
    for (NSString *str in nameArray) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(rote / 2.0 + i * (rect.size.width + rote), 0, rect.size.width, rect.size.width)];
        imageview.image = [imageArray objectAtIndex:i];
        imageview.backgroundColor = [UIColor whiteColor];
        [view addSubview:imageview];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = rect.size.width / 2.0;
        imageview.layer.shadowColor = [UIColor blackColor].CGColor;
        imageview.layer.shadowRadius = 7;
        imageview.layer.shadowOpacity = .51;
        
        imageview.userInteractionEnabled = YES;
        imageview.tag = i + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        
        [imageview addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(rote / 2.0 + i * (rect.size.width + rote), rect.size.height - rote * 2, rect.size.width + 20, rote * 2)];
        label.text = str;
        label.centerX = imageview.centerX;
        label.textAlignment = NSTextAlignmentCenter;
        //        label.backgroundColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        i++;
    }
    [self.view addSubview:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imageViewAction:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 2:
        {
            NSLog(@"社团通讯录");
            AddressViewController *address = [[AddressViewController alloc]init];
            address.detileModel = self.detileModel;
            address.selectState = YES;
            [self.navigationController pushViewController:address animated:YES];
            
        }
            break;
            case 1:
        {
            NSLog(@"微信");
        }break;
            case 3:
        {
            NSLog(@"手机联系人");
            
             InvatingViewController *inter = [[InvatingViewController alloc]init];
            [self.navigationController pushViewController:inter animated:YES];
            
        }break;
        default:
            break;
    }
}

@end
