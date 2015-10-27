//
//  CreateGroupController.m
//  app
//
//  Created by 申家 on 15/9/15.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "RestfulAPIRequestTool.h"
#import "CreateGroupController.h"
#import "GroupSelectView.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface CreateGroupController ()<UIScrollViewDelegate, DNImagePickerControllerDelegate>
@property (nonatomic, strong)UIScrollView *superScroll;
@property (nonatomic, strong)UIImageView *selectImage;
@property (nonatomic, strong)UITextField *nameTextfield;


@end

@implementation CreateGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self builtScrollView];
    [self builtFirstPage];
    [self builtSectionPage];
    [self builtThirdlyPage];
    [self creatSmallItem];
}

- (void)builtScrollView
{
    self.superScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
    self.superScroll.backgroundColor = RGBACOLOR(238, 238, 240, 1);
    self.superScroll.pagingEnabled = YES;
    self.superScroll.contentSize = CGSizeMake(DLScreenWidth * 3, 0);
    self.superScroll.userInteractionEnabled = YES;
    [self.superScroll addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollAction:)]];
    self.superScroll.delegate = self;
    [self.view addSubview:self.superScroll];
}

- (void)builtFirstPage
{
    self.title = @"(1/3)社团名和封面";
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((DLScreenWidth - 190) / 2.0, 12, 190, 224)];
    view.backgroundColor = [UIColor whiteColor];
    self.selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 186, 186)];
    self.selectImage.userInteractionEnabled = YES;
    self.selectImage.clipsToBounds = YES;
    self.selectImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.selectImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seleacImageViewAction:)]];
    [view addSubview:self.selectImage];
    self.nameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(2, 188, 186, 224 - 186 - 2)];
    self.nameTextfield.font = [UIFont systemFontOfSize:14];
    self.nameTextfield.placeholder =  @"输入你的社团名称";
    [view addSubview:self.nameTextfield];
    
    [self.superScroll addSubview:view];
    
}
- (void)creatSmallItem
{
    NSArray *array = @[
                       RGBACOLOR(255, 214, 0, 1),
                       [UIColor whiteColor],
                       RGBACOLOR(255, 214, 0, 1)
                       ];
    NSArray *title = @[@"下一步", @"下一步", @"完成"];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth / 2,  224 + 12 + 17 + 35, DLScreenWidth * 2, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.superScroll addSubview:lineView];
    
    for (int i = 0; i < 3; i++) {
        
        [self createButtonWithTag:i andBackColor:[array objectAtIndex:i] title:[title objectAtIndex:i]];
    }
    
    for (int i = 0; i < 2 ; i++) {
        UIView *yellow = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth * (i + 1) - 3, 224 + 12 + 17 + 35 - 3, 6, 6)];
        yellow.backgroundColor = RGBACOLOR(255, 214, 0, 1);
        yellow.layer.masksToBounds = YES;
        yellow.layer.cornerRadius = 3;
        [self.superScroll addSubview:yellow];
    }
}

- (void)createButtonWithTag:(int)num andBackColor:(UIColor *)color title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame =  CGRectMake((num * DLScreenWidth) + (DLScreenWidth - 70) / 2.0, 224 + 12 + 17, 70, 70);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.backgroundColor = RGBACOLOR(255, 214, 0, 1);
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = num + 1;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 35;
    
    [self.superScroll addSubview:button];
    
}


- (void)builtSectionPage
{
    NSArray *array = @[@"公开", @"验证"];
    NSArray *a = @[@"公开所有人可见 不公开不能搜索到", @"加入群组是否需要创建人同意"];
    int i = 0;
    for (NSString * str in array) {
        GroupSelectView *view = [[GroupSelectView alloc]initWithFrame:CGRectMake(DLScreenWidth, 20 + (84 + 20) * i, DLScreenWidth, 84) andTitle:str requite:[a objectAtIndex:i]];
        [self.superScroll addSubview:view];
        view.tag = i + 100;
        i++;
    }
}

