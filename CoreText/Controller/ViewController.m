//
//  ViewController.m
//  CoreText
//
//  Created by 詹强辉 on 2018/9/19.
//  Copyright © 2018 Sol. All rights reserved.
//

#import "ViewController.h"
#import "ReaderViewController.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"

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
    
    
    NSString *chapter_num = [NSString stringWithFormat:@"1、庙会"];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSLog(@"%@",[NSString stringWithContentsOfFile:path1 encoding:4 error:NULL]);
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithContentsOfFile:path1 encoding:4 error:NULL]];
    NSString *strS = [[NSString alloc]initWithString:[NSString stringWithContentsOfFile:path1 encoding:4 error:NULL]];
    self.arrayData = [self coreTextPaging:strS textFrame:CGRectMake(20, 0, self.view.frame.size.width-40, self.view.frame.size.height-84)];
    
    _isPage = 0;
    
    _pagrIndex = 0;
    
    [self initPageView];
    
}

//CoreText 分页
- (NSArray *)coreTextPaging:(NSString *)str textFrame:(CGRect)textFrame{
    NSMutableArray *pagingResult = [NSMutableArray array];
//    CFAttributedStringRef cfAttStr = (__bridge CFAttributedStringRef)str;
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.fontSize = 13;
    NSDictionary *attributes = [[NSDictionary alloc]initWithDictionary:[CTFrameParser attributesWithConfig:config]];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:str attributes:attributes];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
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
        [pagingResult addObject:[contentString attributedSubstringFromRange:ra]];
        
        //移动当前文本位置
        textPos += frameRange.length;
        
        CFRelease(frame);
    }
    CGPathRelease(path);
    CFRelease(framesetter);
    return pagingResult;
}


- (void)initPageView
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

//返回一个CoreText阅读视图
- (ReaderViewController *)readerControllerWithPage:(NSUInteger)page
{
    ReaderViewController *textController = [[ReaderViewController alloc] init];
    textController.strData = _arrayData[page];              //读取数据
    textController.view.backgroundColor = [UIColor whiteColor];             //必须设置
    [textController view];
    return textController;
}

#pragma mark - UIPageViewDataSource And UIPageViewDelegate
//翻上一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
//    ReaderViewController *reader = (ReaderViewController *)viewController;
    
    if (_pagrIndex == 0 || _pagrIndex < 0 ) {
        _pagrIndex = 0;
        return nil;
    }
    NSLog(@"翻到了上一页");
    self.pagrIndex--;
    _isPage = 1;
    ReaderViewController *textController = [self readerControllerWithPage:self.pagrIndex];
    return textController;
}

//翻下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    _pagrIndex ++;
    if (_pagrIndex > self.arrayData.count || _pagrIndex == self.arrayData.count) {
        _pagrIndex = (int)self.arrayData.count -1;
        return nil;
    }
    NSLog(@"翻到了下一页");
    _isPage = 2;
    ReaderViewController *textController = [self readerControllerWithPage:self.pagrIndex];
    return textController;
}

//翻页结束后执行的代理方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
//        NSLog(@"翻页完成");
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
