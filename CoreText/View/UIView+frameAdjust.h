//
//  UIView+frameAdjust.h
//  CoreText
//
//  Created by 詹强辉 on 2018/9/20.
//  Copyright © 2018 Sol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (frameAdjust)

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
