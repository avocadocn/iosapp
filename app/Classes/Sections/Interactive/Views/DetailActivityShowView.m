//
//  DetailActivityShowView.m
//  app
//
//  Created by 张加胜 on 15/7/20.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "DetailActivityShowView.h"
#import "Interaction.h"
#import "RestfulAPIRequestTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+DLGetWebImage.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "GTMNSString+HTML.h"
@interface DetailActivityShowView()<UIScrollViewDelegate,MAMapViewDelegate,AMapSearchDelegate,UIWebViewDelegate>

{
    MAMapView *_mapView; // 创建地图
    CLLocationManager * locationManager; // 创建定位定位管理
     AMapSearchAPI *_search; // 搜索
}


@property (strong,nonatomic) UIScrollView *superView;
@property (strong,nonatomic) UIImageView *pictureView; // 顶部照片
@property (assign,nonatomic) CGFloat imageViewWidth;
@property (assign,nonatomic) CGFloat imageViewHeight;
@property (strong, nonatomic)UILabel *activityName;  //@"林肯公园演唱会"
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, copy)NSString *url;

@property (nonatomic, strong)UIButton *applyBtn; // 报名按钮
@property (nonatomic, copy) NSString *introduceStr; // 活动介绍
@property (nonatomic, strong) UIWebView* introduceWebView;
@property (nonatomic, strong) UIView *introduceView;
@property (nonatomic, copy) NSString *addressStr;



@end
@implementation DetailActivityShowView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithModel:(Interaction *)model
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
        self.model = [[Interaction alloc]init];
        self.model = model;
        
        [self buildInterface];
        [self getState]; // 获得报名状态
        [self initMapView]; // 创建地图
        [self buildMAPinAnnotationView];
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateImg];
}


- (void)updateImg {
    CGFloat yOffset   = self.superView.contentOffset.y + 64;
    // NSLog(@"%f",yOffset);
    if (yOffset < 0) {
        
        CGFloat factor = ((ABS(yOffset)+self.imageViewHeight)*self.imageViewWidth)/self.imageViewHeight;
        CGRect f = CGRectMake(-(factor-self.imageViewWidth)/2, 0, factor, self.imageViewHeight+ABS(yOffset));
        self.pictureView.frame = f;
        self.pictureView.y += yOffset;
    }
}
- (void)initMapView {
    [MAMapServices sharedServices].apiKey = @"4693df7c11ba3ba2cc58e44e8666134f";
    
    
    locationManager =[[CLLocationManager alloc] init];
    // fix ios8 location issue
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [locationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist中需要NSLocationAlwaysUsageDescription
        }
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
        }
#endif
    }
    
    
    _mapView = [[MAMapView alloc] init];
    _mapView.width = DLScreenWidth;
    _mapView.height = DLScreenWidth * 2 / 4;
    _mapView.x = 0;
    _mapView.y = CGRectGetMaxY(self.addressLabel.frame) + 10;
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MAMapTypeStandard;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    [self.midView addSubview:_mapView];

}
- (void)builtSearch {
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"4693df7c11ba3ba2cc58e44e8666134f" Delegate:self];
    
    //  逆地理编码
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:[self.model.latitude floatValue] longitude:[self.model.longitude floatValue]];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}



