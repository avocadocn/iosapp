//
//  LaunchEventController.m
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "DNImagePickerController.h"
#import "LaunchEventController.h"
#import "EventRemindCell.h"
#import <Masonry.h>
#import "DLDatePickerView.h"
#import "IndexpathButton.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RestfulAPIRequestTool.h"
#import "Interaction.h"
#import "AccountTool.h"
#import "Account.h"
#import "Singletons.h"
#import "getIntroModel.h"
static NSInteger num = 0;

typedef NS_ENUM(NSInteger, RemindTableState){
    RemindTableStateNo,
    RemindTableStateYes
};

@interface LaunchEventController ()<DLDatePickerViewDelegate, UITableViewDataSource, UITableViewDelegate, DNImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)UIImage *image;

@property (nonatomic, assign)RemindTableState state;

@property (nonatomic, strong)UILabel *startTimeField;

@property (nonatomic, strong)UILabel *overTimeLabel;

@property (nonatomic, strong)UIImageView *myImageView;

@property (nonatomic, strong)UITextField *eventNameField;

@end

@implementation LaunchEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeFlaseValue];
    [self setNevigationLeft];
    [self builtBigScroll];
    [self builtEventCover];
    [self builtEventDetails];
    [self builtEventRemindTime];
    
}

- (void)setNevigationLeft
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    label.text = @"下一步";
    label.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextController:)];
        label.userInteractionEnabled = YES;
    [label addGestureRecognizer:labelTap];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];

}

- (void)nextController:(UITapGestureRecognizer *)tap
{
    Interaction *inter = [[Interaction alloc]init];
    
    [inter setTheme:self.eventNameField.text];
    [inter setStartTime:self.startTimeField.text];
    [inter setEndTime:self.overTimeLabel.text];
    [inter setLocation:@"上海"];
    [inter setContent:self.eventDetailTextView.text];
    [inter setRemindTime:self.startTimeField.text];
    
    Account *acc = [AccountTool account];
    [inter setTarget:acc.cid];
    [inter setTargetType:@3];
    [inter setType:@1];
    [inter setActivityMold:@"lalal"];
    
    if (self.image){
    NSData *data = UIImagePNGRepresentation(self.image);
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[data ,@"photo"] forKeys:@[@"data", @"name"]];
    inter.photo = [NSArray arrayWithObjects:dic, nil];
    }
    [RestfulAPIRequestTool routeName:@"sendInteraction" requestModel:inter useKeys:@[@"type", @"target", @"relatedTeam", @"targetType", @"templateId", @"inviters",@"photo", @"theme", @"content", @"endTime", @"startTime", @"deadline", @"remindTime", @"activityMold", @"location", @"latitude", @"longitude", @"memberMax", @"memberMin", @"option", @"tags"] success:^(id json) {
        NSLog(@" 生成活动成功%@",json);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发布成功"message:@"少年郎,你的活动已经发布成功了,好好准备吧..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertV show];

    } failure:^(id errorJson) {
        NSLog(@"失败 %@", errorJson);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发布失败" message:[errorJson objectForKey:@"msg"] delegate:self cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
    }];
}
#pragma UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KPOSTNAME" object:nil userInfo:@{@"name":@"家豪"}];
    }
    
}

- (void)makeFlaseValue
{
    self.remindTitleArray = [NSMutableArray arrayWithObjects:@"没有提醒",@"10分钟前",@"30分钟前",@"1小时前",@"2小时前",@"1天前",@"2天前", nil];
}

- (void)builtBigScroll
{
    self.title = @"发布活动";
    
    self.eventScroll = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.eventScroll setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.9]];
    self.eventScroll.contentSize = CGSizeMake(0, DLScreenHeight);
    
    [self.view addSubview:self.eventScroll];
}


