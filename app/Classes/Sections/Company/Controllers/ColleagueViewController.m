
//  ColleagueViewController.m
//  app
//
//  Created by 申家 on 15/7/16.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DXFaceView.h"
#import <MJRefreshConst.h>
#import <UIScrollView+MJRefresh.h>
#import <MJRefresh.h>
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CardChooseView.h"
#import "DNImagePickerController.h"
#import "PhotoPlayController.h"
#import "CircleImageView.h"
#import <ReactiveCocoa.h>
#import "ColleaguesInformationController.h"
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
#import "AddressBookModel.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "NSString+DLStringWithEmoji.h"
#import "CricleDetailViewController.h"


typedef NS_ENUM(NSInteger, CommentObject) {
    CommentPoster,
    CommentReviewers
};

typedef NS_ENUM(NSInteger, DLRefreshState) {
    /**
     * 刷新
     */
    DLRefreshStateRefresh,
    /**
     * 加载
     */
    DLRefreshStateReload
};

typedef NS_ENUM(NSInteger, DLKeyBoardType) {
    DLKeyBoardTypeNormal,
    DLKeyBoardTypeFace
};


static ColleagueViewController *coll = nil;
static NSString * userId = nil;
static NSString * tergetUserId = nil;
static NSString * contentId = nil;

#define LABELWIDTH 355.0
#define TEXTFONT 16
#define REPLYTEXT 14

@interface ColleagueViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ConditionControllerDelegate, CardChooseViewDelegate, DNImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DXFaceDelegate, CricleDetailViewControllerDelegate>
/**
 * 输入评论内容的真正 textfield
 */
@property (nonatomic, strong)XHMessageTextView *inputTextView;
/**
 * 用来召出键盘的 textfield
 */
@property (nonatomic, strong)UITextField *myText;
@property (nonatomic, strong)NSNumber *selectIndex;
@property (nonatomic, strong)UIView *inputView;
@property (nonatomic, assign)CommentObject object;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *addressBookModel;

@property (nonatomic, assign)BOOL selectState;
@property (nonatomic, assign)DLRefreshState state;
@property (nonatomic, assign)DLKeyBoardType keyBordType;
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
    if (!userId) {
        userId = [AccountTool account].ID;
    }
    //    [self createUserInterView];
    
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightImage.image = [UIImage imageNamed:@"selectPhoto@3x"];
    rightImage.userInteractionEnabled = YES;
    
    [rightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateAction)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightImage];
    
    self.colleagueTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLScreenHeight - 64)];
    self.colleagueTable.delegate = self;
    self.colleagueTable.dataSource = self;
    [self.colleagueTable setBackgroundColor:[UIColor colorWithWhite:.93 alpha:1]];
    self.title = @"同学圈";
    [self.colleagueTable registerClass:[ColleagueViewCell class] forCellReuseIdentifier:@"tableCell"];
    
    self.colleagueTable.separatorColor = [UIColor clearColor];
    
    //
    //    self.colleagueTable.tableHeaderView = [MJRefreshStateHeader headerWithRefreshingBlock:^{
    //
    //     }];
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [footer setTitle:@"加载更多" forState: MJRefreshStateIdle];
    self.colleagueTable.footer = footer;
    
    MJRefreshNormalHeader *aHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    aHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    self.colleagueTable.header = aHeader;
    [self.view addSubview:self.colleagueTable];
    [self netRequest];
    
}
- (void)headerAction  // 刷新
{
    //    [UIView animateWithDuration:3 animations:^{
    //        [self.colleagueTable.header endRefreshing];
    //    }];
    self.state = DLRefreshStateRefresh;
//    CircleContextModel *model = [self.modelArwray firstObject];
    
    [self refreshAndUploadWithLimit:10 andLatestTime:nil lastTime:nil];
}

- (void)refreshAction{
    //    [UIView animateWithDuration:2 animations:^{
    //        [self.colleagueTable.footer endRefreshing];
    //    }];
    
    //   下拉加载
    self.state = DLRefreshStateReload;
    CircleContextModel *model = [self.modelArray lastObject];
    [self refreshAndUploadWithLimit:10 andLatestTime:nil lastTime:model.postDate];
}

