//
//  TemplateDetailActivityShowView.m
//  app
//
//  Created by tom on 15/9/10.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TemplateDetailActivityShowView.h"
#import "Interaction.h"
#import "GTMNSString+HTML.h"
#import "Account.h"
#import "AccountTool.h"
#import "RestfulAPIRequestTool.h"
#import "UIImageView+DLGetWebImage.h"
#import "RepeaterGroupController.h"

@interface TemplateDetailActivityShowView()<UIScrollViewDelegate,UIWebViewDelegate>

@property (strong,nonatomic) UIScrollView *superView;
@property (strong,nonatomic) UIImageView *pictureView; // 顶部照片
@property (assign,nonatomic) CGFloat imageViewWidth;
@property (assign,nonatomic) CGFloat imageViewHeight;
@property (strong, nonatomic)UILabel *activityName;  //@"林肯公园演唱会"
@property (nonatomic, copy) NSString *url; // 图片链接
@property (nonatomic, strong) UIView* introduceView;
@property (nonatomic, strong) UIWebView* introduceWebView;
@end

@implementation TemplateDetailActivityShowView

- (instancetype)initWithModel:(Interaction *)model
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, DLScreenWidth, DLScreenHeight)];
        self.model = [[Interaction alloc]init];
        self.model = model;
        
        [self buildInterface];
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

/*
 *对服务器返回的时间做处理
 * format: xxxx.xx.xx
 */
