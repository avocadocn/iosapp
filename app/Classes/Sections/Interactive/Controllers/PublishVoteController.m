//
//  PublishVoteController.m
//  app
//
//  Created by 申家 on 15/8/7.
//  Copyright (c) 2015年 Donler. All rights reserved.
//
#import "Account.h"
#import "AccountTool.h"
#import "PublishVoteController.h"
#import <Masonry.h>
#import "optionsView.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RestfulAPIRequestTool.h"
#import "Interaction.h"
#import "GiFHUD.h"

static NSInteger num = 0;

@interface PublishVoteController ()<DNImagePickerControllerDelegate,UIAlertViewDelegate>

@property(nonatomic, strong)GiFHUD *gifImage;

@end

@implementation PublishVoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GiFHUD setGifWithImageName:@"myGif.gif"];
    [self builtInterface];
    if (self.model) {
        NSLog(@"%@",self.model);
        [self addTemplate:self.model];
    }
    
}

- (void)builtInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationItem];
    [self setCardView];
}


- (void)setCardView
{
    num = 2;
    
    self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DLScreenWidth, DLScreenHeight - 64)];
    [self.view addSubview:self.bigView];
    
    self.voteTitle = [UITextField new];
    self.voteTitle.placeholder = @"投票题目";
    [self.voteTitle placeholder];
    self.voteTitle.font = [UIFont systemFontOfSize:15];
    self.voteTitle.textAlignment = NSTextAlignmentLeft;
    
    [self.bigView addSubview:self.voteTitle];
    
    [self.voteTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bigView.mas_top);
        make.left.mas_equalTo(self.bigView.mas_left).offset(15);
        make.right.mas_equalTo(self.bigView.mas_right).offset(-15);
        make.height.mas_equalTo(DLMultipleHeight(50.0));
    }];
    
    UIView *lineVIew = [UIView new];
    [lineVIew setBackgroundColor:[UIColor lightGrayColor]];
    [self.bigView addSubview:lineVIew];
    
    [lineVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.voteTitle.mas_bottom);
        make.left.mas_equalTo(self.voteTitle.mas_left);
        make.right.mas_equalTo(self.voteTitle.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    for (NSInteger i = 0; i < 2; i++) {
        optionsView *customView = [[optionsView alloc]initWithFrame:CGRectMake(DLMultipleWidth(15.0), DLMultipleHeight(50.0) + i * DLMultipleHeight(50.0), DLMultipleWidth(345.0), DLMultipleHeight(50.00)) andTag:(i + 1)];
        [self.bigView addSubview:customView];
    }
    self.insertOptionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.insertOptionButton setTitle:@"添加选项" forState:UIControlStateNormal];
    self.insertOptionButton.frame = CGRectMake(DLMultipleWidth(35.0), DLMultipleHeight(150.0), DLMultipleWidth(100.0), DLMultipleHeight(50.0));
    [self.insertOptionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.insertOptionButton addTarget:self action:@selector(insertOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bigView addSubview:self.insertOptionButton];
    
    self.buttonLineView = [UIView new];
    [self.buttonLineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.bigView addSubview:self.buttonLineView];
    [self.buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.insertOptionButton.mas_top);
        make.left.mas_equalTo(lineVIew.mas_left);
        make.right.mas_equalTo(lineVIew.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    self.selectPhoto = [UIImageView new];
    self.selectPhoto.userInteractionEnabled = YES;
//    self.selectPhoto.contentMode = UIViewContentModeCenter;
    self.selectPhoto.image = [UIImage imageNamed:@"image"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhotoAction:)];
    [self.selectPhoto addGestureRecognizer:tap];
    [self.bigView addSubview:self.selectPhoto];
    
    [self.selectPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonLineView.mas_bottom).offset(DLMultipleHeight(50.0));
        make.left.mas_equalTo(self.voteTitle.mas_left);
        make.size.mas_equalTo(CGSizeMake(DLMultipleWidth(50.0), DLMultipleWidth(50.0)));
    }];
}

- (void)selectPhotoAction:(UITapGestureRecognizer *)sender
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
        self.selectPhoto.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)arrangeStartWithArray:(NSMutableArray *)array
{
    self.selectPhoto.image = [array lastObject];
}