- (void)builtThirdlyPage
{
    NSArray *arr = @[@"Profile@2x", @"Oval 2@2x", @"chat@2x"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in arr) {
        UIImage *im = [UIImage imageNamed:str];
        [array addObject:im];
    }
    
    CGFloat num = DLScreenWidth / (320 / 55.0);
    [self builtInterfaceWithNameArray:@[@"社团通讯录",@"微信",@"手机联系人"] imageArray:array andrect:CGRectMake(0, 0, num, num * 1.85) andCenterY:140];
    
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

- (void)nextButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
            case 3:
        {
            NSLog(@"请求网络");
            [self.navigationController popViewControllerAnimated:YES];
            
            [self createRequest];
            
            break;
        }
        default:
        {
            [UIView animateWithDuration:.4 animations:^{
                
                self.superScroll.contentOffset = CGPointMake(DLScreenWidth * sender.tag, -64);
            }];
            
        }
            break;
    }
}


- (void)createRequest
{
    //创建群组
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:self.nameTextfield.text forKey:@"name"];
    
    NSMutableDictionary *photo =[NSMutableDictionary dictionary];
    [photo setObject:@"photo" forKey:@"name"];
    NSData *data = UIImagePNGRepresentation(self.selectImage.image);
    [photo setObject:data forKey:@"data"];
    NSArray *array = [NSArray arrayWithObject:photo];
    
    
    [dic setObject:array forKey:@"photo"];
    
    GroupSelectView *view = (GroupSelectView *)[self.superScroll viewWithTag:100];
    [dic setObject:[NSNumber numberWithBool:view.switchLabel.on] forKey:@"open"];

    GroupSelectView *view2 = (GroupSelectView *)[self.superScroll viewWithTag:101];
    [dic setObject:[NSNumber numberWithBool:view2.switchLabel.on] forKey:@"hasValidate"];
    [dic setObject:@0 forKey:@"isAdmin"];
    
    [RestfulAPIRequestTool routeName:@"publisheNewGroups" requestModel:dic useKeys:@[@"name", @"photo", @"hasValidate", @"open", @"isAdmin"] success:^(id json) {
        NSLog(@"建群成功 %@", json);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadGroup" object:nil userInfo:nil];
        
    } failure:^(id errorJson) {
        NSLog(@"建群失败 %@", errorJson);
    }];
}

- (NSInteger )getNumFromBool:(BOOL)state
{
    if (state == NO) {
        return 0;
    } else
    {
        return 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger num = scrollView.contentOffset.x / DLScreenWidth;
    NSArray *array = @[@"(1/3)社团名和封面", @"(2/3)社团类型", @"(3/3)邀请社员"];
    self.title = [array objectAtIndex:num];
    
}

- (void)seleacImageViewAction:(UITapGestureRecognizer *)tap
{
    DNImagePickerController *im = [[DNImagePickerController alloc]init];
    im.allowSelectNum = 1;
    im.imagePickerDelegate = self;
    [self.navigationController presentViewController:im animated:YES completion:nil];
}



- (void)builtInterfaceWithNameArray:(NSArray *)nameArray imageArray:(NSArray *)imageArray andrect:(CGRect)rect andCenterY:(NSInteger)num
{
//    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(DLScreenWidth * 2, 0, DLScreenWidth, DLScreenHeight)];
    
    int i = 0;
    CGFloat rote = rect.size.width / 2.0333;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((DLScreenWidth * 4 + DLScreenWidth - [nameArray count] * (rect.size.width + rote)) / 2.0, 0, [nameArray count] * (rect.size.width + rote), rect.size.height)];
    
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewAction:)];
        imageview.tag = i;
        
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
    [self.superScroll addSubview:view];
}

- (void)imageViewAction:(UITapGestureRecognizer *)tap
{

}

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
//    DNAsset *dnasser = [imageAssets firstObject];
//    ALAssetsLibrary *library = [ALAssetsLibrary new];
//    [library assetForURL:dnasser.url resultBlock:^(ALAsset *asset) {
//        
        self.selectImage.image = imageAssets[0];
        
//    } failureBlock:^(NSError *error) {
//        
//    }];
}

- (void)scrollAction:(UITapGestureRecognizer *)tap
{
    [self.nameTextfield resignFirstResponder];
}

@end
