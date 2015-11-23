//
//  EditDrugVC.h
//  EGO_Business
//
//  Created by qianxia_ios on 15/5/13.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//


#import "EditDrugView.h"
#import "EditDrugFootView.h"

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

@interface EditDrugVC : UIViewController <EditDrugViewDelegate>


@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)EditDrugView *editView;
@property(nonatomic,strong)EditDrugFootView *editFootView;
@end