- (void)insertOptionAction:(UIButton *)sender
{
    if (num < 3) {
    [UIView animateWithDuration:.1 animations:^{
        
    optionsView *view = [[optionsView alloc]initWithFrame:CGRectMake(DLMultipleWidth(15.0), DLMultipleHeight(50.0) + num * DLMultipleHeight(50.0), DLMultipleWidth(345.0), DLMultipleHeight(50.00)) andTag:(num + 1)];
        [self.bigView addSubview:view];
    self.insertOptionButton.centerY = view.centerY + DLMultipleHeight(50);
    
    [self.buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.insertOptionButton.mas_top);
    }];
    num ++;
    }];
    } else
    {
        [UIView animateWithDuration:.1 animations:^{
            
            optionsView *view = [[optionsView alloc]initWithFrame:CGRectMake(DLMultipleWidth(15.0), DLMultipleHeight(50.0) + num * DLMultipleHeight(50.0), DLMultipleWidth(345.0), DLMultipleHeight(50.00)) andTag:(num + 1)];
            [self.bigView addSubview:view];
            [self.insertOptionButton removeFromSuperview];
            
            [self.buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view.mas_bottom);
            }];
            num ++;
        }];
    }
}

- (void)publishAction:(UIButton *)sender
{
    [GiFHUD show];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSInteger i = 1; i <= num; i ++) {
        optionsView *View = (optionsView *)[self.bigView viewWithTag:i];
        NSString *str = View.optionTextField.text;
        [titleArray addObject:str];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSData *data= UIImagePNGRepresentation(self.selectPhoto.image);
    [dic setObject:data forKey:@"data"];
    [dic setObject:@"photo" forKey:@"name"];
    
    Interaction *inter = [[Interaction alloc]init];
    [inter setType:@2]; //投票
    [inter setTheme:self.voteTitle.text];
    [inter setLocation:@"上海"];
    [inter setOption:titleArray];
    [inter setPhoto:@[dic]];
    Account *acc = [AccountTool account];
    if(self.isTemplate){
        [inter setTarget:self.model.target];
        [inter setTargetType:self.model.targetType];
        [inter setTemplateId:self.model.ID];
    }else{
        [inter setTarget:acc.cid];
        [inter setTargetType:@3];
    }
    
    [inter setContent:@"投票"];
    [inter setEndTime:@"2015-09-30 19:56"];
    [RestfulAPIRequestTool routeName:@"sendInteraction" requestModel:inter useKeys:@[@"type", @"target", @"relatedTeam", @"targetType", @"templateId", @"inviters",@"photo", @"theme", @"content", @"endTime", @"startTime", @"deadline", @"remindTime", @"activityMold", @"location", @"latitude", @"longitude", @"memberMax", @"memberMin", @"option", @"tags"] success:^(id json) {
        NSLog(@"发布投票成功%@", json);
        [GiFHUD dismiss];
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发布成功"message:@"少年郎,你的活动已经发布成功了,好好准备吧..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertV show];

    } failure:^(id errorJson) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发布失败" message:[errorJson objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"嗯嗯,知道了", nil];
        [alertV show];
        [GiFHUD dismiss];        
        NSLog(@"发布投票失败%@", errorJson);
    }];
    
}
#pragma UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KPOSTNAME" object:nil userInfo:@{@"name":@"家豪"}];
    }
    
}
- (void)setNavigationItem
{
    self.title = @"发布投票";
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 0, 60, 20);
    [cancelButton setTitleColor:[UIColor colorWithWhite:.5 alpha:.5] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    publishButton.frame = CGRectMake(0, 0, 60, 20);
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishButton];
    
}

- (void)cancelButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)addTemplate:(Interaction *)templateData
{
    [self.voteTitle setText:templateData.theme];
    NSInteger count = templateData.option.count;
    if (count == 1) {
        optionsView *option1 = (optionsView*)[self.bigView viewWithTag:1];
        [option1.optionTextField setText:[[templateData.option objectAtIndex:0] valueForKey:@"value"]];
    }else if (count == 2||count >=3) {
        optionsView *option1 = (optionsView*)[self.bigView viewWithTag:1];
        [option1.optionTextField setText:[[templateData.option objectAtIndex:0] valueForKey:@"value"]];
        optionsView *option2 = (optionsView*)[self.bigView viewWithTag:2];
        [option2.optionTextField setText:[[templateData.option objectAtIndex:1] valueForKey:@"value"]];
    }
    if (count>=3) {
        for (int i=2; i<count; i++) {
            [UIView animateWithDuration:.1 animations:^{
                
                optionsView *view = [[optionsView alloc]initWithFrame:CGRectMake(DLMultipleWidth(15.0), DLMultipleHeight(50.0) + i * DLMultipleHeight(50.0), DLMultipleWidth(345.0), DLMultipleHeight(50.00)) andTag:(i + 1)];
                [view.optionTextField setText:[[templateData.option objectAtIndex:i] valueForKey:@"value"]];
                [self.bigView addSubview:view];
                self.insertOptionButton.centerY = view.centerY + DLMultipleHeight(50);
                
                [self.buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.insertOptionButton.mas_top);
                }];
            }];
        }
    }
    num = count;
}
@end
