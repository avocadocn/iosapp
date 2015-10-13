//
//  PublishedInteractionsMapViewController.m
//  app
//
//  Created by burring on 15/9/21.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "PublishedInteractionsMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface PublishedInteractionsMapViewController ()<UISearchBarDelegate,MAMapViewDelegate,AMapSearchDelegate>

{
    MAMapView *_mapView; // 地图
    CLLocationManager * locationManager; // 定位
    AMapSearchAPI *_search; // 搜索
}

@property (nonatomic, strong)UISearchBar *searchBar; // 顶部搜索框
@property (nonatomic, strong)UIButton *btn; // 确认按钮
@property (nonatomic, strong)AMapPOI *point; // 兴趣点
@property (nonatomic, strong)MAUserLocation *userLocation;
@property (nonatomic, copy)NSString *cityName; // 用户当前城市
@property (nonatomic, copy)NSString *searchText; // 搜索框内容
@property (nonatomic, copy)NSString *addressName; // 地址
@property (nonatomic)CLLocationCoordinate2D Interactioncoordinate; // 活动坐标
@property (nonatomic) BOOL searchType; // 修改搜索类型
@property (nonatomic)CLLocationCoordinate2D clickCoordinate; // 点击空白处的坐标
@property (nonatomic, copy)NSString *titleName,*subtitleName; // 点击空白处大头针的title
@property (nonatomic)id<MAAnnotation> annotation; /// 点击大头针出现的大头针

@property (nonatomic, strong)NSMutableArray *annotationArray;
@end

@implementation PublishedInteractionsMapViewController

-(NSMutableArray *)annotationArray {
    if (_annotationArray == nil) {
        self.annotationArray = [@[]mutableCopy];
    }
    return _annotationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self builtInterFace];
    
}

- (void)builtInterFace {
    //   搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, DLScreenWidth, 40)];
    self.searchBar.placeholder = @"请输入地址";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
//     中间地图
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
     
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 104, DLScreenWidth, DLScreenHeight - 124 - 20)];
    _mapView.delegate = self;
  
    _mapView.mapType = MAMapTypeStandard;
//    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);  //罗盘位置
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22); // 比例尺位置
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    [self.view addSubview:_mapView];
    
    //  确认按钮
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, DLScreenHeight - 40, DLScreenWidth, 40);
    [self.btn setTitle:@"确认" forState:UIControlStateNormal];
    self.btn.userInteractionEnabled = NO;
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor lightGrayColor];
    [self.btn addTarget:self action:@selector(Besure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];

}

// btn 点击事件
- (void)Besure:(UIButton *)btn {
    NSLog(@"确认");
    if ([self.delegate respondsToSelector:@selector(passAddress:coordinate:)]) {
        [self.delegate passAddress:self.addressName coordinate:self.Interactioncoordinate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma search

- (void)buildSearchWithText:(NSString *)text orTrue:(BOOL)orTrue coordinate:(CLLocationCoordinate2D)coordinate {
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"4693df7c11ba3ba2cc58e44e8666134f" Delegate:self];
    
//  逆地理编码
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    if (orTrue) { //
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:self.userLocation.coordinate.latitude longitude:self.userLocation.coordinate.longitude];
    } else {
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

- (void)marchingPOISearch {
     _search = [[AMapSearchAPI alloc] initWithSearchKey:@"4693df7c11ba3ba2cc58e44e8666134f" Delegate:self];
    //  POI搜索
    
    //构造 AMapPlaceSearchRequest 对象,配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = self.searchText;      // 搜索关键字
    poiRequest.city = @[self.cityName];     //  城市
    poiRequest.requireExtension = YES;
    //发起 POI 搜索
    [_search AMapPlaceSearch: poiRequest];
}



#pragma MAPinAnnotationView // 大头针
- (void)buildMAPinAnnotationView {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    if (self.searchType == YES) { // 关键字搜索
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.point.location.latitude, self.point.location.longitude); //
        pointAnnotation.title = self.point.name;
        pointAnnotation.subtitle = self.point.address;
    } else {  // 点击地图空白处
        pointAnnotation.coordinate = self.clickCoordinate;
        pointAnnotation.title = self.titleName;
        pointAnnotation.subtitle = self.subtitleName;
    }
    [_mapView addAnnotation:pointAnnotation];
}




#pragma AMapSearchDelegate

//实现 POI 搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0) {
        return;
    }
    //处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@",response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        self.point = p;
        NSLog(@"%@%@",p.name,p.address);
        [self buildMAPinAnnotationView]; //调用添加大头针
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
   
}

