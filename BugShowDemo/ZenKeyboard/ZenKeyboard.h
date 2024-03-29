//
//  ZenKeyboard.h
//  ZenKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEYBOARD_NUMERIC_KEY_WIDTH [[UIScreen mainScreen] bounds].size.width / 3.0
#define KEYBOARD_NUMERIC_KEY_HEIGHT 53

#ifndef SysLog
#if DEBUG
#define SysLog(fmt, ...) NSLog((@"%s [Line: %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SysLog(fmt, ...)
#define NSLog(fmt, ...)
#endif
#endif

#define RGB(r, g, b)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kMaxNumber                       100000

#define kProductName                     @"Zhihu" // 匹配xxx.xcdatamodeld
#define kCoreDataDBName                  @"Zhihu.sqlite"
#define kCoreDataEntity_Feed             @"Feed"

#define FONT_SIZE_SMALL 12.0f
#define FONT_SIZE_NORMAL 14.0f
#define FONT_SIZE_MEDIUM 15.0f
#define FONT_SIZE_LARGE 16.0f

#define HEITI_SC_LIGHT @"STHeitiSC-Light"
#define HEITI_SC_MEDIUM @"STHeitiSC-Medium"

#define FONT_SIZE_NORMAL_HEIGHT 16.0f
#define FONT_SIZE_MEDIUM_HEIGHT 17.0f

@protocol ZenKeyboardDelegate <NSObject>

- (void)numericKeyDidPressed:(int)key;
- (void)backspaceKeyDidPressed;

@end

@interface ZenKeyboard : UIView

@property (nonatomic, assign) UITextField *textField;

@end
