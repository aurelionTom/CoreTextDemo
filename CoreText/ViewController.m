//
//  ViewController.m
//  CoreText
//
//  Created by 詹强辉 on 2018/9/19.
//  Copyright © 2018 Sol. All rights reserved.
//

#import "ViewController.h"
#import "ReaderViewController.h"

@interface ViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property(nonatomic,strong)UIPageViewController * pageViewController;

@property(assign,nonatomic)int pagrIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pagrIndex = 0;
    
    [self initPageView:NO];
    
}

- (void)initPageView:(BOOL)isFromMenu;
{
    if (_pageViewController) {              //初始化pageViewController
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
//    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:0] forKey:UIPageViewControllerOptionSpineLocationKey];
//    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];

    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    [self showPage:self.pagrIndex ];
}

- (void)showPage:(NSUInteger)page
{
    ReaderViewController *readerController = [self readerControllerWithPage:page];
    [_pageViewController setViewControllers:@[readerController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL f){
        
    }];
}

- (ReaderViewController *)readerControllerWithPage:(NSUInteger)page
{
    ReaderViewController *textController = [[ReaderViewController alloc] init];
    textController.view.backgroundColor = [UIColor whiteColor];
    textController.labelStr.text = [NSString stringWithFormat:@"--asda:%ld--:Right from the start, you were a thief, 打从一开始，你就是个偷心贼,You stole my heart and,你偷走了我的心,I your willing victim,我是你的俘虏, I let you see the parts of me,我要让你看看我,That weren't all that pretty.,心底那不完美的部分. And with every touch.每次与你的接触.You fixed them..你都修补我这些残缺的部分.Now, you've been talking in your sleep.现在，你在睡梦中脱口 ​​而出的梦话.Oh oh, things you never say to ME.哦哦~这你些都没告诉我的事情.Oh oh, tell me that you've had enough.哦哦，告诉我你已经受够了.  Of our Love, our Love..我们之间的爱.Just give me a reason,. 就给我个一个理由",page];
    [textController view];
    return textController;
}

#pragma mark - UIPageViewDataSource And UIPageViewDelegate
//翻上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"翻到了上一页");
//    ReaderViewController *reader = (ReaderViewController *)viewController;
    self.pagrIndex--;
    ReaderViewController *textController = [self readerControllerWithPage:self.pagrIndex];
    return textController;
}

//翻下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"翻到了下一页");
    self.pagrIndex ++;
    ReaderViewController *textController = [self readerControllerWithPage:self.pagrIndex];
    return textController;
}

//翻页结束后执行的代理方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        NSLog(@"翻页完成");
    }else{
        NSLog(@"翻页未完成 又回来了。");
    }
}

@end