- (void)builtEventCover
{
    
    self.superView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLMultipleHeight(150.0))];
    [self.superView setBackgroundColor:[UIColor whiteColor]];
    
    [self.eventScroll addSubview:self.superView];
    
    UILabel *eventname = [UILabel new];
    eventname.text = @"活动名称";
    eventname.font = [UIFont systemFontOfSize:15];
    NSString *eventStr = [NSString stringWithFormat:@"%@", @"活动名称"];
    
    CGRect eventNameRect = [eventStr boundingRectWithSize:CGSizeMake(1000000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    [self.superView addSubview:eventname];
    [eventname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.superView.mas_top).offset(DLScreenHeight / (667 / 12));
        make.left.mas_equalTo(self.superView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(eventNameRect.size.width, 20));
    }];
    
    self.eventNameField = [UITextField new];  //活动名称
    self.eventNameField.textAlignment = NSTextAlignmentCenter;
    [self.superView addSubview:self.eventNameField];
    [self.eventNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(eventname.mas_top);
        make.bottom.mas_equalTo(eventname.mas_bottom);
        make.left.mas_equalTo(eventname.mas_right);
        make.right.mas_equalTo(self.superView.mas_right);
    }];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth / (375 / 11.0), DLScreenHeight / (667 / 49.0), DLScreenWidth, .5)];
    [view setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [self.superView addSubview:view];
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.chooseButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.chooseButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.superView addSubview:self.chooseButton];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(DLScreenHeight / (667 / 11.0));
        make.left.mas_equalTo(eventname.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLScreenWidth / (375 / 80.0), DLScreenWidth / (375 / 80.0)));
    }];
    
    
    UIView *timeLine = [UIView new];
    [timeLine setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    
    [self.superView addSubview:timeLine];
    [timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.chooseButton.mas_centerY);
        make.left.mas_equalTo(self.chooseButton.mas_right).offset(15);
        make.right.mas_equalTo(self.superView.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    UILabel *startLabel = [UILabel new];
    startLabel.font = [UIFont systemFontOfSize:15];
    startLabel.text = @"开始时间";
    [self.superView addSubview:startLabel];
    
    NSString * startTimeStr = [NSString stringWithFormat:@"%@", @"开始时间"];
    CGRect startLabelRect = [startTimeStr boundingRectWithSize:CGSizeMake(10000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(timeLine.mas_top);
        make.left.mas_equalTo(timeLine.mas_left);
        make.width.mas_equalTo(startLabelRect.size.width);
        make.top.mas_equalTo(self.chooseButton.mas_top);
        
    }];
    
    UILabel *overTime = [UILabel new];
    overTime.text = @"结束时间";
    overTime.font = [UIFont systemFontOfSize:15];
    
    [self.superView addSubview:overTime];
    [overTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLine.mas_bottom);
        make.left.mas_equalTo(timeLine.mas_left);
        make.right.mas_equalTo(startLabel.mas_right);
        make.bottom.mas_equalTo(self.chooseButton.mas_bottom);
    }];
    
    
    self.startTimeField = [UILabel new];  // 开始时间
    self.startTimeField.tag = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
    self.startTimeField.userInteractionEnabled = YES;
    [self.startTimeField addGestureRecognizer:tap];
    self.startTimeField.textAlignment = NSTextAlignmentCenter;
    [self.superView addSubview:self.startTimeField];
    
    [self.startTimeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chooseButton.mas_top);
        make.left.mas_equalTo(startLabel.mas_right);
        make.bottom.mas_equalTo(timeLine.mas_top);
        make.right.mas_equalTo(self.superView.mas_right);
    }];
    
    self.overTimeLabel = [UILabel new];  //结束时间
    self.overTimeLabel.tag = 2;
    UITapGestureRecognizer *tapOver = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabelAction:)];
    [self.overTimeLabel addGestureRecognizer:tapOver];
    self.overTimeLabel.userInteractionEnabled = YES;
    self.overTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.superView addSubview:self.overTimeLabel];
    
    [self.overTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLine.mas_top);
        make.left.mas_equalTo(self.startTimeField.mas_left);
        make.right.mas_equalTo(self.startTimeField.mas_right);
        make.bottom.mas_equalTo(self.chooseButton.mas_bottom);
    }];
    
}

