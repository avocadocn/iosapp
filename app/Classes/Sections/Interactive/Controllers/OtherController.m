//
//  OtherController.m
//  app
//
//  Created by 张加胜 on 15/7/17.
//  Copyright (c) 2015年 Donler. All rights reserved.
//  什么活动页面

#import "OtherController.h"
#import "OtherSegmentButton.h"
#import "DLNavBar.h"
#import "OtherActivityShowCell.h"
#import "DetailActivityShowController.h"
#import "PaggingScrollView.h"

typedef NS_ENUM(NSInteger, XHSlideType) {
    XHSlideTypeLeft = 0,
    XHSlideTypeRight = 1,
};

 //  横划集合视图
@interface OtherController ()<UIScrollViewDelegate>


/**
 *  显示内容的容器
 */
@property (nonatomic, strong) UIView *centerContainerView;
@property (nonatomic, strong) PaggingScrollView *paggingScrollView;

/**
 *  显示title集合的容器
 */
@property (nonatomic, strong) DLNavBar *paggingNavbar;

/**
 *  标识当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, strong) UIViewController *leftViewController;

@property (nonatomic, strong) UIViewController *rightViewController;
@end

@implementation OtherController

static NSString * const ID = @"OtherActivityShowCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"其他活动";
    [self.view setBackgroundColor:RGB(230, 230, 230)];
//    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    // 添加标签视图
    [self addTitleSegmentView];
    
    
    [self setupViews];
    
    [self reloadData];

    
}





/**
 *  添加导航栏标题
 */
-(void)addTitleSegmentView{
  
    DLNavBar *bar = [[DLNavBar alloc]initWithFrame:CGRectMake(0, 0, DLScreenWidth * 2 / 3, 44)];
    self.navigationItem.titleView = bar;
    
    self.paggingNavbar = bar;
    
    __weak typeof(self) weakSelf = self;
    _paggingNavbar.didChangedIndex = ^(NSInteger index) {
// NSLog(@"%zd",index);
        [weakSelf setCurrentPage:index animated:YES];
    };
}


#pragma mark - DataSource

- (NSInteger)getCurrentPageIndex {
    return self.currentPage;
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    
    self.paggingNavbar.currentPage = currentPage;
    self.currentPage = currentPage;
    
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    CGPoint contentOffset = self.paggingScrollView.contentOffset;
    contentOffset.x = currentPage * pageWidth;
    [self.paggingScrollView setContentOffset:contentOffset animated:animated];
}

- (void)reloadData {
    if (!self.viewControllers.count) {
        return;
    }
    
    [self.paggingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        CGRect contentViewFrame = viewController.view.bounds;
        contentViewFrame.origin.y = 0;
        contentViewFrame.origin.x = idx * CGRectGetWidth(self.view.bounds);
        viewController.view.frame = contentViewFrame;
        [self.paggingScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
    
    [self.paggingScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * self.viewControllers.count, 0)];
    
    self.paggingNavbar.titles = [self.viewControllers valueForKey:@"title"];
    // [self.paggingNavbar reloadData];
    
    [self setupScrollToTop];
    
    [self callBackChangedPage];
}

#pragma mark - Propertys

- (UIView *)centerContainerView {
    if (!_centerContainerView) {
        _centerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
         _centerContainerView.backgroundColor = self.view.backgroundColor;
       
        [_centerContainerView addSubview:self.paggingScrollView];
        [self.paggingScrollView.panGestureRecognizer addTarget:self action:@selector(panGestureRecognizerHandle:)];
    }
    return _centerContainerView;
}

- (UIScrollView *)paggingScrollView {
    if (!_paggingScrollView) {
        _paggingScrollView = [[PaggingScrollView alloc] initWithFrame:self.view.bounds];
        _paggingScrollView.bounces = NO;
        _paggingScrollView.pagingEnabled = YES;
        [_paggingScrollView setScrollsToTop:NO];
        _paggingScrollView.delegate = self;
        _paggingScrollView.showsVerticalScrollIndicator = NO;
        _paggingScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _paggingScrollView;
}


- (UIViewController *)getPageViewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    } else {
        return nil;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage)
        return;
    _lastPage = _currentPage;
    _currentPage = currentPage;
    
    self.paggingNavbar.currentPage = currentPage;
    
    [self setupScrollToTop];
    [self callBackChangedPage];
}

#pragma mark - Life Cycle

