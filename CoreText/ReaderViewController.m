//
//  ReaderViewController.m
//  CoreText
//
//  Created by 詹强辉 on 2018/9/19.
//  Copyright © 2018 Sol. All rights reserved.
//

#import "ReaderViewController.h"

@interface ReaderViewController ()

@end

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(UILabel *)labelStr{
    if (!_labelStr) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 50)];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        _labelStr = label;
    }
    return _labelStr;
}

@end