- (void)builtEventDetails  // 活动地点
{
    self.detailsView = [UIView new];
    
    [self.detailsView setBackgroundColor:[UIColor whiteColor]];
    [self.eventScroll addSubview:self.detailsView];
    [self.detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.superView.mas_bottom).offset(DLMultipleHeight(15));
        make.left.mas_equalTo(self.superView.mas_left);
        make.right.mas_equalTo(self.superView.mas_right);
        make.height.mas_equalTo(DLMultipleHeight(150.0));
    }];
    
    UILabel *eventAddreess = [UILabel new];
    eventAddreess.text = @"活动地点";
    eventAddreess.font = [UIFont systemFontOfSize:15];
    NSString *eventStr = [NSString stringWithFormat:@"%@", @"活动名称"];
    
    CGRect eventNameRect = [eventStr boundingRectWithSize:CGSizeMake(1000000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    [self.detailsView addSubview:eventAddreess];
    [eventAddreess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailsView.mas_top).offset(DLScreenHeight / (667 / 12));
        make.left.mas_equalTo(self.detailsView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(eventNameRect.size.width, 20));
    }];
    
    UIButton *addressButton  =[UIButton buttonWithType:UIButtonTypeSystem];
    [addressButton addTarget:self action:@selector(AddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailsView addSubview:addressButton];
    
    [addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailsView.mas_top);
        make.right.mas_equalTo(self.detailsView.mas_right);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight(49.0), DLMultipleHeight(49.0)));
    }];;
    
    UIImageView *imageView = [UIImageView new];
    [addressButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(addressButton.mas_centerX);
        make.centerY.mas_equalTo(addressButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight((49 / 2.5)), DLMultipleHeight((49 / 2.5))));
    }];
    
    imageView.image = [UIImage imageNamed:@"address"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth / (375 / 11.0), DLScreenHeight / (667 / 49.0), DLScreenWidth, .5)];
    [view setBackgroundColor:[UIColor colorWithWhite:.5 alpha:.5]];
    [self.detailsView addSubview:view];
    
    
    UILabel *eventIntro = [UILabel new];
    eventIntro.text = @"活动简介";
    eventIntro.font = [UIFont systemFontOfSize:15];
    
    [self.detailsView addSubview:eventIntro];
    [eventIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).offset(DLScreenHeight / (667 / 12));
        make.left.mas_equalTo(self.detailsView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(eventNameRect.size.width, 20));
    }];
    
    self.eventDetailTextView = [UITextView new];
    self.eventDetailTextView.text = @"介绍一下你的活动吧~ ~";
    
    [self.detailsView addSubview:self.eventDetailTextView];
    
    [self.eventDetailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(eventIntro.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(eventIntro.mas_left);
        make.right.mas_equalTo(self.detailsView.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.detailsView.mas_bottom).mas_offset(-5);
    }];
}

- (void)builtEventRemindTime
{
    self.remindView = [[UIView alloc]initWithFrame:CGRectMake(0, DLMultipleHeight(327.0), DLScreenWidth, DLMultipleHeight(50.0))];
    [self.remindView setBackgroundColor:[UIColor whiteColor]];
    
    [self.eventScroll addSubview:self.remindView];
    
//    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.detailsView.mas_bottom).offset(DLMultipleHeight(15));
//        make.left.mas_equalTo(self.superView.mas_left);
//        make.right.mas_equalTo(self.superView.mas_right);
//        make.height.mas_equalTo(DLMultipleHeight(50.0));
//    }];
    
    UILabel *remind = [UILabel new];
    remind.text = @"提醒";
    remind.font = [UIFont systemFontOfSize:15];
    NSString *eventStr = [NSString stringWithFormat:@"%@", @"活动"];
    
    CGRect eventNameRect = [eventStr boundingRectWithSize:CGSizeMake(1000000, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    [self.remindView addSubview:remind];
    [remind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindView.mas_top).offset(DLScreenHeight / (667 / 12));
        make.left.mas_equalTo(self.remindView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(eventNameRect.size.width, 20));
    }];
    
    UIButton *foldButton  =[UIButton buttonWithType:UIButtonTypeSystem];
    [foldButton addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.remindView addSubview:foldButton];
    
    [foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindView.mas_top);
        make.right.mas_equalTo(self.remindView.mas_right);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight(49.0), DLMultipleHeight(49.0)));
    }];;
    
    self.myImageView = [UIImageView new];
    [foldButton addSubview:self.myImageView];
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(foldButton.mas_centerX);
        make.centerY.mas_equalTo(foldButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight((49 / 2.5)), DLMultipleHeight((49 / 2.5))));
    }];
    
    self.myImageView.image = [UIImage imageNamed:@"fold"];
    self.myImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    self.state = RemindTableStateNo;
    
    self.tableView = [[UIView alloc]initWithFrame:CGRectMake(0, DLMultipleHeight(50.0), DLScreenWidth, 0)];
    
    
    [self.remindView addSubview:self.tableView];
}



