//
//  HelpTableViewController.m
//  app
//
//  Created by 张加胜 on 15/8/6.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "HelpTableViewController.h"
#import "HelpTableViewCell.h"
#import "HelpCellFrame.h"
#import "HelpInfoModel.h"
#import "CommentsViewController.h"
#import "Interaction.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
@interface HelpTableViewController ()

@property (nonatomic, strong) NSMutableArray *helpFrames;

@property (nonatomic, copy) NSString *url;

@end

@implementation HelpTableViewController
static NSString * const ID = @"HelpTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"求助";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:ID];
    
    [self.tableView setBackgroundColor:RGB(235, 235, 235)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self loadhelpData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadhelpData{
   Person *p = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:self.model.poster[@"_id"]];
    if (!self.helpFrames) {
        self.helpFrames = [NSMutableArray array];
    }
    for (int i = 0; i < 10; i++) {
        HelpInfoModel *helpInfoModel = [[HelpInfoModel alloc]init];
        helpInfoModel.name = p.name;
//        helpInfoModel.avatarURL = p.imageURL;
        helpInfoModel.time = [self getParsedDateStringFromString:self.model.createTime];
        for (NSDictionary *dic in self.model.photos) {
            self.url = dic[@"uri"];
        }
        helpInfoModel.helpImageURL = self.url;
        helpInfoModel.helpText = self.model.content;
        helpInfoModel.avatarURL = p.imageURL;
        
       
        

        HelpCellFrame *f = [[HelpCellFrame alloc]init];
        [f setHelpInfoModel:helpInfoModel];
        
        [self.helpFrames addObject:f];
    }
//    HelpInfoModel *helpInfoModel = [[HelpInfoModel alloc]init];
//    helpInfoModel.name = [NSString stringWithFormat:@"杨同%zd",i];
//    helpInfoModel.time = [self getParsedDateStringFromString:self.model.createTime];
//    for (NSDictionary *dic in self.model.photos) {
//        self.url = dic[@"uri"];
//    }
//    helpInfoModel.helpImageURL = self.url;
//    helpInfoModel.helpText = self.model.content;
//    helpInfoModel.avatarURL = @"1";
    

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.helpCellFrame = self.helpFrames[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((HelpCellFrame *)self.helpFrames[indexPath.row]).cellHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentsViewController *commentsController = [[CommentsViewController alloc]init];
    commentsController.model = self.model;
    [self.navigationController pushViewController:commentsController animated:YES];
}






@end