- (void)refreshAndUploadWithLimit:(NSInteger)num andLatestTime:(NSString *)latest lastTime:(NSString *)last
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:num] forKey:@"limit"];
    NSMutableArray *array = [NSMutableArray arrayWithObject:@"limit"];
    
    if (latest) {
        [dic setObject:latest forKey:@"latestContentDate"];  //刷新
        [array addObject:@"latestContentDate"];
    }
    if (last)
    {
        [dic setObject:last forKey:@"lastContentDate"];
        [array addObject:@"lastContentDate"];
    }
    
    [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:dic useKeys:array success:^(id json) {
        //        if (num) { //num 存在是加载
        NSLog(@" 刷新加载的到的数据为 %@", json);
        
        [self saveDefaultWithJson:json];
        
        //        [self saveDefaultWithJson:json]; //十条
        
//        [self netRequest];
        
        [self.colleagueTable reloadData];
        
        
        [self.colleagueTable.header endRefreshing];
        [self.colleagueTable.footer endRefreshing];
        
        //        }
    } failure:^(id errorJson) {
        
        [self.colleagueTable.header endRefreshing];
        [self.colleagueTable.footer endRefreshing];
        
    }];
}

- (void)saveDefaultWithJson:(id)json
{
    NSMutableArray *IDArray = [NSMutableArray array];

    
    for (NSDictionary *jsonDic in json) {
        CircleContextModel *model = [[CircleContextModel alloc]init];
        
        NSDictionary *dic = [jsonDic objectForKey:@"content"];
        
        [model setValuesForKeysWithDictionary:dic];
        NSDictionary *poster = [dic objectForKey:@"poster"];
        NSDictionary *target = [dic objectForKey:@"target"];
        model.poster = [[AddressBookModel alloc]init];
        model.target = [[AddressBookModel alloc]init];
        [model.poster setValuesForKeysWithDictionary:poster];
        [model.target setValuesForKeysWithDictionary:target];
        
        NSArray *comments = [jsonDic objectForKey:@"comments"];
        model.comments = [NSMutableArray array];
        for (NSDictionary *tempDic in comments) {
            CircleContextModel *tempModel = [[CircleContextModel alloc]init];
            [tempModel setValuesForKeysWithDictionary:tempDic];
            tempModel.poster = [[AddressBookModel alloc]init];
            tempModel.target = [[AddressBookModel alloc]init];
            NSDictionary *tempPoster = [tempDic objectForKey:@"poster"];
            NSDictionary *tempTarget = [tempDic objectForKey:@"target"];
            [tempModel.poster setValuesForKeysWithDictionary:tempPoster];
            [tempModel.target setValuesForKeysWithDictionary:tempTarget];
            
            [model.comments addObject:tempModel];
        }
        
        NSMutableDictionary *tempDic = [self getViewWithModel:model];
        
        NSArray *photoArray = tempDic[@"photoArray"];
        [tempDic removeObjectForKey:@"photoArray"];
        
        [self.userInterArray addObject:tempDic];
        [self.photoArray addObject:photoArray];
        [self.modelArray addObject:model];
        
        [IDArray addObject:model.ID];
        [model save];
        
    }
    
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray *tempArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [tempArray lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
    
    BOOL judge = [manger fileExistsAtPath:path];
    if (judge) {
        
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];  //原来的 array
        
        switch (self.state) {
            case DLRefreshStateRefresh: // 刷新
            {
                // IDArray  是新数据
                NSLog(@"刷新");
                [IDArray removeObjectsInArray:array];
                NSMutableArray *new = (NSMutableArray *)[IDArray arrayByAddingObjectsFromArray:array];
                
                //                if (new.count > 10) {
                //                    [new removeObjectsInRange:NSMakeRange(10, new.count - 10)];
                //                }
                
                [new writeToFile:path atomically:YES];
            }
                break;
                
            case DLRefreshStateReload:  // 加载
            {
                NSLog(@"加载");
                
                [IDArray removeObjectsInArray:array];  //现在的
                IDArray = (NSMutableArray *)[array arrayByAddingObjectsFromArray:IDArray];
                [manger removeItemAtPath:path error:nil];
                [IDArray writeToFile:path atomically:YES]; // 把ID数据存进去
                
            }
                break;
            default:
                break;
        }
        
        
    } else
    {
        [IDArray writeToFile:path atomically:YES];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)netRequest {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
    
    NSArray *IDArray = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@", IDArray);
    
    self.modelArray = [NSMutableArray array];
    self.userInterArray = [NSMutableArray array];
    self.addressBookModel = [NSMutableArray array];
    
    self.photoArray = [NSMutableArray array];
    
    for (NSString *str in IDArray) {
        CircleContextModel *cir = [[CircleContextModel alloc]initWithString:str];
//        NSLog(@"%@    %@", cir.content, cir.poster.ID);
        
        NSMutableDictionary *viewDic = [self getViewWithModel:cir];
        
        NSArray *tempPhotoArray = [viewDic objectForKey:@"photoArray"];
        [viewDic removeObjectForKey:@"photoArray"];
        
        [self.photoArray addObject:tempPhotoArray];
        [self.userInterArray addObject:viewDic];
        [self.modelArray addObject:cir];
        
    }
    [self.colleagueTable reloadData];
    
    /*
     AddressBookModel *model = [[AddressBookModel alloc] init];
     
     [model setLimit:10.00];
     [RestfulAPIRequestTool routeName:@"getCompanyCircle" requestModel:model useKeys:@[@"latestContentDate",@"lastContentDate",@"limit"] success:^(id json) {
     NSLog(@"请求成功-- %@",json);
     [self reloadTableViewWithJson:json];
     } failure:^(id errorJson) {
     NSLog(@"请求失败 %@",errorJson);
     }];
     */
}

- (void)stateAction
{
    if (self.selectState == NO) {
        CardChooseView *card = [[CardChooseView alloc]initWithTitleArray:@[@"发文字", @"拍照片", @"选取现有的照片"]];
        card.delegate = self;
        // 及时状态 页面
        [self.view addSubview:card];
        [card show];
        self.selectState = YES;
    }
}

- (void)CardDissmiss
{
    self.selectState = NO;
}

- (void)cardActionWithButton:(UIButton *)sender
{
    self.selectState = NO;
    
    switch (sender.tag) {
        case 1:{
            ConditionController *state = [[ConditionController alloc]init];
            state.delegate = self;
            [self.navigationController pushViewController:state animated:YES];
        }
            break;
        case 2:{
            //拍照片
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                //模态进去本地相机
                [self presentViewController:imagePicker animated:YES completion:nil];
            } else {
                NSLog(@"没有图片库");
            }
            
            
            break;
        }
        case 3:
        {
            DNImagePickerController *pickr = [[DNImagePickerController alloc]init];
            pickr.imagePickerDelegate = self;
            
            [self.navigationController presentViewController:pickr animated:YES completion:nil];
        }
        default:
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // info 是存所选取的图片的信息的字典
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSArray *array = [NSArray arrayWithObject:[self fixOrientation:image]];
    [self jumpViewControllerWithPhoto:array];
}



- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    NSMutableArray *imagePhotoArray = [NSMutableArray arrayWithArray:imageAssets];
//    for (int i = 0; i < imageAssets.count; i++) {
//        
//        DNAsset *dnasset = [imageAssets objectAtIndex:i];
//        
//        ALAssetsLibrary *lib = [ALAssetsLibrary new];
//        
//        [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset) {
//            
//            UIImage *aImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//            NSLog(@"正在选择");
//            [imagePhotoArray addObject:aImage];
//            if (i == [imageAssets count] - 1) {
                [self jumpViewControllerWithPhoto:imagePhotoArray];
//            }
//            
//        } failureBlock:^(NSError *error) {
//            
//        }];
//    }
}

