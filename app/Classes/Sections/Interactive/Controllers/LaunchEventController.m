//
//  LaunchEventController.m
//  app
//
//  Created by 申家 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "ChoosePhotoController.h"
#import "LaunchEventController.h"
#import "EventRemindCell.h"
#import <Masonry.h>
#import "DLDatePickerView.h"
typedef NS_ENUM(NSInteger, RemindTableState){
    RemindTableStateNo,
    RemindTableStateYes
};

@interface LaunchEventController ()<DLDatePickerViewDelegate, UITableViewDataSource, UITableViewDelegate, ArrangeState>

@property (nonatomic, assign)RemindTableState state;

@end

@implementation LaunchEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeFlaseValue];
    
    [self builtBigScroll];
    [self builtEventCover];
    [self builtEventDetails];
    [self builtEventRemindTime];
    
    
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
    
    
    UILabel *startTimeField = [UILabel new];
    startTimeField.tag = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
    startTimeField.userInteractionEnabled = YES;
    [startTimeField addGestureRecognizer:tap];
    startTimeField.textAlignment = NSTextAlignmentCenter;
    [self.superView addSubview:startTimeField];
    
    [startTimeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chooseButton.mas_top);
        make.left.mas_equalTo(startLabel.mas_right);
        make.bottom.mas_equalTo(timeLine.mas_top);
        make.right.mas_equalTo(self.superView.mas_right);
    }];
    
    UILabel *overTimeLabel = [UILabel new];
    overTimeLabel.tag = 2;
    UITapGestureRecognizer *tapOver = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabelAction:)];
    [overTimeLabel addGestureRecognizer:tapOver];
    overTimeLabel.userInteractionEnabled = YES;
    overTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.superView addSubview:overTimeLabel];
    
    [overTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLine.mas_top);
        make.left.mas_equalTo(startTimeField.mas_left);
        make.right.mas_equalTo(startTimeField.mas_right);
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
    self.remindView = [UIView new];
    [self.remindView setBackgroundColor:[UIColor whiteColor]];
    
    [self.eventScroll addSubview:self.remindView];
    
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailsView.mas_bottom).offset(DLMultipleHeight(15));
        make.left.mas_equalTo(self.superView.mas_left);
        make.right.mas_equalTo(self.superView.mas_right);
        make.height.mas_equalTo(DLMultipleHeight(50.0));
    }];
    
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
    
    UIImageView *imageView = [UIImageView new];
    [foldButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(foldButton.mas_centerX);
        make.centerY.mas_equalTo(foldButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DLMultipleHeight((49 / 2.5)), DLMultipleHeight((49 / 2.5))));
    }];
    
    imageView.image = [UIImage imageNamed:@"fold"];
    
    self.remindTimeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 ,DLMultipleHeight(50.0), DLScreenWidth, 0) style:UITableViewStylePlain];
    self.remindTimeTableView.delegate = self;
    self.remindTimeTableView.dataSource = self;
    
    [self.remindTimeTableView registerClass:[EventRemindCell class] forCellReuseIdentifier:@"eventCoverCell"];
    [self.remindView addSubview:self.remindTimeTableView];
    self.state = RemindTableStateNo;
}

- (void)foldButtonAction:(UIButton *)sender
{
    if (self.state == RemindTableStateNo) {
        
        [UIView animateWithDuration:.4 animations:^{
            self.remindView.height = DLMultipleHeight(400.0);
            
            self.remindTimeTableView.frame = CGRectMake(0, DLMultipleHeight(50.0), DLScreenWidth, DLMultipleHeight(350.0));
            self.eventScroll.contentSize = CGSizeMake(0, DLMultipleHeight(730.0));
            
        }];
        self.state = RemindTableStateYes;
    }
    else {
        [UIView animateWithDuration:.4 animations:^{
            
        
        self.remindView.height = DLMultipleHeight(50.0);
        self.remindTimeTableView.frame = CGRectMake(0, DLMultipleHeight(50.0), DLScreenWidth, 0);
        self.eventScroll.contentSize = CGSizeMake(0, DLMultipleHeight(667));
        
        }];
        self.state = RemindTableStateNo;
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
    NSLog(@"点击");
    
    DLDatePickerView *dld = [[DLDatePickerView alloc]init];
    dld.tag = tap.view.tag;
    dld.delegate = self;
    [self.view addSubview:dld];
    
    [dld show];
    
}

- (void)chooseButtonAction:(UIButton *)sender
{
    ChoosePhotoController *choose = [ChoosePhotoController shareStateOfController];
    choose.delegate = self;
    choose.allowSelectNum = 1;
    [self.navigationController pushViewController:choose animated:YES];
    
}

- (void)arrangeStartWithArray:(NSMutableArray *)array
{
    [self.chooseButton setBackgroundImage:[array lastObject] forState:UIControlStateNormal];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.remindTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCoverCell" forIndexPath:indexPath];
    [cell builtInterfaceWithArray:self.remindTitleArray andIndexpath:indexPath];
    
    return cell;
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