- (void)setupTargetViewController:(UIViewController *)targetViewController withSlideType:(XHSlideType)slideType {
    if (!targetViewController)
        return;
    
    [self addChildViewController:targetViewController];
    CGRect targetViewFrame = targetViewController.view.frame;
    switch (slideType) {
        case XHSlideTypeLeft: {
            targetViewFrame.origin.x = -CGRectGetWidth(self.view.bounds);
            break;
        }
        case XHSlideTypeRight: {
            targetViewFrame.origin.x = CGRectGetWidth(self.view.bounds) * 2;
            break;
        }
        default:
            break;
    }
    targetViewController.view.frame = targetViewFrame;
    [self.view insertSubview:targetViewController.view atIndex:0];
    [targetViewController didMoveToParentViewController:self];
}

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController {
    return [self initWithLeftViewController:leftViewController rightViewController:nil];
}

- (instancetype)initWithRightViewController:(UIViewController *)rightViewController {
    return [self initWithLeftViewController:nil rightViewController:rightViewController];
}

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
    self = [super init];
    if (self) {
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Ensure that the paggingScrollView is the correct height.
    // This facilitates situations where the XHTwitterPaggingViewer is shown within
    // a UITabBarController.
    CGRect scrollViewFrame = self.paggingScrollView.frame;
    scrollViewFrame.size.height = self.view.frame.size.height;
    self.paggingScrollView.frame = scrollViewFrame;
}


- (void)setupViews {
    [self.view addSubview:self.centerContainerView];
    
    [self setupTargetViewController:self.leftViewController withSlideType:XHSlideTypeLeft];
    [self setupTargetViewController:self.rightViewController withSlideType:XHSlideTypeRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.paggingScrollView.delegate = nil;
    self.paggingScrollView = nil;
    
    self.paggingNavbar = nil;
    
    self.viewControllers = nil;
    
    self.didChangedPageCompleted = nil;
}

#pragma mark - PanGesture Handle Method
- (void)panGestureRecognizerHandle:(UIPanGestureRecognizer *)panGestureRecognizer {
   
    /*
     CGPoint contentOffset = self.paggingScrollView.contentOffset;
     
     CGSize contentSize = self.paggingScrollView.contentSize;
     
     CGFloat baseWidth = CGRectGetWidth(self.paggingScrollView.bounds);
     
     switch (panGestureRecognizer.state) {
     case UIGestureRecognizerStateBegan:
     
     break;
     case UIGestureRecognizerStateChanged: {
     CGPoint translationPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view];
     if (contentOffset.x <= 0) {
     // 滑动到最左边
     
     CGRect centerContainerViewFrame = self.centerContainerView.frame;
     centerContainerViewFrame.origin.x += translationPoint.x;
     self.centerContainerView.frame = centerContainerViewFrame;
     
     CGRect leftMenuViewFrame = self.leftViewController.view.frame;
     leftMenuViewFrame.origin.x += translationPoint.x;
     self.leftViewController.view.frame = leftMenuViewFrame;
     
     [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
     } else if (contentOffset.x >= contentSize.width - baseWidth) {
     // 滑动到最右边
     [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
     }
     break;
     }
     case UIGestureRecognizerStateFailed:
     case UIGestureRecognizerStateEnded:
     case UIGestureRecognizerStateCancelled: {
     // 判断是否打开或关闭Menu
     break;
     }
     default:
     break;
     }
     
    */
    
}

#pragma mark - Block Call Back Method

- (void)callBackChangedPage {
    UIViewController *fromViewController = [self.viewControllers objectAtIndex:self.lastPage];
    UIViewController *toViewController = [self.viewControllers objectAtIndex:self.currentPage];
    
    [fromViewController viewWillDisappear: true];
    [fromViewController viewDidDisappear: true];
    [toViewController viewWillAppear: true];
    [toViewController viewDidAppear: true];
    
    if (self.didChangedPageCompleted) {
        self.didChangedPageCompleted(self.currentPage, [[self.viewControllers valueForKey:@"title"] objectAtIndex:self.currentPage]);
    }
}

#pragma mark - TableView Helper Method

- (void)setupScrollToTop {
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UITableView *tableView = (UITableView *)[self subviewWithClass:[UITableView class] onView:[self getPageViewControllerAtIndex:i].view];
        if (tableView) {
            if (self.currentPage == i) {
                [tableView setScrollsToTop:YES];
            } else {
                [tableView setScrollsToTop:NO];
            }
        }
    }
}

#pragma mark - View Helper Method

- (UIView *)subviewWithClass:(Class)cuurentClass onView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:cuurentClass]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // self.paggingNavbar.contentOffset = scrollView.contentOffset;
  
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    // 根据当前的x坐标和页宽度计算出当前页数
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   
}


#pragma touch



@end
