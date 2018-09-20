//
//  CTFrameParser.h
//  CoreText
//
//  Created by 詹强辉 on 2018/9/20.
//  Copyright © 2018 Sol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

@end

NS_ASSUME_NONNULL_END
