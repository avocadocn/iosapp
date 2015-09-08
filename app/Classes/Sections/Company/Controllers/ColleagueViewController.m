//
//  ColleagueViewController.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import <ReactiveCocoa.h>

#import "CircleCommentModel.h"
#import "CriticWordView.h"
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
#import "XHMessageTextView.h"
#import "NSString+WPAttributedMarkup.h"

#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"


static ColleagueViewController *coll = nil;
#define LABELWIDTH 355.0

@interface ColleagueViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (nonatomic, strong)XHMessageTextView *inputTextView;
@property (nonatomic, strong)UITextField *myText;
@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, strong)UIView *inputView;
@end


@implementation ColleagueViewController


+ (ColleagueViewController *)shareState
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!coll) {
            coll = [[ColleagueViewController alloc]init];
        }
    });
    return coll;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self builtTextField];  // 发送界面
    [self builtInterface];
}

- (void)builtInterface
{
//    [self createUserInterView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(stateAction)];
    
    self.colleagueTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLScreenHeight - 64)];
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

    [model setLimit:100.00];
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
    
    NSArray *viewArray =  [cell.userInterView subviews];
    for (UIView *aView in viewArray) {
        [aView removeFromSuperview];
    }
    cell.userInterView.height = view.frame.size.height;
    
    CircleContextModel *model = [self.modelArray objectAtIndex:indexPath.row];
    [cell reloadCellWithModel:model andIndexPath:indexPath];
    
    [cell.userInterView insertSubview:view atIndex:0];
    
//    cell.commondButton.userInteractionEnabled = YES;
    [cell.commondButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [cell.praiseButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseAction:)]];
    
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


/**
 * 得到
 */
- (CGSize)getSizeWithLabel:(SHLUILabel *)label andString:(NSString *)str
{
    CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadTableViewWithJson:(id)json
{
    self.modelArray = [NSMutableArray array];
    
    self.userInterArray = [NSMutableArray array];
    
    SHLUILabel *tempLabel = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), 100)];
    for (NSDictionary *dic in json) {
        //得到 model
        NSDictionary *aTempDic = [dic objectForKey:@"content"];
        CircleContextModel *model = [[CircleContextModel alloc]init];
        [model setValuesForKeysWithDictionary:aTempDic];
        
        NSMutableArray *myTemparray = [dic objectForKey:@"comments"];
        
        [model setComments:myTemparray];
        [self.modelArray addObject:model];
        
        NSInteger overHeight = 0;
        UIView *view = [[UIView alloc]init];
        

        NSDictionary *contentDic = [dic objectForKey:@"content"];
        NSString *contentStr = [contentDic objectForKey:@"content"];   // 用户发表的文字
        NSLog(@"用户发表的文字为 %@", contentStr);
        
        if (contentStr){
            NSLog(@"存在文字");
        CGSize size = [self getSizeWithLabel:tempLabel andString:contentStr];
        SHLUILabel *label = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, overHeight, size.width, size.height + 5)];
        label.text = contentStr;
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        overHeight += size.height + 5;
        }
        CGFloat width = DLMultipleWidth(87.0);
        
        NSArray *array = [contentDic objectForKey:@"photos"];//图片 array
        NSInteger picNum = [array count];
        CGFloat picHeight = 0;
        if (picNum != 0) {
            NSLog(@"图片有 %ld 张", picNum);
            picHeight = ((picNum + 2) / 3 )  * width; //图片view的高
        }
        int b = 0;
        for (NSDictionary *imageDic in array) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, overHeight + b / 3 * width, width - 5, width - 5)];
            [imageView dlGetRouteWebImageWithString:[NSString stringWithFormat:@"/%@", [imageDic objectForKey:@"uri"]] placeholderImage:nil];
            imageView.backgroundColor = [UIColor orangeColor];
            [view addSubview:imageView];
            b++;
        }
        
        overHeight += picHeight;
        NSArray *interArray = [dic objectForKey:@"comments"];
        
        for (NSDictionary *interTempDic in interArray) {  // 评论
            
            NSString *str = [interTempDic objectForKey:@"content"];
            CGSize tempSize = [self getSizeWithLabel:tempLabel andString:str];
            WPHotspotLabel *interLabel = [[WPHotspotLabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(LABELWIDTH), tempSize.height)];
            interLabel.numberOfLines = 0;
            NSDictionary *style4 = @{@"body":[UIFont systemFontOfSize:14],
                                     @"abody":[WPAttributedStyleAction styledActionWithAction:^{
                                         NSLog(@"评论者");
                                         
                                     }]};
            interLabel.font = [UIFont systemFontOfSize:14];
            NSString *attStr = [NSString stringWithFormat:@"<abody>%@</abody>:%@", [[interTempDic objectForKey:@"target"] objectForKey:@"nickname"], str];
            interLabel.attributedText = [attStr attributedStringWithStyleBook:style4];
            
//                    interLabel.text = [NSString stringWithFormat:@"%@:%@", [[interTempDic objectForKey:@"target"] objectForKey:@"nickname"], str];

            [interLabel setBackgroundColor:[UIColor colorWithWhite:.8 alpha:.5]];
            [view addSubview:interLabel];
            overHeight += tempSize.height;
        }
        view.frame = CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), overHeight);
        NSDictionary *viewDic = [NSDictionary dictionaryWithObjects:@[view, [NSString stringWithFormat:@"%ld", (long)overHeight]] forKeys:@[@"view", @"height"]];
        
        [self.userInterArray addObject:viewDic];
    }
    [self.colleagueTable reloadData];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击");
    [self.myText becomeFirstResponder];
    [self.inputTextView becomeFirstResponder];
    self.selectIndex = tap.view.tag;
    
}


