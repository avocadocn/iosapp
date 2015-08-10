//
//  FolderViewController.m
//  app
//
//  Created by 申家 on 15/8/4.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "FolderViewController.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "CuntomFolderView.h"
#import "DLDatePickerView.h"

static NSInteger num = 0;

@interface FolderViewController ()<DLDatePickerViewDelegate, UIAlertViewDelegate>

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DLSBackgroundColor;
    self.title = @"个人资料";
    
    num = 0;
    [self builtTitleView];  // 设置资料照片
    [self builtInformationView];  //设置资料 label
}

- (void)builtTitleView // 照片和选择照片
{
    CGFloat width = DLScreenWidth / (375.0 / 150.0);
    self.folderPhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake((DLScreenWidth - width) / 2, 75, width, width)];
    self.folderPhotoImage.image = [UIImage imageNamed:@"1"];
    self.folderPhotoImage.layer.masksToBounds = YES;
    self.folderPhotoImage.layer.cornerRadius = width / 2.0;
    [self.view addSubview:self.folderPhotoImage];
    
    [self editFolder];
}

- (void)editFolder  //用户看自己的资料, 允许被编辑
{
    self.editLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    [label setBackgroundColor:[UIColor blackColor]];

    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editButtonAction:)];
    [self.editLabel addGestureRecognizer:tap];
    self.editLabel.text = @"编辑";
    self.editLabel.textAlignment = NSTextAlignmentRight;
    self.editLabel.font = [UIFont systemFontOfSize:15];
    self.editLabel.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editLabel];
    
}
// 编辑按钮
- (void)editButtonAction:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"编辑");
//    for ( *view in self.companyArray) {
    
    for (int i = 0; i < [self.companyArray count]-1; i++) {
        CuntomFolderView *view = [self.companyArray objectAtIndex:i];
        if (self.buttonState == EnumOfEditButtonNo) { //未编辑
            view.informationTextField.userInteractionEnabled = YES;
            view.informationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            NSLog(@"可以被编辑");
        }
        else
        {
            view.informationTextField.userInteractionEnabled = NO;
            NSLog(@"无法编辑");
        }
    }
    if (self.buttonState == EnumOfEditButtonNo) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBrithdayAction:)];
        [self.brithday.informationTextField addGestureRecognizer:tap];
        
        self.buttonState = EnumOfEditButtonYes;
        self.editLabel.text = @"完成";
    } else { //写编辑完成后的网络请求
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"要保存您的修改吗?" message:nil delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        
        [alert show];
        self.editLabel.text = @"编辑";
        self.buttonState = EnumOfEditButtonNo;//编辑完成
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            
            
            
            
            
            
            
            break;
        }
        default:
            break;
    }
}
//点击生日弹出 pickerview
- (void)tapBrithdayAction:(UITapGestureRecognizer *)tap
{
    DLDatePickerView *picker = [[DLDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    picker.delegate = self;
    NSDate *minDate = [self dateFromString:@"1960-01-01"];
    
    NSDate *maxDate = [[NSDate alloc] initWithTimeInterval:- 60 * 60 * 24 * 365 * 3 sinceDate:[NSDate date]];
    [picker reloadWithMaxDate:maxDate minDate:minDate dateMode:UIDatePickerModeDate];
    
    [self.view addSubview:picker];
    [picker show];
}
//pickerview 消失后的方法
- (void)outPutStringOfSelectDate:(NSString *)str withTag:(NSInteger)tag
{
    NSArray *array = [str componentsSeparatedByString:@" "];
    
    self.brithday.informationTextField.text = [array firstObject];
    
    NSString *dateStr = [array firstObject];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    NSString *conste = [self getAstroWithMonth:[[dateArray objectAtIndex:1] intValue] day:[[dateArray objectAtIndex:2] intValue]];
    self.constellation.informationTextField.text = [NSString stringWithFormat:@"%@座",conste];
}

//判断星座
-(NSString *)getAstroWithMonth:(int)m day:(int)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

//根据输入的日期获取时间
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}



- (void)builtInformationView
{
    self.nickName = [CuntomFolderView new];
    self.synopsis = [CuntomFolderView new];
    self.realName = [CuntomFolderView new];
    self.gender = [CuntomFolderView new];
    self.brithday = [CuntomFolderView new];
    self.department = [CuntomFolderView new];
    self.phoneNumber = [CuntomFolderView new];
    self.constellation = [CuntomFolderView new];
    self.companyArray = @[self.nickName, self.synopsis, self.realName, self.gender, self.brithday, self.department, self.phoneNumber, self.constellation];
    NSArray *labelName = @[@"昵       称", @"个人简介", @"真实姓名", @"性       别", @"生       日", @"部       门", @"手机号码", @"星       座"];
    
    
    UIScrollView *scroll = [UIScrollView new];
    scroll.bounces = NO;
    scroll.showsVerticalScrollIndicator = FALSE;
    scroll.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scroll];
    
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.folderPhotoImage.mas_bottom).offset(25);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    for (CuntomFolderView *view in self.companyArray) {
        view.frame = CGRectMake(0, num * 45, DLScreenWidth, 45);
        view.titleLabel.text = [labelName objectAtIndex:num];
        [view setBackgroundColor:[UIColor whiteColor]];
        [scroll addSubview:view];
        num ++;
    }
    scroll.contentSize = CGSizeMake(0, 45 * num);
    
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

@end
