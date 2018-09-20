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

/**
 翻页的页码
 */
@property(assign,nonatomic)int pagrIndex;

/**
 书籍数据
 */
@property(strong,nonatomic)NSArray *arrayData;

/**
 翻页是否成功     1:上一页  2:下一页
 */
@property(assign,nonatomic)int isPage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter1"];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSLog(@"%@",[NSString stringWithContentsOfFile:path1 encoding:4 error:NULL]);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithContentsOfFile:path1 encoding:4 error:NULL]];
    self.arrayData = [self coreTextPaging:str textFrame:CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height/2.7)];
    
    _isPage = 0;
    
    _pagrIndex = 0;
    
    [self initPageView:NO];
    
}

//CoreText 分页
- (NSArray *)coreTextPaging:(NSAttributedString *)str textFrame:(CGRect)textFrame{
    NSMutableArray *pagingResult = [NSMutableArray array];
    CFAttributedStringRef cfAttStr = (__bridge CFAttributedStringRef)str;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(cfAttStr);
    CGPathRef path = CGPathCreateWithRect(textFrame, NULL);
    
    int textPos = 0;
    NSUInteger strLength = [str length];
    while (textPos < strLength)  {
        //设置路径
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        //生成frame
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange ra = NSMakeRange(frameRange.location, frameRange.length);
        
        //获取范围并转换为NSRange，然后以NSAttributedString形式保存
        [pagingResult addObject:[str attributedSubstringFromRange:ra]];
        
        //移动当前文本位置
        textPos += frameRange.length;
        
        CFRelease(frame);
    }
    CGPathRelease(path);
    CFRelease(framesetter);
    return pagingResult;
}


- (void)initPageView:(BOOL)isFromMenu;
{
    if (self.pageViewController) {              //初始化pageViewController
        [self.pageViewController removeFromParentViewController];
        self.pageViewController = nil;
    }
    self.pageViewController = [[UIPageViewController alloc] init];
//    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:0] forKey:UIPageViewControllerOptionSpineLocationKey];
//    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
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
    textController.strData = _arrayData[page];
    textController.view.backgroundColor = [UIColor whiteColor];
    [textController view];
    return textController;
}

#pragma mark - UIPageViewDataSource And UIPageViewDelegate
//翻上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"翻到了上一页");
//    ReaderViewController *reader = (ReaderViewController *)viewController;
    
    if (_pagrIndex == 0 || _pagrIndex < 0 ) {
        _pagrIndex = 0;
        return nil;
    }
    self.pagrIndex--;
    _isPage = 1;
    ReaderViewController *textController = [self readerControllerWithPage:self.pagrIndex];
    return textController;
}

//翻下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"翻到了下一页");
    _pagrIndex ++;
    if (_pagrIndex > self.arrayData.count || _pagrIndex == self.arrayData.count) {
        _pagrIndex = (int)self.arrayData.count -1;
        return nil;
    }
    _isPage = 2;
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
        if (_isPage == 1) {         //上一页
            self.pagrIndex ++;
        }else if(_isPage == 2) {        //下一页
            self.pagrIndex --;
        }
    }
}

@end
