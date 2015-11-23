//
//  NSString+TextSzie.m
//  chuanzhi -QQ聊天
//
//  Created by yedexiong20 on 14/11/26.
//  Copyright (c) 2014年 ydx. All rights reserved.
//

#import "NSString+TextSzie.h"


@implementation NSString (TextSzie)

-(CGSize)textSzieWithFont:(UIFont*)font andMaxSzie:(CGSize)size
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}


/**
 *  NSString类目， 移除Emoji表情
 *
 */
- (NSString *)removeEmoji {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, self.length)
                                                          withTemplate:@""];
    return modifiedString;
}

@end
