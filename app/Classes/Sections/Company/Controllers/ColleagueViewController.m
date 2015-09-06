//
//  ColleagueViewController.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "CircleContextModel.h"
#import "ColleagueViewController.h"
#import "ColleagueViewCell.h"
#import "ConditionController.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "CompanyModel.h"
#import "AddressBookModel.h"
#import <Masonry.h>
#import "UIImageView+DLGetWebImage.h"

#define LABELWIDTH 355.0

@interface ColleagueViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ColleagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtInterface];
}

- (void)builtInterface
{
//    [self createUserInterView];
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

    [model setLimit:10.00];
    [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:model useKeys:@[@"latestContentDate",@"lastContentDate",@"limit"] success:^(id json) {
        NSLog(@"请求成功-- %@",json);
        [self reloadTableViewWithJson:json];
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
//    [cell reloadCellWithModel:dic];
    
    [cell.userInterView addSubview:view];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userInterArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.userInterArray objectAtIndex:indexPath.row];
    NSString *str = [dic objectForKey:@"height"];
    NSInteger num = [str integerValue];
    
    return 110.0 + num;   // 根据图片的高度返回行数
}
/*- (void)getHeightWith:(id)json
{
    
    self.modelArray = [NSMutableArray array];
    
    SHLUILabel *label = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), 1000)];
    label.font = [UIFont systemFontOfSize:15];
    
    for (NSDictionary *dic in json) {
        NSDictionary *tempDic = [dic objectForKey:@"content"];
    
    
        CGSize size = [self getSizeWithLabel:label andString:wordStr];
        int textHeight = size.height + 3;
        NSLog(@"他的字体为 %@, 高度为 %d", wordStr, textHeight);
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
//            int heightStr = [label getAttributedStringHeightWidthValue:DLMultipleWidth(365.0)];
            
            CGSize tempSize = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            int heightStr = tempSize.height + 3;
            NSLog(@"字体为 %@, 高度为 %d", str, heightStr);
            
            NSDictionary *diccc = [NSDictionary dictionaryWithObjects:@[str, [NSString stringWithFormat:@"%d", heightStr]] forKeys:@[@"word", @"height"]];
            
            [interArray addObject:diccc];
        }  // 用户交流的数据
        [dic setObject:interArray forKey:@"interArray"];
        
        [self.modelArray addObject:dic];
    }
}*/
- (CGSize)getSizeWithLabel:(SHLUILabel *)label andString:(NSString *)str
{
    CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

// 得到数据以后创建通用户交互页面
/*- (void)createUserInterView
{
    self.userInterArray = [NSMutableArray array];
    
//    NSLog(@"%@", self.modelArray);
    for (NSDictionary *dic in self.modelArray) {
        UIView *view = [[UIView alloc]init];
        
        NSInteger overHeight = 0;
        
        
        NSDictionary *wordDic = [dic objectForKey:@"word"];
        NSString *tempStr = [wordDic objectForKey:@"height"];
        NSInteger wordHeight = [tempStr integerValue];  // 说说的高
        
        SHLUILabel *label = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(LABELWIDTH), wordHeight)];
        label.text = [wordDic objectForKey:@"word"];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        overHeight += wordHeight;
        
        CGFloat width = DLMultipleWidth(82.0);
        NSArray *array = [dic objectForKey:@"array"];//图片 array
        NSInteger picNum = [array count];
        CGFloat picHeight = 0;
        if (picNum != 0) {
            NSLog(@"图片有 %ld 张", picNum);
            picHeight = ((picNum + 2) / 3 )  * width; //图片view的高
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
                SHLUILabel *interLabel = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(LABELWIDTH), tempInt)];
                interLabel.text = interstr;
                interLabel.font = [UIFont systemFontOfSize:15];
                [interLabel setBackgroundColor:[UIColor colorWithWhite:.8 alpha:.5]];
                [view addSubview:interLabel];
                
                overHeight += tempInt;
            }
        }
        NSLog(@"卡片的高度为%ld",overHeight);
        view.frame = CGRectMake(0, 0, DLMultipleWidth(353.0), overHeight);
        
        NSDictionary *viewDic = [NSDictionary dictionaryWithObjects:@[view, [NSString stringWithFormat:@"%ld", overHeight]] forKeys:@[@"view", @"height"]];
        
        [self.userInterArray addObject:viewDic];
    }
} */


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadTableViewWithJson:(id)json
{
    self.userInterArray = [NSMutableArray array];
    
    SHLUILabel *tempLabel = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), 100)];
    for (NSDictionary *dic in json) {
        
        NSInteger overHeight = 0;
        UIView *view = [[UIView alloc]init];
        /*NSDictionary *tempDic = [dic objectForKey:@"content"];
        CircleContextModel *model = [[CircleContextModel alloc]init];
        [model setValuesForKeysWithDictionary:tempDic];
        
        NSMutableArray *array = [dic objectForKey:@"comments"];
        
        [model setComments:array];*/

        NSDictionary *contentDic = [dic objectForKey:@"content"];
        NSString *contentStr = [contentDic objectForKey:@"content"];
        CGSize size = [self getSizeWithLabel:tempLabel andString:contentStr];
        SHLUILabel *label = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, size.width, size.height)];
        label.text = contentStr;
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        overHeight += size.height;
        CGFloat width = DLMultipleWidth(82.0);
        
        NSArray *array = [contentDic objectForKey:@"photos"];//图片 array
        NSInteger picNum = [array count];
        CGFloat picHeight = 0;
        if (picNum != 0) {
            NSLog(@"图片有 %ld 张", picNum);
            picHeight = ((picNum + 2) / 3 )  * width; //图片view的高
        }
        int b = 0;
        for (NSDictionary *imageDic in array) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, overHeight + b / 3 * width, width - 10, width - 10)];
            [imageView dlGetRouteWebImageWithString:[imageDic objectForKey:@"uri"] placeholderImage:nil];
            [view addSubview:imageView];
            b++;
        }
        
        overHeight += picHeight;
        NSArray *interArray = [dic objectForKey:@"comments"];
        
        for (NSDictionary *interTempDic in interArray) {
            NSString *str = [interTempDic objectForKey:@"content"];
            CGSize tempSize = [self getSizeWithLabel:tempLabel andString:str];
            SHLUILabel *interLabel = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, tempSize.width, tempSize.height)];
            interLabel.font = [UIFont systemFontOfSize:15];
            interLabel.text = str;
            [interLabel setBackgroundColor:[UIColor colorWithWhite:.8 alpha:.5]];
            [view addSubview:interLabel];
            overHeight += size.height;
        }
        view.frame = CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), overHeight);
        NSDictionary *viewDic = [NSDictionary dictionaryWithObjects:@[view, [NSString stringWithFormat:@"%ld", overHeight]] forKeys:@[@"view", @"height"]];
        
        [self.userInterArray addObject:viewDic];
    }
    [self.colleagueTable reloadData];
}
@end