- (NSString*)getParsedDateStringFromString:(NSString*)dateString
{
    if (dateString==nil) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
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
    [self.pictureView setClipsToBounds:YES];
    for (NSDictionary *dic in self.model.photos) {
        self.url = dic[@"uri"];
    }
    [self.pictureView dlGetRouteWebImageWithString:[NSString stringWithFormat:@"/%@",self.url] placeholderImage:[UIImage imageNamed:@"2.jpg"]];
    [self.pictureView setContentMode:UIViewContentModeScaleAspectFill];
    //    self.pictureView = self.pictureView;
    // 活动名称label
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    self.activityName = [[UILabel alloc]init];
    self.activityName.textColor = RGB(0x39, 0x37, 0x37);
    [self.activityName setFont:font];
    self.activityName.numberOfLines =0;
    NSString *nameText = self.model.theme;
//        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,font, nil];
//        // CGSize size = [nameText sizeWithAttributes:attr];
//        NSLog(@"%@",NSStringFromCGSize(size));
    CGSize maxActivityNameLabelSize = CGSizeMake(DLScreenWidth, MAXFLOAT);
    CGSize activityNameLabelSize = [nameText sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:maxActivityNameLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [self.activityName setText:nameText];
    [self.activityName setSize:activityNameLabelSize];
    [self.activityName setTextAlignment:NSTextAlignmentCenter];
    self.activityName.centerX = DLScreenWidth / 2;
    self.activityName.y = CGRectGetMaxY(self.pictureView.frame) + 13;
    
    
    [topPictureView addSubview:self.pictureView];
    [topPictureView addSubview:self.activityName];

    
    // 设置顶部pic view的frame
    topPictureView.height = CGRectGetMaxY(self.activityName.frame) + 13;
    topPictureView.width = DLScreenWidth;
    [topPictureView setOrigin:CGPointZero];
    
    [superView addSubview:topPictureView];
    
    // 添加中部时间地址view
    UIView *middleView = [[UIView alloc]init];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    
    // 添加时间label
    UILabel *timeTintLabel = [UILabel new];
    [timeTintLabel setTextColor:RGB(0x9b,0x9b, 0x9b)];
    [timeTintLabel setFont:[UIFont systemFontOfSize:14.0]];
    NSString* timeTintLabelStr = @"时间: ";
    CGSize maxTimeTintLabelSize = CGSizeMake(DLScreenWidth, MAXFLOAT);
    CGSize timeTintLabelSize = [timeTintLabelStr sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxTimeTintLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    timeTintLabel.text = timeTintLabelStr;
    timeTintLabel.frame= CGRectMake(10, 15, timeTintLabelSize.width, timeTintLabelSize.height);
    
    UILabel *timeLabel = [[UILabel alloc]init];
    CGSize maxTimeLabelSize = CGSizeMake(DLScreenWidth - 2 * 10 - timeTintLabel.width, MAXFLOAT);
    NSString *timeString = [NSString stringWithFormat:@"%@--%@",[self getParsedDateStringFromString:self.model.startTime],[self getParsedDateStringFromString:self.model.endTime]];
    CGSize timeLabelSize = [timeString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:maxTimeLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    NSMutableAttributedString *mutableAttrStr = [[NSMutableAttributedString alloc]initWithString:timeString];
    [mutableAttrStr addAttribute:NSForegroundColorAttributeName value:RGB(0x51,0x46, 0x47) range:NSMakeRange(0, timeString.length)];
    
    [timeLabel setAttributedText:mutableAttrStr];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    // 设置label的frame
    timeLabel.size = timeLabelSize;
    timeLabel.x =CGRectGetMaxX(timeTintLabel.frame);
    timeLabel.y =15;
    
    // 添加分割线
    UIView *divisionLine = [[UIView alloc]init];
    [divisionLine setBackgroundColor:RGB(0xe6,0xe6, 0xe6)];
    divisionLine.width = DLScreenWidth - 2 * DLMultipleWidth(11.0);
    divisionLine.height = 2;
    divisionLine.x = DLMultipleWidth(11.0);
    divisionLine.y = CGRectGetMaxY(timeLabel.frame) + 19;
    
    // 添加地址label
    UIFont *addressFont = [UIFont systemFontOfSize:14.0f];
    
    UILabel *addressTintLabel = [[UILabel alloc]init];
    CGSize maxAddressTintLabelSize = CGSizeMake(DLScreenWidth, MAXFLOAT);
    NSString *addressTintStr = @"地址: ";
    CGSize addressTintLabelSize = [addressTintStr sizeWithFont:addressFont constrainedToSize:maxAddressTintLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [addressTintLabel setText:addressTintStr];
    [addressTintLabel setFont:addressFont];
    [addressTintLabel setTextColor:RGB(0x9b,0x9b, 0x9b)];
    // tintLabel的frame
    addressTintLabel.size = addressTintLabelSize;
    addressTintLabel.x = DLMultipleWidth(11.0);
    addressTintLabel.y = CGRectGetMaxY(divisionLine.frame) + 17;
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.lineBreakMode = UILineBreakModeWordWrap;
    addressLabel.numberOfLines = 0;
    [addressLabel setTextColor:RGB(0x51,0x46, 0x47)];
    // TODO
    CGSize maxAddressLabelSize = CGSizeMake(DLScreenWidth - 2 * DLMultipleWidth(11.0) - addressTintLabelSize.width, MAXFLOAT);
    NSString *addressText = [NSString stringWithFormat:@"%@",[[self.model.location keyValues] objectForKey:@"name"]];
    
    CGSize trueLabelSize = [addressText sizeWithFont:addressFont constrainedToSize:maxAddressLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    [addressLabel setFont:addressFont];
    NSMutableAttributedString *addressMAS = [[NSMutableAttributedString alloc]initWithString:addressText];
    
    [addressLabel setAttributedText:addressMAS];
    
    // 设置地址label的frame
    addressLabel.size = trueLabelSize;
    addressLabel.x = CGRectGetMaxX(addressTintLabel.frame);
    addressLabel.y = CGRectGetMaxY(divisionLine.frame) + 17;
    
    // 地图view
    UIImage *mapImg = [UIImage imageNamed:@"map"];
    UIImageView *mapView = [[UIImageView alloc]initWithImage:mapImg];
    [mapView setContentMode:UIViewContentModeScaleAspectFill];
    [mapView setClipsToBounds:YES];
    
    // mapView frame
    mapView.width = DLScreenWidth;
    mapView.height = DLScreenWidth * 2 / 4;
    mapView.x = 0;
    mapView.y = CGRectGetMaxY(addressLabel.frame) + 14;
    
    
    // 设置中部view的frame
    middleView.y = CGRectGetMaxY(topPictureView.frame) + 10;
    middleView.x = 0;
    middleView.width = DLScreenWidth;
    middleView.height = CGRectGetMaxY(mapView.frame) + 14;
    
    [middleView addSubview:timeTintLabel];
    [middleView addSubview:timeLabel];
    [middleView addSubview:divisionLine];
    [middleView addSubview:addressTintLabel];
    [middleView addSubview:addressLabel];
    [middleView addSubview:mapView];
    [superView addSubview:middleView];
    
    //添加参与方式及已报名
    UIView * enterView = [UIView new];
    [enterView setBackgroundColor:[UIColor whiteColor]];
    //添加垂直装饰线
    UIView* verticalLine = [UIView new];
    verticalLine.frame = CGRectMake(DLMultipleWidth(10.0), 10, 2, 10);
    verticalLine.backgroundColor=RGB(0xfd, 0xb9, 0x0);
    //添加参与方式label
    UILabel* enterMethodLabel = [UILabel new];
    [enterMethodLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [enterMethodLabel setTextColor:RGB(0x51, 0x46, 0x47)];
    enterMethodLabel.width = DLScreenWidth-verticalLine.x-10;
    enterMethodLabel.height= 20;
    enterMethodLabel.x = verticalLine.x+8;
    enterMethodLabel.y = (enterMethodLabel.height+verticalLine.height)/2.0-verticalLine.y;

    enterMethodLabel.text = @"参与方式";
    UILabel* detailEnterMethodLabel = [UILabel new];
    detailEnterMethodLabel.frame = CGRectMake(20, CGRectGetMaxY(enterMethodLabel.frame) + 2, DLScreenWidth-20*2, 60);
    [detailEnterMethodLabel setFont:[UIFont systemFontOfSize:12.0f]];
    detailEnterMethodLabel.numberOfLines = 0;
    NSString * detailEnterMethodLabelStr = @"想参加的小伙伴请自行前往，请至相关网站进行购票。现场购票，门票市场价格。";
    //求出当前展示文本的高度
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName,nil];
    CGSize size =CGSizeMake(DLScreenWidth-CGRectGetMaxX(verticalLine.frame)-18,300);
    CGSize  actualsize =[detailEnterMethodLabelStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    detailEnterMethodLabel.size=actualsize;
    //
    NSMutableAttributedString *detailEnterMethodLabelAttrStr = [[NSMutableAttributedString alloc]initWithString:detailEnterMethodLabelStr];
    [detailEnterMethodLabelAttrStr addAttribute:NSForegroundColorAttributeName value:RGB(0x5f,0x5f,0x5f) range:NSMakeRange(0, [detailEnterMethodLabelAttrStr length])];
    [detailEnterMethodLabel setAttributedText:detailEnterMethodLabelAttrStr];
    
    enterView.x = 0;
    enterView.y = CGRectGetMaxY(middleView.frame) + 12;
    enterView.width = DLScreenWidth;
    enterView.height =CGRectGetMaxY(detailEnterMethodLabel.frame) + 10;
    [enterView addSubview:verticalLine];
    [enterView addSubview:enterMethodLabel];
    [enterView addSubview:detailEnterMethodLabel];
    [superView addSubview:enterView];
    //展示已报名人员
    UIView* signedInView = [UIView new];
    [signedInView setBackgroundColor:[UIColor whiteColor]];
    UIView* verticalLine1 = [UIView new];
    verticalLine1.frame = CGRectMake(DLMultipleWidth(10.0), 10, 2, 10);
    verticalLine1.backgroundColor=RGB(0xfd, 0xb9, 0);
    UILabel* signedInLabel = [UILabel new];
    [signedInLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [signedInLabel setTextColor:RGB(0x51, 0x46, 0x47)];
    signedInLabel.width = DLScreenWidth-verticalLine1.x-10;
    signedInLabel.height= 20;
    signedInLabel.x = verticalLine.x+8;
    signedInLabel.y = (signedInLabel.height+verticalLine1.height)/2.0-verticalLine1.y;
    signedInLabel.text = @"已报名";
    signedInView.x = 0;
    signedInView.y = CGRectGetMaxY(enterView.frame) + 12;
    signedInView.width = DLScreenWidth;
    signedInView.height =CGRectGetMaxY(signedInLabel.frame) + 14;
    [signedInView addSubview:verticalLine1];
    [signedInView addSubview:signedInLabel];
//    [superView addSubview:signedInView];
    
    // 添加活动介绍view
    UIView *introduceView = [[UIView alloc]init];
    [introduceView setBackgroundColor:[UIColor whiteColor]];
    self.introduceView = introduceView;
    UIView* verticalLine2 = [UIView new];
    verticalLine2.frame = CGRectMake(DLMultipleWidth(10.0), 10, 2, 10);
    verticalLine2.backgroundColor=RGB(0xfd, 0xb9, 0);
    
    UILabel *activityIntroduceTV = [[UILabel alloc]init];
    UIFont *aITVFont = [UIFont systemFontOfSize:15.0f];
    [activityIntroduceTV setTextColor:RGB(0x51, 0x46, 0x47)];
    activityIntroduceTV.width = DLScreenWidth-verticalLine2.x-10;
    activityIntroduceTV.height= 20;
    activityIntroduceTV.x = verticalLine.x+8;
    activityIntroduceTV.y = (activityIntroduceTV.height+verticalLine2.height)/2.0-verticalLine2.y;
    NSString *IntroduceText = @"";
    NSString *aITVText = [NSString stringWithFormat:@"活动介绍%@",IntroduceText];
    // TODO
    [activityIntroduceTV setText:aITVText];
    [activityIntroduceTV setFont:aITVFont];
    
    //添加webview
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
    NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", [self.model.content gtm_stringByUnescapingFromHTML]];
    [introduceWebView loadHTMLString:htmlcontent baseURL:nil];
    
    introduceView.width = DLScreenWidth;
//    introduceView.height = CGRectGetMaxY(introduceWebView.frame) + 16;
    //先指定一个高度，后续动态修改
    introduceView.height = 5000;
    introduceView.x = 0;
    introduceView.y = CGRectGetMaxY(enterView.frame) + 12;
    
    // 添加到根view中
    [introduceView addSubview:verticalLine2];
    [introduceView addSubview:activityIntroduceTV];
    [introduceView addSubview:introduceWebView];
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
//    [sighUpBtn setBackgroundColor:RGB(0xfd, 0xb9, 0)];
    [sighUpBtn setBackgroundImage:[UIImage imageNamed:@"transmit_btn"] forState:UIControlStateNormal];
    [sighUpBtn setTitle:@"转发" forState:UIControlStateNormal];
    sighUpBtn.width = DLScreenWidth - 4 * DLMultipleWidth(12);
    sighUpBtn.height = 33;
    sighUpBtn.x = (sighUpView.width-sighUpBtn.width)/2.0;
    sighUpBtn.y = sighUpView.height / 2 - sighUpBtn.height / 2;
    [sighUpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // btn添加到view中
    [sighUpView addSubview:sighUpBtn];
    [self addSubview:sighUpView];
    
    
    self.superView = superView;
    
    
}

-(void)btnClick:(id)sender{
    NSLog(@"btn clicked 转发");
    RepeaterGroupController* transmit = [[RepeaterGroupController alloc] init];
    [transmit.view setBackgroundColor:[UIColor clearColor]];
    [transmit setType:RepeaterGroupTranimitTypeActtivity];
    [transmit setModel:self.model];
    [transmit setContext:self.context.navigationController];
    //根据系统版本，进行半透明展示
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        transmit.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        transmit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [appdelegate.mainController presentViewController:transmit animated:YES completion:nil];
        [self.context presentViewController:transmit animated:YES completion:nil];
    } else {
        self.context.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.context presentViewController:transmit animated:YES completion:nil];
        
    }
}

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

@end