-(void)buildInterface{
    
    UIScrollView *superView = [[UIScrollView alloc]init];
    [superView setDelegate:self];
    [superView setFrame:self.frame];
    [superView setBounces:YES];
    
    // 顶部带有图片的视图
    UIView *topPictureView = [[UIView alloc]init];
    [topPictureView setBackgroundColor:[UIColor whiteColor]];
    
    // 添加活动图片
    self.pictureView = [UIImageView new];
    CGFloat imageViewWidth = DLScreenWidth;
    CGFloat imageViewHeight = imageViewWidth * 4 / 5;
    self.imageViewWidth = imageViewWidth;
    self.imageViewHeight = imageViewHeight;
    [self.pictureView setFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    [self.pictureView setBackgroundColor:[UIColor redColor]];
//    UIImage *img = [UIImage imageNamed:@"2.jpg"];
    for (NSDictionary *dic in self.model.photos) {
        self.url = dic[@"uri"];
    }
    [self.pictureView dlGetRouteWebImageWithString:self.url placeholderImage:[UIImage imageNamed:@"2.jpg"]];
    
    [self.pictureView setClipsToBounds:YES];
//    [self.pictureView setImage:img];
    [self.pictureView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.pictureView = self.pictureView;
    // 活动名称label
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    self.activityName = [[UILabel alloc]init];
    self.activityName.textColor = [UIColor blackColor];
    [self.activityName setFont:font];
    NSString *nameText = self.model.theme;
    //    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,font, nil];
    //    // CGSize size = [nameText sizeWithAttributes:attr];
    //    NSLog(@"%@",NSStringFromCGSize(size));
    [self.activityName setText:nameText];
    [self.activityName setSize:CGSizeMake(DLScreenWidth, 14)];
    [self.activityName setTextAlignment:NSTextAlignmentCenter];
    self.activityName.centerX = DLScreenWidth / 2;
    self.activityName.y = CGRectGetMaxY(self.pictureView.frame) + 13;
    
    
    
    // 添加感兴趣按钮，需要根据图片自定义
//    UIButton *interest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [interest setTitle:@"感兴趣" forState:UIControlStateNormal];
//    [interest setSize:CGSizeMake(100, 25)];
//    interest.centerX = DLScreenWidth / 2;
//    interest.y = CGRectGetMaxY(self.activityName.frame) + 13;
    
    [topPictureView addSubview:self.pictureView];
    [topPictureView addSubview:self.activityName];
//    [topPictureView addSubview:interest];
    
    // 设置顶部pic view的frame
    topPictureView.height = CGRectGetMaxY(self.pictureView.frame) + 35;
    topPictureView.width = DLScreenWidth;
    [topPictureView setOrigin:CGPointZero];
    
    [superView addSubview:topPictureView];
    
    // 添加中部时间地址view
    UIView *middleView = [[UIView alloc]init];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    
    // 添加时间label
    UILabel *timeLabel = [[UILabel alloc]init];
    NSString *timeString = [NSString stringWithFormat:@"时间:  \%@--%@",[self getParsedDateStringFromString:[self.model.activity objectForKey:@"startTime"]],[self getParsedDateStringFromString:self.model.endTime]];
    
    NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    [mutableAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    [timeLabel setAttributedText:mutableAttrStr];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    
    // 设置label的frame
    [timeLabel setFrame:CGRectMake(10, 15, DLScreenWidth, 30)];
    
    // 添加分割线
    UIView *divisionLine = [[UIView alloc]init];
    [divisionLine setBackgroundColor:[UIColor lightGrayColor]];
    [divisionLine setAlpha:0.3f];
    divisionLine.width = DLScreenWidth - 2 * 9;
    divisionLine.height = 1;
    divisionLine.x = 9;
    divisionLine.y = CGRectGetMaxY(timeLabel.frame);
    
    // 添加地址label
    UIFont *addressFont = [UIFont systemFontOfSize:13.0f];
    CGSize TintLabelSize = CGSizeMake(DLScreenWidth, MAXFLOAT);
    
    UILabel *addressTintLabel = [[UILabel alloc]init];
    NSString *addressTintStr = @"地址: ";
    CGSize addressTintLabelSize = [addressTintStr sizeWithFont:addressFont constrainedToSize:TintLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [addressTintLabel setText:addressTintStr];
    [addressTintLabel setFont:addressFont];
    [addressTintLabel setTextColor:[UIColor grayColor]];
    // tintLabel的frame
    addressTintLabel.size = addressTintLabelSize;
    addressTintLabel.x = 10;
    addressTintLabel.y = CGRectGetMaxY(divisionLine.frame) + 12;
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.lineBreakMode = UILineBreakModeWordWrap;
    addressLabel.numberOfLines = 0;
    // TODO
    if ([[[self.model.activity objectForKey:@"location"] objectForKey:@"name"] containsString:@"："]) {
        self.addressStr = [[NSString stringWithFormat:@"%@",[[self.model.activity objectForKey:@"location"] objectForKey:@"name"]] substringFromIndex:5];
    } else {
        self.addressStr = [NSString stringWithFormat:@"%@",[[self.model.activity objectForKey:@"location"] objectForKey:@"name"]];
    }
    CGSize maxLabelSize = CGSizeMake(DLScreenWidth - 2 * 10 - addressTintLabelSize.width, MAXFLOAT);
//    NSString *str = [[NSString stringWithFormat:@"%@",[[self.model.activity objectForKey:@"location"] objectForKey:@"name"]] substringFromIndex:4];
    NSString *addressText = self.addressStr;
    
    CGSize trueLabelSize = [addressText sizeWithFont:addressFont constrainedToSize:maxLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [addressLabel setFont:addressFont];
    NSMutableAttributedString *addressMAS = [[NSMutableAttributedString alloc]initWithString:addressText];
    
    [addressLabel setAttributedText:addressMAS];
    
    // 设置地址label的frame
    addressLabel.size = trueLabelSize;
    addressLabel.x = CGRectGetMaxX(addressTintLabel.frame);
    addressLabel.y = CGRectGetMaxY(divisionLine.frame) + 12;
    self.addressLabel = addressLabel;
    
    
    
    
    
    // 地图view
    UIImage *mapImg = [UIImage imageNamed:@"map"];
    UIImageView *mapView = [[UIImageView alloc]initWithImage:mapImg];
    [mapView setContentMode:UIViewContentModeScaleAspectFill];
    [mapView setClipsToBounds:YES];
    
    // mapView frame
    mapView.width = DLScreenWidth;
    mapView.height = DLScreenWidth * 2 / 4;
    mapView.x = 0;
    mapView.y = CGRectGetMaxY(addressLabel.frame) + 10;
    
    UILabel *personCountLabel = [[UILabel alloc]init];
    UIFont *personCountLabelFont = [UIFont systemFontOfSize:13.0f];
    [personCountLabel setFrame:CGRectMake(10, CGRectGetMaxY(mapView.frame) + 15, DLScreenWidth - 2 * 10, 20)];
    [personCountLabel setFont:personCountLabelFont];
    NSInteger personCount = 18;
    NSString *personCountLabelText = [NSString stringWithFormat:@"报名人数:  %zd人", [self.model.members count]];
    NSMutableAttributedString *personMAS = [[NSMutableAttributedString alloc]initWithString:personCountLabelText];
    [personMAS addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    [personCountLabel setAttributedText:personMAS];
    
    
    
    // 设置中部view的frame
    middleView.y = CGRectGetMaxY(topPictureView.frame) + 12;
    middleView.x = 0;
    middleView.width = DLScreenWidth;
    middleView.height = CGRectGetMaxY(personCountLabel.frame) + 14;
    
    [middleView addSubview:timeLabel];
    [middleView addSubview:divisionLine];
    [middleView addSubview:addressTintLabel];
    [middleView addSubview:addressLabel];
//    [middleView addSubview:mapView];
    [middleView addSubview:personCountLabel];
    self.midView = middleView;
    [superView addSubview:middleView];
    
    // 添加第三栏的活动介绍view
    UIView *introduceView = [[UIView alloc]init];
    self.introduceView = introduceView;
    [introduceView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *activityIntroduceTV = [[UILabel alloc]init];
    UIFont *aITVFont = [UIFont systemFontOfSize:13.0f];
    [activityIntroduceTV setTextColor:[UIColor blackColor]];
    
    if ([self.model.targetType isEqualToNumber:@2]) {
        UIWebView *introduceWebView=[[UIWebView alloc] init];
        self.introduceWebView = introduceWebView;
        introduceWebView.width = DLScreenWidth;
        introduceWebView.height = DLScreenHeight * 2 / 4;
        introduceWebView.x = 0;
        introduceWebView.y = CGRectGetMaxY(activityIntroduceTV.frame)+12;
        introduceWebView.backgroundColor = [UIColor whiteColor];
        //for debug use
        //    [introduceWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        introduceWebView.delegate = self;
        introduceWebView.scrollView.bounces = NO;
        introduceWebView.scrollView.showsHorizontalScrollIndicator = NO;
        introduceWebView.scrollView.scrollEnabled = NO;
        NSString * htmlcontent = [NSString stringWithFormat:@"活动介绍\n<div id=\"webview_content_wrapper\">%@</div>", [self.model.content gtm_stringByUnescapingFromHTML]];
        [introduceWebView loadHTMLString:htmlcontent baseURL:nil];
        [self.introduceView addSubview:self.introduceWebView];
    } else {
       self.introduceStr = [NSString stringWithFormat:@"活动介绍\n%@",self.model.content];
//        self.introduceStr = self.model.content;
    }
    // TODO
    [activityIntroduceTV setText:self.introduceStr];
    CGSize maxAITVSize = CGSizeMake(DLScreenWidth - 2 * 10, MAXFLOAT);
    [activityIntroduceTV setFont:aITVFont];
    CGSize aITVSize = [self.introduceStr sizeWithFont:aITVFont constrainedToSize:maxAITVSize lineBreakMode:NSLineBreakByWordWrapping];
    //  AITV的frame
    activityIntroduceTV.size = aITVSize;
    activityIntroduceTV.x = 10;
    activityIntroduceTV.y = 6;
    activityIntroduceTV.lineBreakMode = UILineBreakModeWordWrap;
    activityIntroduceTV.numberOfLines = 0;
    
    introduceView.width = DLScreenWidth;
    introduceView.height = activityIntroduceTV.height + 16;
    introduceView.x = 0;
    introduceView.y = CGRectGetMaxY(middleView.frame) + 12;
    
    // 添加到根view中
    [introduceView addSubview:activityIntroduceTV];
    [superView addSubview:introduceView];
    
    // 设置contentoffset
    [superView setContentSize:CGSizeMake(DLScreenWidth, CGRectGetMaxY(introduceView.frame) + 44)];
    

    
    [self addSubview:superView];
    
    UIView *sighUpView = [[UIView alloc]init];
    [sighUpView setBackgroundColor:[UIColor whiteColor]];
    
    // 设置报名view的frame
    sighUpView.size = CGSizeMake(DLScreenWidth, 44);
    sighUpView.x = 0;
    sighUpView.y = DLScreenHeight - 44;
    
    UIButton *sighUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sighUpBtn.layer setMasksToBounds:YES];
    [sighUpBtn.layer setCornerRadius:10.0];
    self.applyBtn = sighUpBtn;
    sighUpBtn.superview.backgroundColor = [UIColor whiteColor];
    [sighUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    sighUpBtn.backgroundColor = [UIColor redColor];
    [sighUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sighUpBtn.width = DLScreenWidth - 2 * 10;
    sighUpBtn.height = 28;
    sighUpBtn.x = 10;
    sighUpBtn.y = sighUpView.height / 2 - sighUpBtn.height / 2;
    [sighUpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // btn添加到view中
    [sighUpView addSubview:sighUpBtn];
    [self addSubview:sighUpView];
    
    
    self.superView = superView;
    
    
}

-(void)btnClick:(UIButton *)sender{
    sender.backgroundColor = [UIColor lightGrayColor];
    sender.userInteractionEnabled = NO;
    NSLog(@"btn Clicked");
    Account *account = [AccountTool account];
    [self.model setInteractionId:self.model.interactionId];
    [self.model setUserId:account.ID];
    [RestfulAPIRequestTool routeName:@"joinInteraction" requestModel:self.model useKeys:@[@"interactionId",@"userId"] success:^(id json) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"报名成功" message:@"少年,恭喜你报名成功了" delegate:nil cancelButtonTitle:@"哇,好高兴" otherButtonTitles:nil, nil];
        [alertV show];
        [sender setTitle:@"已经报名" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KPOSTNAME" object:nil];
    } failure:^(id errorJson) {
        NSLog(@"报名失败的原因 %@",[errorJson valueForKey:@"msg"]);
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"报名失败" message:[errorJson valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"嗯嗯,知道了" otherButtonTitles:nil, nil];
        [alertV show];
        [sender setTitle:[NSString stringWithFormat:@"%@",[errorJson valueForKey:@"msg"]] forState:UIControlStateNormal];
    }];

}

- (void)getState { // 获取报名状态
    Account *account = [AccountTool account];
    NSArray *array = self.model.members;
    if ([array containsObject:account.ID]) {
        [self.applyBtn setTitle:[NSString stringWithFormat:@"%@",@"已经报名"] forState:UIControlStateNormal];
        self.applyBtn.backgroundColor = [UIColor lightGrayColor];
        self.applyBtn.userInteractionEnabled = NO;
    }
    
}

#pragma AMapSearchDelegate
// 实现逆地理编码对应的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(response.regeocode != nil) {
        //处理搜索结果
      
    }
}

#pragma MAPinAnnotationView // 大头针
- (void)buildMAPinAnnotationView {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    NSArray *array = [[[self.model.activity objectForKey:@"location"] objectForKey:@"loc"] objectForKey:@"coordinates"];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([[array lastObject] floatValue], [[array firstObject] floatValue]); //
    _mapView.centerCoordinate = pointAnnotation.coordinate; // 取出大头针的坐标设为地图中心点
    pointAnnotation.title = self.model.theme;
    pointAnnotation.subtitle = [[self.model.activity objectForKey:@"location"] objectForKey:@"name"];
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mapViewDelegate

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{ // 大头针
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES; //设置气泡可以弹出,默认为 NO annotationView.animatesDrop = YES; //设置标注动画显示,默认为 NO
        annotationView.draggable = YES; //设置标注可以拖动,默认为 NO annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    
    return nil;
}


#pragma 转换时间
- (NSString*)getParsedDateStringFromString:(NSString*)dateString
{
    if (dateString==nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd'T'HH:mm:ss.SSS'Z'"];
    NSDate * date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"yyyy.MM.dd"];
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
#pragma UIWebviewDelegate
//加载完成后，对网页内容进行处理
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置图片缩放
    NSString* resizeImg = [NSString stringWithFormat:@"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"function ResizeImages() { "
                           "var myimg,oldwidth;"
                           "var maxwidth = %f;" // UIWebView中显示的图片宽度
                           "for(i=0;i <document.images.length;i++){"
                           "myimg = document.images[i];"
                           "if(myimg.width > maxwidth){"
                           "oldwidth = myimg.width;"
                           "myimg.width = maxwidth;"
                           "}"
                           "}"
                           "}\";"
                           "document.getElementsByTagName('head')[0].appendChild(script);",DLScreenWidth-20];
    [webView stringByEvaluatingJavaScriptFromString:resizeImg];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //设置页面缩放
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    //设置字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5f5f5f'"];
    
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(webView.x, webView.y, self.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    //这样换算会有问题，所以先注释
    //    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    webView.frame = CGRectMake(webView.x, webView.y, self.frame.size.width, height);
    //修正外部控件高度
    self.introduceView.height = CGRectGetMaxY(self.introduceWebView.frame);
    [self.superView setContentSize:CGSizeMake(DLScreenWidth, CGRectGetMaxY(self.introduceView.frame) + 44)];
    NSLog(@"webView frame %@",NSStringFromCGRect(self.introduceWebView.frame));
    NSLog(@"introView frame %@",NSStringFromCGRect(self.introduceView.frame));
    [webView.layer setBorderColor:[[UIColor clearColor] CGColor]];
}





-(void)viewWillDisappear:(BOOL)animated { // 视图消失时停止定位 （节省资源）
    [self mapViewDidStopLocatingUser:_mapView];
}





@end