- (void)jumpViewControllerWithPhoto:(NSArray *)array
{
    ConditionController *state = [[ConditionController alloc]init];
    state.delegate = self;
    state.photoArray = [NSMutableArray arrayWithArray:array];
    [self.navigationController pushViewController:state animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ColleagueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (!cell) {
        cell = [[ColleagueViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    
    NSDictionary *dic = self.userInterArray[indexPath.row];
    UIView *view = dic[@"view"];
    
    NSArray *viewArray =  [cell.userInterView subviews];
    for (UIView *aView in viewArray) {
        [aView removeFromSuperview];
    }
    CircleContextModel *model = self.modelArray[indexPath.row];
    [cell reloadCellWithModel:model andIndexPath:indexPath];
    
    cell.userInterView.height = view.frame.size.height;
    //circleImageAction
    
    view.tag = indexPath.row + 1;
    [cell.userInterView insertSubview:view atIndex:0];
    
    [cell.circleImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleImageAction:)]];
    [cell.commondButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [cell.praiseButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseAction:)]];
//    [cell setNeedsDisplay];
    return cell;
}



 /*

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColleagueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    CircleContextModel *model = [self.modelArray objectAtIndex:indexPath.row];
    [cell reloadCellWithModel:model andIndexPath:indexPath];
    [cell getViewWithModel:model andTag:indexPath.row + 1];
    return cell;
}
*/
//点击头像
- (void)circleImageAction:(UITapGestureRecognizer *)tap
{
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    CircleCommentModel *cirModel = [self.modelArray objectAtIndex:tap.view.tag - 11111];
    coll.model = [[AddressBookModel alloc]init];
    
    coll.model = cirModel.poster;
    
    [self.navigationController pushViewController:coll animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.userInterArray count];
    return self.modelArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.userInterArray objectAtIndex:indexPath.row];
    NSString *str = [dic objectForKey:@"height"];
    NSInteger num = [str integerValue];
    
    return 118.0 + 6 + num;   // 根据图片的高度返回行数
//    CGFloat num = [self getHeightWithModel:self.modelArray[indexPath.row]];
//    return  num;
}

