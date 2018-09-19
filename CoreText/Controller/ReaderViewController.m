//
//  ReaderViewController.m
//  CoreText
//
//  Created by 詹强辉 on 2018/9/19.
//  Copyright © 2018 Sol. All rights reserved.
//

#import "ReaderViewController.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"
#import "CoreTextData.h"
#import "CTDisplayView.h"
#import "UIView+frameAdjust.h"

@interface ReaderViewController ()

@property(nonatomic,strong)CTDisplayView *ctView;

@end

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor redColor];
    config.width = self.ctView.width;
    NSString *str = [NSString stringWithFormat:@"%@",self.strData.string];
    CoreTextData *data = [CTFrameParser parseContent:str config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor yellowColor];
}

-(CTDisplayView *)ctView{
    if (!_ctView) {
        CTDisplayView *view = [[CTDisplayView alloc]init];
        view.frame = CGRectMake(50, 164, 300, 300);
        [self.view addSubview:view];
        _ctView = view;
    }
    return _ctView;
}

@end
