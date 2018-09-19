//
//  CTFrameParserConfig.m
//  CoreText
//
//  Created by 詹强辉 on 2018/9/20.
//  Copyright © 2018 Sol. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