- (CGFloat)getHeightWithModel:(CircleContextModel *)model
{
    CGFloat height = 0.0f;
    NSArray *array = model.photos;
    NSInteger picNum = [array count];
    // 图片的高度
    if (picNum == 1) {
        height = DLMultipleWidth(166.0);
    }
    if (picNum != 0 && picNum != 1) {
        CGFloat width = DLMultipleWidth(87.0);
//        NSLog(@"图片有 %ld 张", (long)picNum);
        height = ((picNum + 2) / 3 )  * width; //图片view的高
    }
    // 评论 回复的高度
    
    NSMutableArray *interArray = model.comments;
    for (CircleContextModel *interTempDic in interArray) {  //评论
        NSString *str = interTempDic.content;
//        NSLog(@"得到的评论详情为 %@", str);
        
        CGFloat tempWidth = 5;
        CGRect rect = [self getRectWithFont:[UIFont systemFontOfSize:REPLYTEXT] width:DLMultipleWidth(LABELWIDTH) - tempWidth andString:str];
        height += rect.size.height;
    }
    return 118.0 + 6 + height;
}

- (CGRect)getRectWithFont:(UIFont *)font width:(CGFloat)num andString:(NSString *)string
{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(num, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    rect.size.height += 8;
    return rect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.inputTextView resignFirstResponder];
    [self.myText resignFirstResponder];
    CircleContextModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    CricleDetailViewController *c = [[CricleDetailViewController alloc]init];
    c.delegate = self;
    c.tempModel = [[CircleContextModel alloc]init];
    c.tempModel = model;
    c.index = indexPath;
    
    [self.navigationController pushViewController:c animated:YES];
    
    c.photoArray = [NSMutableArray arrayWithArray:[self.photoArray objectAtIndex:indexPath.row]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)reloadDataWithModel:(CircleContextModel *)model andIndexPath:(NSIndexPath *)index
{
    NSMutableDictionary *dic = [self getViewWithModel:model];
    NSArray *photoArray = dic[@"photoArray"];
    [dic removeObjectForKey:@"photoArray"];
    [self.photoArray replaceObjectAtIndex:index.row withObject:photoArray];
    [self.userInterArray replaceObjectAtIndex:index.row withObject:dic];
    [self.modelArray replaceObjectAtIndex:index.row withObject:model];
    
    [self.colleagueTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)deleteIndexPath:(NSIndexPath *)index
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray *tempArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [tempArray lastObject];

    path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
    
    CircleContextModel *model = self.modelArray[index.row];
    NSMutableArray *IDArray = (NSMutableArray *)[NSArray arrayWithContentsOfFile:path];
    [IDArray removeObjectAtIndex:index.row];
    [manger removeItemAtPath:path error:nil];
    [IDArray writeToFile:path atomically:YES];
    NSLog( @"  %@ \n  %@", IDArray[index.row], model.ID);
    
    NSLog(@"%ld  %ld", index.row, index.section);
    [self.userInterArray removeObjectAtIndex:index.row];
    [self.modelArray removeObjectAtIndex:index.row];
    NSLog(@"原文为   %@  ", model.content);
    
    [self.colleagueTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableDictionary *)getViewWithModel:(CircleContextModel *)model
{
    
    
    NSInteger overHeight = 0;
    UIView *view = [[UIView alloc]init];
    
    UIView *modelDetileView = [[UIView alloc]init];
    
    NSString *contentStr = model.content;
//    NSLog(@"用户发表的文字为 %@", contentStr);
    
    if (contentStr){
        
        UILabel *label = [self getLabelFromString:contentStr andHeight:overHeight];
        UILabel *detileLabel = [self getLabelFromString:contentStr andHeight:overHeight];
        
        [modelDetileView addSubview:detileLabel];
        [view addSubview:label];
        overHeight += label.frame.size.height ;
    }
    
    CGFloat width = DLMultipleWidth(87.0);
    
    NSArray *array = model.photos;//图片 array
    NSInteger picNum = [array count];
    CGFloat picHeight = 0;
    if (picNum == 1) {
        width = DLMultipleWidth(166.0);
        picHeight = width;
    }
    if (picNum != 0 && picNum != 1) {
        NSLog(@"图片有 %ld 张", (long)picNum);
        picHeight = ((picNum + 2) / 3 )  * width; //图片view的高
    }
    int b = 0;
    NSMutableArray *tempPhotoArray = [NSMutableArray array];
    for (NSDictionary *imageDic in array) {
        
        width = (int)width;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, (overHeight + 2) + b / 3 * width, width - 6, width - 6)];
        NSLog(@"%f", width);
        [imageView dlGetRouteThumbnallWebImageWithString:[NSString stringWithFormat:@"%@", [imageDic objectForKey:@"uri"]] placeholderImage:nil withSize:CGSizeMake(width, width)];
        //            imageView.backgroundColor = [UIColor orangeColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        imageView.tag = b + 1;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAction:)]];
        
        [view addSubview:imageView];
        UIImageView *detileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(b % 3 * width, (overHeight + 2) + b / 3 * width, width - 6, width - 6)];
        detileImageView.image = [self OriginImage:imageView.image scaleToSize:imageView.size];
        detileImageView.backgroundColor = [UIColor yellowColor];
        detileImageView.contentMode = UIViewContentModeScaleAspectFill;
        detileImageView.clipsToBounds = YES;
        [detileImageView dlGetRouteThumbnallWebImageWithString:[NSString stringWithFormat:@"/%@", [imageDic objectForKey:@"uri"]] placeholderImage:nil withSize:CGSizeMake(width, width)];
        
        //            detileImageView.image = [UIImage imageNamed:@"1"];
        
        //            [imageView.rac_willDeallocSignal subscribeNext:^(UIImage *image) {
        //                if (image) {
        //                    NSLog(@"已获得图片");
        //                }
        //            }];
        
        [modelDetileView addSubview:detileImageView];
        [tempPhotoArray addObject:[NSString stringWithFormat:@"%@/_%.f/%.f", [imageDic objectForKey:@"uri"], width, width]];
        b++;
    }
    
    overHeight += picHeight;
    
    modelDetileView.frame = CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), overHeight);
    
    [model setDetileView:modelDetileView];
    
    NSMutableArray *interArray = model.comments;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (CircleContextModel *interTempDic in interArray) {  //评论
        
        NSString *str = interTempDic.content;
//        NSLog(@"得到的评论详情为 %@", str);
        if (str) {
            
            CGFloat tempWidth = 5;
            CGRect rect = [self getRectWithFont:[UIFont systemFontOfSize:REPLYTEXT] width:DLMultipleWidth(LABELWIDTH) - tempWidth andString:str];
            WPHotspotLabel *interLabel = [[WPHotspotLabel alloc]initWithFrame:CGRectMake(tempWidth, 0, DLMultipleWidth(LABELWIDTH) - tempWidth, rect.size.height + 6)];
            interLabel.numberOfLines = 0;
            NSDictionary *style4 = @{@"body":[UIFont systemFontOfSize:REPLYTEXT],
                                     @"abody":@[RGBACOLOR(80, 125, 175, 1) ,[WPAttributedStyleAction styledActionWithAction:^{
                                         [self jumpPageWithDic:interTempDic andPoster:@"poster"];
                                     }]]
                                     ,
                                     @"myBody":@[RGBACOLOR(51, 51, 51, 1),[WPAttributedStyleAction styledActionWithAction:^{
                                         [self.myText becomeFirstResponder];
                                         [self.inputTextView becomeFirstResponder];
                                         self.object = CommentReviewers;
                                         self.inputTextView.text = nil;
                                         self.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@:", interTempDic.poster.nickname];
                                         tergetUserId = interTempDic.poster.ID;
                                         contentId = interTempDic.targetContentId;
//                                         self.selectIndex = [NSNumber numberWithInteger:(tag - 10000)] ;

                                         NSInteger temp = interLabel.superview.superview.tag;
                                         self.selectIndex = [NSNumber numberWithInteger:temp];

                                     }]],
                                     @"postBody":@[RGBACOLOR(80, 125, 175, 1) ,[WPAttributedStyleAction styledActionWithAction:^{
                                         [self jumpPageWithDic:interTempDic andPoster:@"target"];
                                     }]]
                                     };
            interLabel.font = [UIFont systemFontOfSize:REPLYTEXT];
            BOOL tempState = [interTempDic.isOnlyToContent boolValue];
            if (tempState){
                
                NSString *attStr = [NSString stringWithFormat:@"<abody>%@</abody>:<myBody>%@</myBody>", interTempDic.poster.nickname, str];
                interLabel.attributedText = [attStr attributedStringWithStyleBook:style4];
            } else
            {
                NSString *att = [NSString stringWithFormat:@"<abody>%@</abody>回复<postBody>%@</postBody>:<myBody>%@</myBody>",interTempDic.poster.nickname, interTempDic.target.nickname, interTempDic.content];
                interLabel.attributedText = [att attributedStringWithStyleBook:style4];
            }
            
            //            [interLabel sizeToFit];
            //            interLabel.backgroundColor = RGBACOLOR(247, 247, 247, 1);
            UIView *aTempView = [[UIView alloc]initWithFrame:CGRectMake(0, overHeight + 6, DLMultipleWidth(LABELWIDTH), rect.size.height + 6)];
            [aTempView addSubview:interLabel];
            aTempView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
            
            [view addSubview:aTempView];
            overHeight += rect.size.height + 3;
        } else
        {
            [tempArray addObject:interTempDic];
        }
        
    }
    [interArray removeObjectsInArray:tempArray];
    view.frame = CGRectMake(0, 0, DLMultipleWidth(LABELWIDTH), overHeight);
    NSMutableDictionary *viewDic = [NSMutableDictionary dictionaryWithObjects:@[view, [NSString stringWithFormat:@"%ld", (long)overHeight]] forKeys:@[@"view", @"height"]];
    
    if (!tempPhotoArray.count) {
        [tempPhotoArray addObject:@"空的"];
    }
    [viewDic setObject:tempPhotoArray forKey:@"photoArray"];
    
    return viewDic;
    //        tempI ++;
    
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.object = CommentPoster;
    NSLog(@"点击评论");
    
    [self.myText becomeFirstResponder];
    [self.inputTextView becomeFirstResponder];
    self.selectIndex = [NSNumber numberWithInteger:tap.view.tag];
    
}