- (void)foldButtonAction:(UIButton *)sender
{
    if (self.state == RemindTableStateNo) {
        
        [UIView animateWithDuration:.4 animations:^{
            
            self.remindView.height = DLMultipleHeight(400.0);
            [self builtTable];
            self.tableView.frame = CGRectMake(0, DLMultipleHeight(50.0), DLScreenWidth, DLMultipleHeight(350.0));
            self.eventScroll.contentSize = CGSizeMake(0, DLMultipleHeight(720.0));
            //大scroll
            self.myImageView.transform = CGAffineTransformMakeRotation(M_PI / 45.0);
        }];
        self.state = RemindTableStateYes;
    }
    else {
        [UIView animateWithDuration:.4 animations:^{
            
            
            self.remindView.height = DLMultipleHeight(50.0);
            self.tableView.frame = CGRectMake(0, DLMultipleHeight(50.0), DLScreenWidth, 0);
            self.eventScroll.contentSize = CGSizeMake(0, DLMultipleHeight(667));
            
            NSArray *array = [self.tableView subviews];
            for (id view in array) {
                [view removeFromSuperview];
            }
        }];
        self.state = RemindTableStateNo;
    }
}

- (void)builtTable{
    NSInteger i = 0;
    
    for (NSString *str in self.remindTitleArray) {
        UIView *smailview = [UIView new];
        smailview.frame = CGRectMake(0, i * DLMultipleHeight(50.0), DLScreenWidth, DLMultipleHeight(50.0));
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
        selectButton.tag = i + 100;
        [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        smailview.tag = i + 200;
        [smailview addSubview: selectButton];
        
        
        UILabel * remindTimeLabel = [UILabel new];
        remindTimeLabel.text = str;
        remindTimeLabel.font = [UIFont systemFontOfSize:15];
        
        [smailview addSubview:remindTimeLabel];
        i++;
        
        [self.tableView addSubview:smailview];
        //         [smailview setBackgroundColor:[UIColor redColor]];
        //         smailview.layer.borderWidth = 3;
        
        [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(smailview.mas_centerY);
            make.left.mas_equalTo(smailview.mas_left).offset(DLMultipleWidth(11));
            make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(24.0), DLMultipleWidth(24.0)));
        }];
        [remindTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(selectButton.mas_top);
            make.left.mas_equalTo(selectButton.mas_right).offset(12);
            make.width.mas_equalTo(100);
            make.bottom.mas_equalTo(selectButton.mas_bottom);
        }];
        
    }
}

- (void)AddressButtonAction:(UIButton *)sender
{
    NSLog(@"定位");
}
- (void)outPutStringOfSelectDate:(NSString *)str withTag:(NSInteger)tag
{
    UILabel *label = (UILabel *)[self.superView viewWithTag:tag];
    
    label.text = str;
    
}

- (void)tapLabelAction:(UITapGestureRecognizer *)tap
{
    [self.eventNameField resignFirstResponder];
    
    DLDatePickerView *dld = [[DLDatePickerView alloc]init];
    
    if (self.startTimeField.text && tap.view.tag == 2) {  //点击了结束时间
        NSDate *minDate = [self dateFromString:self.startTimeField.text];
        dld.picker.minimumDate = minDate;
    }
    if (self.overTimeLabel.text && tap.view.tag == 1) {
        NSDate *maxDate = [self dateFromString:self.overTimeLabel.text];
        dld.picker.maximumDate = maxDate;
    }
    
    dld.tag = tap.view.tag;
    dld.delegate = self;
    [self.view addSubview:dld];
    
    [dld show];
    
}
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}
- (void)chooseButtonAction:(UIButton *)sender
{
    DNImagePickerController *choose = [[DNImagePickerController alloc]init];
    choose.imagePickerDelegate = self;

    [self.navigationController presentViewController:choose animated:YES completion:nil];
    
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    DNAsset *dnasser = [imageAssets firstObject];
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library assetForURL:dnasser.url resultBlock:^(ALAsset *asset) {
        self.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        [self.chooseButton setBackgroundImage:self.image forState:UIControlStateNormal];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.remindTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCoverCell" forIndexPath:indexPath];
    [cell builtInterfaceWithArray:self.remindTitleArray andIndexpath:indexPath];
    //    [cell.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)selectButtonAction:(IndexpathButton *)sender
{
    if (num != 0) {
        UIView *view = (UIView *)[self.tableView viewWithTag:num + 100];
        UIButton *button = (UIButton *)[view viewWithTag:num];
        [button setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
    }
    
    [sender setBackgroundImage:[UIImage imageNamed:@"OK"] forState:UIControlStateNormal];
    num = sender.tag;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  DLMultipleHeight(50.0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