- (void)builtTextField
{
    
    self.myText = [UITextField new];
    self.myText.backgroundColor = [UIColor redColor];
    self.inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 40)];
//    self.inputView.layer.borderWidth = .5;
//    self.inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputView.backgroundColor = [UIColor whiteColor];
    //    view.backgroundColor = [UIColor blackColor];
    
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(15 , 5 , 200 , 30)];
    self.inputTextView.backgroundColor = [UIColor yellowColor];
    self.myText.borderStyle = UITextBorderStyleNone;
    self.inputTextView.scrollEnabled = YES;
    self.inputTextView.returnKeyType = UIReturnKeySend;
    self.inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    self.inputTextView.placeHolder = @"输入评论";
    self.inputTextView.delegate = self;
    self.inputTextView.backgroundColor = [UIColor clearColor];
    self.inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.inputTextView.layer.borderWidth = 0.65f;
    self.inputTextView.layer.cornerRadius = 6.0f;
    
    [self.inputView addSubview:self.inputTextView];
    self.myText.inputAccessoryView = self.inputView;;
    
    UIButton * faceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [faceButton setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
    [faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
//    [faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:faceButton];
    
    [faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputView.mas_top).offset(5);
        make.bottom.mas_equalTo(self.inputView.mas_bottom).offset(-5);
        make.right.mas_equalTo(self.inputView.mas_right).offset(-10);
        make.width.mas_equalTo(self.inputView.height - 10);
    }];
    
    [self.view addSubview:self.myText];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"发送");
        [self sendManger];
        [self.inputTextView resignFirstResponder];
        [self.myText resignFirstResponder];
        return NO;
    }
    /*
    SHLUILabel *label = [[SHLUILabel alloc]initWithFrame:CGRectMake(0, 0, self.inputTextView.frame.size.width - 5, 0)];
    
//    [self.inputTextView.rac_textSignal filter:^BOOL(NSString *string) {
//        
        CGSize size = [self getSizeWithLabel:label andString:textView.text];
        NSLog(@"size is  %f", size.height);
    self.inputTextView.height = size.height ;
    self.inputView.height = size.height + 18;
    self.myText.inputAccessoryView.frame = CGRectMake(0, -size.height + 35, DLScreenWidth, size.height);
        return [RACSignal empty];
//    }];
    */
    return YES;
}

- (void)sendManger
{
    CircleCommentModel *tempModel = [[CircleCommentModel alloc]init];
    

    CircleContextModel *model = [self.modelArray objectAtIndex:(self.selectIndex - 1)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"comment" forKey:@"kind"];
    [dic setObject:self.inputTextView.text forKey:@"content"];
//    [dic setObject:@1 forKey:@"isOnlyToContent"];
    [dic setObject:[model.poster objectForKey:@"_id"] forKey:@"targetUserId"];
    [dic setObject:model.contentId forKey:@"contentId"];
    [tempModel setValuesForKeysWithDictionary:dic];
    [tempModel setIsOnlyToContent:true];
    
    [RestfulAPIRequestTool routeName:@"publisheCircleComments" requestModel:tempModel useKeys:@[@"contentId", @"kind", @"content", @"isOnlyToContent", @"targetUserId"] success:^(id json) {
        NSLog(@"评论成功 %@",json);
        [self.inputTextView resignFirstResponder];
        [self.colleagueTable reloadData];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
}

- (void)praiseAction:(UITapGestureRecognizer *)sender
{
        CircleCommentModel *tempModel = [[CircleCommentModel alloc]init];

    CircleContextModel *model = [self.modelArray objectAtIndex:(sender.view.tag - 1)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"appreciate" forKey:@"kind"];
    [dic setObject:[model.poster objectForKey:@"_id"] forKey:@"targetUserId"];
    [dic setObject:model.contentId forKey:@"contentId"];
    [tempModel setValuesForKeysWithDictionary:dic];
    [tempModel setIsOnlyToContent:true];
    
    [RestfulAPIRequestTool routeName:@"publisheCircleComments" requestModel:tempModel useKeys:@[@"contentId", @"kind", @"content", @"isOnlyToContent", @"targetUserId"] success:^(id json) {
        NSLog(@"点赞成功 %@",json);
        [self.inputTextView resignFirstResponder];
        [self.colleagueTable reloadData];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
}

@end