- (void)builtTextField
{
    self.myText = [UITextField new];
    self.myText.backgroundColor = [UIColor redColor];
    self.inputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 600)];
    //    self.inputView.layer.borderWidth = .5;
    //    self.inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.inputView.backgroundColor = [UIColor whiteColor];
    //    view.backgroundColor = [UIColor blackColor];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 600 - 40, DLScreenWidth, 40)];
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(15 , 5 , DLScreenWidth - 60 , 30)];
    //    self.inputTextView.backgroundColor = [UIColor yellowColor];
    self.myText.borderStyle = UITextBorderStyleNone;
    self.inputTextView.scrollEnabled = YES;
    self.inputTextView.returnKeyType = UIReturnKeySend;
    self.inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    self.inputTextView.placeHolder = @"输入评论";
    self.inputTextView.delegate = self;
//    self.inputTextView.backgroundColor = [UIColor clearColor];
    self.inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.inputTextView.layer.borderWidth = 0.65f;
    self.inputTextView.layer.cornerRadius = 6.0f;
    
    [whiteView addSubview:self.inputTextView];
    self.myText.inputAccessoryView = self.inputView;;
    
    UIButton * faceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"chatBar_face@2x"] forState:UIControlStateNormal];
//    [faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
//    [faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [faceButton setBackgroundColor:[UIColor greenColor]];
    [faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:faceButton];
    
    [faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-5);
        make.right.mas_equalTo(whiteView.mas_right).offset(-10);
        make.width.mas_equalTo(30);
    }];
    
    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:self.inputTextView];
    [self.inputView addSubview:whiteView];
    [self.inputView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissAction)]];

