//
//  pickTypeView.h
//  EGO_Business
//
//  Created by 叶德雄 on 15/5/30.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface pickTypeView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
///底部约束，隐藏为－280，显示为0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;

@property(nonatomic,strong)NSArray *typeArray;

@property(nonatomic,copy)void (^removeView)();
@property(nonatomic,copy)void (^selectStype)(NSString*type);


+(instancetype)pickView;

@end
