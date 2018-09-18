//
//  ReaderViewController.h
//  CoreText
//
//  Created by 詹强辉 on 2018/9/19.
//  Copyright © 2018 Sol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReaderViewController : UIViewController

@property(copy,nonatomic)NSString *text;

@property(strong,nonatomic)UILabel *labelStr;

@end

NS_ASSUME_NONNULL_END