//    self.inputTextView.rac_textSignal map:^id(NSNumber *number) {
//        return @(self.inputTextView.isFirstResponder);
//    }
    
    [self.view addSubview:self.myText];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)disMissAction
{
    [self.inputTextView resignFirstResponder];
    [self.myText resignFirstResponder];
}
- (void)buttonAction:(UIButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"chatBar_face@2x"] forState:UIControlStateNormal];
    } else {
        sender.selected = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"chatBar_keyboard@2x"] forState:UIControlStateNormal];
    }
    switch (self.keyBordType) {
        case DLKeyBoardTypeNormal:
        {
            DXFaceView *face = [[DXFaceView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, 200)];
            face.delegate = self;
            face.backgroundColor = RGBACOLOR(238, 238, 245, 1);
            face.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            self.inputTextView.inputView = face;
//            [self.inputTextView resignFirstResponder];
//            [self.inputTextView becomeFirstResponder];
            // 刷新 inputView
            [self.inputTextView reloadInputViews];
            self.keyBordType = DLKeyBoardTypeFace;
        }
            break;
        case DLKeyBoardTypeFace:
        {
            self.inputTextView.inputView = UIInputViewStyleDefault;
            [self.inputTextView reloadInputViews];
            self.keyBordType = DLKeyBoardTypeNormal;
            
        }
            break;
        default:
            break;
    }
}

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
{
    NSLog(@" 选中的表情为%@  %d", str, isDelete);
    NSMutableString *mustr = [NSMutableString stringWithFormat:@"%@", self.inputTextView.text];
    if (isDelete && mustr.length) {
        NSString *lastStr;
        if (mustr.length == 1) {
            lastStr = [mustr substringFromIndex:mustr.length - 1];
        } else
        {
            lastStr = [mustr substringFromIndex:mustr.length - 2];
        }
        BOOL judge = [self stringContainsEmoji:lastStr];
        NSLog(@"%d   %@", judge, lastStr);
        if (judge) {
            NSLog(@"是表情");
            [mustr deleteCharactersInRange:NSMakeRange(mustr.length - 2, 2)];
        } else
        {
            [mustr deleteCharactersInRange:NSMakeRange(mustr.length - 1, 1)];
            NSLog(@"不是表情");
        }
        
        self.inputTextView.text = mustr;
    } else if (!isDelete) {
    self.inputTextView.text = [NSString stringWithFormat:@"%@%@",self.inputTextView.text, str];
    }
}

