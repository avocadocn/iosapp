//
//  ColleagueViewController.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "ColleagueViewController.h"
#import "ColleagueViewCell.h"
#import "ConditionController.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "CompanyModel.h"
#import "AddressBookModel.h"
#import <Masonry.h>
@interface ColleagueViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ColleagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
    [self makeFalse];
    [self createUserInterView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(stateAction)];
    
    self.colleagueTable = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.colleagueTable.delegate = self;
    self.colleagueTable.dataSource = self;
    [self.colleagueTable setBackgroundColor:[UIColor colorWithWhite:.93 alpha:1]];
    self.title = @"同事圈";
    [self.colleagueTable registerClass:[ColleagueViewCell class] forCellReuseIdentifier:@"tableCell"];
    self.colleagueTable.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:self.colleagueTable];
    [self netRequest];

    
}
- (void)netRequest {
    AddressBookModel *model = [[AddressBookModel alloc] init];
//    Account *account = [AccountTool account];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//    [formatter setTimeZone:timeZone];
//    [formatter setDateFormat : @"M/d/yyyy h:m a"];
//    NSString *stringTime = @"12/5/2011 3:4 am";
//    NSDate *dateTime = [formatter dateFromString:stringTime];
//    [model setLatestContentDate:dateTime];
//    [model setLastContentDate:dateTime];
    [model setLimit:10.00];
    [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:model useKeys:@[@"latestContentDate",@"lastContentDate",@"limit"] success:^(id json) {
        NSLog(@"请求成功-- %@",json);
    
    } failure:^(id errorJson) {
        NSLog(@"请求失败 %@",errorJson);
    }];
}
- (void)stateAction
{
    // 及时状态 页面
    ConditionController *state = [[ConditionController alloc]init];
    [self.navigationController pushViewController:state animated:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColleagueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    NSDictionary *dic = [self.userInterArray objectAtIndex:indexPath.row];
    UIView *view = [dic objectForKey:@"view"];

    cell.userInterView.height = view.frame.size.height;
    [cell reloadCellWithModel:dic];
    
    [cell.userInterView addSubview:view];
//    [cell.userInterView addSubview:view];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.userInterArray objectAtIndex:indexPath.row];
    NSString *str = [dic objectForKey:@"height"];
    NSInteger num = [str integerValue];
    
    return 110.0 + num;   // 根据图片的高度返回行数
}
- (void)makeFalse
{
    NSArray *strArr = @[@"太阳回复刚哥的统统:吾问无为谓sedaw问问娃娃哇哇哇哇drgg3", @"麻吉:吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓哇哇哇哇哇哇哇哇",@"树飞回复麻吉:的顶顶顶顶顶大大大地对地导弹顶顶顶顶", @"加胜:郁闷郁闷有没有没有没有",@"太阳回复刚哥的统统:吾问无为谓sedaw问问娃娃哇哇哇哇drgg3", @"麻吉:吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓吾问无为谓哇哇哇哇哇哇哇哇",@"树飞回复麻吉:的顶顶顶顶顶大大大地对地导弹顶顶顶顶", @"加胜:郁闷郁闷有没有没有没有"];
    
    
    self.modelArray = [NSMutableArray array];
    
    SHLUILabel *label = [[SHLUILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    
    for (int i = 0; i < 10; i++) {  //制造假数据, 十个字典
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger anum = arc4random() %[strArr count];
        NSString *wordStr = [strArr objectAtIndex:anum];
        label.text = wordStr;
        int textHeight = [label getAttributedStringHeightWidthValue:DLMultipleWidth(353.0)];
        NSDictionary *dicc = [NSDictionary dictionaryWithObjects:@[wordStr, [NSString stringWithFormat:@"%d", textHeight]] forKeys:@[@"word", @"height"]];
        
        [dic setObject:dicc forKey:@"word"];  // 用户说的话
        
        int i = arc4random() % 9;
        for (int j = 0; j < i; j++) {  //每个dic的数组里随机添加图片
            UIImage *image = [UIImage imageNamed:@"1"];
            [array addObject:image];
        }
        [dic setObject:array forKey:@"array"];  // 数组里存图片
        
        int j = arc4random() % 4;
        NSMutableArray *interArray = [NSMutableArray array];
        for (int k = 0; k < j; k++) {
            NSInteger num = arc4random()% 6 - 0;
            NSString *str = [strArr objectAtIndex:num];
            
            label.text = str;
            int heightStr = [label getAttributedStringHeightWidthValue:DLMultipleWidth(353.0)];
            NSDictionary *diccc = [NSDictionary dictionaryWithObjects:@[str, [NSString stringWithFormat:@"%d", heightStr]] forKeys:@[@"word", @"height"]];
            
            [interArray addObject:diccc];
        }  // 用户交流的数据
        [dic setObject:interArray forKey:@"interArray"];
        
        [self.modelArray addObject:dic];
    }
}
// 得到数据以后创建通用户交互页面
- (void)createUserInterView
{
    self.userInterArray = [NSMutableArray array];
    
//    NSLog(@"%@", self.modelArray);
    for (NSDictionary *dic in self.modelArray) {
        UIView *view = [[UIView alloc]init];
        
        NSInteger overHeight = 0;
        
        
        NSDictionary *wordDic = [dic objectForKey:@"word"];
        NSString *tempStr = [wordDic objectForKey:@"height"];
        NSInteger wordHeight = [tempStr integerValue];  // 说说的高
        
        SHLUILabel *label = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(353.0), wordHeight)];
        label.text = [wordDic objectForKey:@"word"];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        overHeight += wordHeight;
        
        CGFloat width = DLMultipleWidth(82.0);
        NSArray *array = [dic objectForKey:@"array"];//图片 array
        NSInteger picNum = [array count];
        CGFloat picHeight = 0;
        if (picNum != 0) {
            picHeight = (picNum / 3 + 1) * width; //图片view的高
        }
        int b = 0;
        for (UIImage *image in array) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, overHeight + b / 3 * width, width - 10, width - 10)];
            imageView.image = image;
            [view addSubview:imageView];
            b++;
        }
        
        overHeight += picHeight;
        
        NSArray *interArray = [dic objectForKey:@"interArray"];
        

        
        if (!([interArray count] == 0)) {
            for (NSDictionary *interDic in interArray) {
                NSString *interHeight = [interDic objectForKey:@"height"];
                NSInteger tempInt = [interHeight integerValue];
                
                NSString *interstr = [interDic objectForKey:@"word"];
                SHLUILabel *interLabel = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(353.0), tempInt)];
                interLabel.text = interstr;
                interLabel.font = [UIFont systemFontOfSize:15];
                [interLabel setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
                [view addSubview:interLabel];
                
                overHeight += tempInt;
            }
        }
        NSLog(@"卡片的高度为%ld",overHeight);
        view.frame = CGRectMake(0, 0, DLMultipleWidth(353.0), overHeight);
        
        NSDictionary *viewDic = [NSDictionary dictionaryWithObjects:@[view, [NSString stringWithFormat:@"%ld", overHeight]] forKeys:@[@"view", @"height"]];
        
        [self.userInterArray addObject:viewDic];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