// 实现逆地理编码对应的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if(response.regeocode != nil) { // 关键字搜索
        //处理搜索结果
        if (self.searchType == YES) {
            if ([response.regeocode.addressComponent.city isEqualToString:@""]) {
                self.cityName = [NSString stringWithFormat:@"%@",response.regeocode.addressComponent.province];
            } else {
                self.cityName = [NSString stringWithFormat:@"%@",response.regeocode.addressComponent.city];
            }
            NSLog(@"%@",self.cityName);
            [self marchingPOISearch];
        } else {          // 点击地图空白处
            if ([response.regeocode.addressComponent.city isEqualToString:@""]) {
                self.titleName = [NSString stringWithFormat:@"%@ %@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.district];
            } else {
                self.titleName = [NSString stringWithFormat:@"%@ %@",response.regeocode.addressComponent.city,response.regeocode.addressComponent.district];
            }
            self.subtitleName = [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.township,response.regeocode.addressComponent.streetNumber.street,response.regeocode.addressComponent.streetNumber.number];
            [self buildMAPinAnnotationView];
        }
    }
}


#pragma UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder]; // 移除第一响应
    self.searchType = YES;
    if (self.annotationArray.count != 0) { // 如果数组不为空(存在之间搜索的大头针)将数组清空
        [_mapView removeAnnotations:self.annotationArray];
    }
    [self buildSearchWithText:searchBar.text orTrue:YES coordinate:self.userLocation.coordinate]; // 创建搜索
    self.searchText = searchBar.text;
    NSLog(@"%@",searchBar.text);
    NSLog(@"search");
}


#pragma MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.userLocation = userLocation;
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
        self.annotation = annotation;
        [self.annotationArray addObject:annotation];
        return annotationView;
    }

    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {//点击大头针触发
    NSLog(@"%@",mapView.annotations);
    self.btn.userInteractionEnabled = YES;
    self.btn.backgroundColor = RGBACOLOR(253, 185, 0, 1);
    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
    
    for (int i=0; i<array.count; i++)
        
    {
        
        if (view.annotation.coordinate.latitude ==((MAPointAnnotation *)array[i]).coordinate.latitude)
            
        {
            //获取到当前的大头针 执行一些操作
         self.addressName = [NSString stringWithFormat:@"%@%@",[(MAPointAnnotation *)[mapView.annotations objectAtIndex:i] title],[(MAPointAnnotation *)[mapView.annotations objectAtIndex:i] subtitle]];
         self.Interactioncoordinate = view.annotation.coordinate;
            
        }
        
        else
            
        {
            
            //对其余的大头针进行操作
            
            //[_mapView removeAnnotation:array[i]];
            
        }
        
    }
 
}
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {//大头针消失时触发
    self.btn.userInteractionEnabled = NO;
    self.btn.backgroundColor = [UIColor lightGrayColor];
    
}

// 点击地图空白处调用
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    NSLog(@"点击位置的坐标 %f%f",coordinate.latitude,coordinate.longitude);
    [mapView removeAnnotation:self.annotation]; // 将之前点击出来的 大头针移除掉
    self.searchType = NO;
    self.clickCoordinate = coordinate;
    [self buildSearchWithText:nil orTrue:NO coordinate:coordinate];
    
}

-(void)viewWillDisappear:(BOOL)animated { // 视图消失时停止定位 （节省资源）
    [self mapViewDidStopLocatingUser:_mapView];
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

@end