- (void)sendFace
{
    switch (self.object) {
        case CommentPoster:
        {
            [self sendManger:true];
        }
            break;
        case CommentReviewers:
        {
            [self sendManger:false];
            
        }
            break;
        default:
            break;
    }
    
    [self.inputTextView resignFirstResponder];
    [self.myText resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"发送");
        switch (self.object) {
            case CommentPoster:
            {
                [self sendManger:true];
            }
                break;
            case CommentReviewers:
            {
                [self sendManger:false];
                
            }
                break;
            default:
                break;
        }
        [self.inputTextView resignFirstResponder];
        [self.myText resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)sendManger:(BOOL)state
{
    CircleCommentModel *tempModel = [[CircleCommentModel alloc]init];  //上传评论数据的 model
    
    tempModel.content = self.inputTextView.text;
    __block NSNumber *num = [NSNumber numberWithInteger:[self.selectIndex  integerValue] - 1];
    __block CircleContextModel *model = [self.modelArray objectAtIndex:[num integerValue]];
    if (state) {  //发给用户  flase
        tempModel.targetUserId = model.poster.ID;  // 这个要改
        tempModel.contentId = model.ID;  //这个也要改
        
    } else
    {
        tempModel.targetUserId = tergetUserId;
        tempModel.contentId = contentId;
    }
    
    tempModel.kind = @"comment";
    [tempModel setIsOnlyToContent:state];
    
    [RestfulAPIRequestTool routeName:@"publisheCircleComments" requestModel:tempModel useKeys:@[@"contentId", @"kind", @"content", @"isOnlyToContent", @"targetUserId"] success:^(id json) {
        NSLog(@"评论成功 %@",json);
        self.inputTextView.text = nil;
        [self.inputTextView resignFirstResponder];
        
        CircleContextModel *temp = [[CircleContextModel alloc]init];
        NSDictionary *circleComment = [json objectForKey:@"circleComment"];
        [temp setValuesForKeysWithDictionary:circleComment];
        NSDictionary *dic = [circleComment objectForKey:@"poster"];
        temp.poster = [[AddressBookModel alloc]init];
        [temp.poster setValuesForKeysWithDictionary:dic];
        if ([circleComment objectForKey:@"target"]) {
            NSDictionary *target = [circleComment objectForKey:@"target"];
            temp.target = [[AddressBookModel alloc]init];
            [temp.target setValuesForKeysWithDictionary:target];
        }

        if (!model.comments)
        {
            model.comments = [NSMutableArray new];
        }
        [model.comments addObject:temp];
        [model save];
        NSMutableDictionary *tempMuDic = [self getViewWithModel:model];
        NSArray *array = tempMuDic[@"photoArray"];
        
        [tempMuDic removeObjectForKey:@"photoArray"];
        
        [self.photoArray replaceObjectAtIndex:[num integerValue] withObject:array];
        [self.userInterArray replaceObjectAtIndex:[num integerValue] withObject:tempMuDic];
        [self.modelArray replaceObjectAtIndex:[num integerValue] withObject:model];
        [self.colleagueTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[num integerValue] inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
        
//        [self.colleagueTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects: count:<#(NSUInteger)#>] withRowAnimation:UITableViewRowAnimationTop];
//        [self netRequest];
        
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
    [dic setObject:model.postUserId forKey:@"targetUserId"];
    [dic setObject:model.ID forKey:@"contentId"];
    [tempModel setValuesForKeysWithDictionary:dic];
    [tempModel setIsOnlyToContent:true];

    NSString *routeString = nil;
    CriticWordView *criView = (CriticWordView *)sender.view;
    NSArray *temp = [NSArray array];
    __block NSString *nsl = nil;
    if ([criView.criticIamge.image isEqual:[UIImage imageNamed:@"DonLike"]]) {
        routeString = @"publisheCircleComments";
        temp = @[@"contentId", @"kind", @"content", @"isOnlyToContent", @"targetUserId"];
        criView.criticIamge.image = [UIImage imageNamed:@"Like"];
        nsl = @"点赞成功";
        criView.criticText.text = [NSString stringWithFormat:@"%ld", ([criView.criticText.text integerValue] + 1)];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[userId] forKeys:@[@"_id"]];
        
        [model.commentUsers addObject:dic];
    } else
    {
        for (NSDictionary *dic in model.commentUsers) {
            if ([userId isEqualToString:[dic objectForKey:@"_id"]]) { // 如果是本人的话
                tempModel.commentId = [dic objectForKey:@"_id"];
            }
        }
        BOOL state = NO;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < model.commentUsers.count; i++) {
            
            NSDictionary *dic = [model.commentUsers objectAtIndex:i];
            if ([[dic objectForKey:@"_id"] isEqualToString:userId]) {
                state = YES;
                [tempArray addObject:dic];
                break;
            }
        }
        if (state == YES) {  // 自己点过赞
            [model.commentUsers removeObjectsInArray:tempArray];
        }
        
        criView.criticText.text = [NSString stringWithFormat:@"%ld", ([criView.criticText.text integerValue] - 1)];
        criView.criticIamge.image = [UIImage imageNamed:@"DonLike"];
        nsl = @"取消赞成功";
        routeString = @"deleteCompanyCircle";
        temp = @[@"contentId", @"commentId"];
    }
    
    [RestfulAPIRequestTool routeName:routeString requestModel:tempModel useKeys:temp success:^(id json) {
        
        NSLog(@"%@ %@", nsl, json);
        [self.inputTextView resignFirstResponder];
        
    } failure:^(id errorJson) {
        NSLog(@"%@", errorJson);
    }];
}

- (void)jumpPageWithDic:(CircleContextModel *)dic andPoster:(NSString *)string
{
    ColleaguesInformationController *coll = [[ColleaguesInformationController alloc]init];
    coll.attentionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //    AddressBookModel *model = [[AddressBookModel alloc]init];
    //    [model setValuesForKeysWithDictionary:[dic objectForKey:string]];
    
    coll.model = [[AddressBookModel alloc]init];
    coll.model = dic.poster;
    [self.navigationController pushViewController:coll animated:YES];
}


-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UILabel *)getLabelFromString:(NSString *)contentStr andHeight:(CGFloat)overHeight
{
    CGRect rect = [self getRectWithFont:[UIFont systemFontOfSize:TEXTFONT] width:DLMultipleWidth(LABELWIDTH) andString:contentStr];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, overHeight, DLMultipleWidth(LABELWIDTH), rect.size.height )];
    label.numberOfLines = 0;
    //            label.backgroundColor = [UIColor greenColor];
    label.text = contentStr;
    label.font = [UIFont systemFontOfSize:TEXTFONT];
    return label;
}

- (void)imageAction:(UITapGestureRecognizer *)tap
{
    UIImageView *image = (UIImageView *)tap.view;
    NSLog(@"点击的 image 为  %@",  image);
    NSLog(@"%ld", tap.view.superview.tag);
    
    NSInteger num = tap.view.superview.tag;
    
    NSArray * array  = [self.photoArray objectAtIndex:num - 1];
    
    PhotoPlayController *play = [[PhotoPlayController alloc]initWithPhotoArray:array indexOfContentOffset:(tap.view.tag - 1)];
    NSLog(@"传过去 %@  下标为 %ld",  array, tap.view.tag - 1);
    [self.navigationController pushViewController:play animated:YES];
    
}
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void)sendSingerCircle:(id)json
{
    [self.colleagueTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    NSLog(@"数据为   %@", json);
    
    NSDictionary *circleContent = json[@"circleContent"];
    
    CircleContextModel *cir = [[CircleContextModel alloc] init];
    [cir setValuesForKeysWithDictionary:circleContent];
    
    
    

    //    NSLog(@"%@    %@", cir.content, cir.poster.ID);
    //
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"IDArray"];
    
    NSMutableArray *IDArray = [NSMutableArray arrayWithContentsOfFile:path];
    
        NSMutableDictionary *viewDic = [self getViewWithModel:cir];
        NSArray *tempPhotoArray = [viewDic objectForKey:@"photoArray"];
        [viewDic removeObjectForKey:@"photoArray"];
    
    [IDArray insertObject:cir.postUserId atIndex:0];
    [self.photoArray insertObject:tempPhotoArray atIndex:0];
    [self.userInterArray insertObject:viewDic atIndex:0];
    [self.modelArray insertObject:cir atIndex:0];
    [self.colleagueTable reloadData];
    
    
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}
//
////按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    NSIndexPath *ip = [self.colleagueTable indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
//    NSIndexPath *cip = [[self.colleagueTable indexPathsForVisibleRows] firstObject];
//    NSInteger skipCount = 8;
//    if (labs(cip.row-ip.row)>skipCount) {
//        NSArray *temp = [self.colleagueTable indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.colleagueTable.width, self.colleagueTable.height)];
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
//        if (velocity.y<0) {
//            NSIndexPath *indexPath = [temp lastObject];
//            if (indexPath.row+33) {
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
//                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
//            }
//        }
////        [needLoadArr addObjectsFromArray:arr];
//    }
//}
@end
