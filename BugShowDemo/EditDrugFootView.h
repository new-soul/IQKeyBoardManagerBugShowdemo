//
//  EditDrugFootView.h
//  EGO_Business
//
//  Created by 叶德雄 on 15/5/18.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDrugFootView : UIView

+(instancetype)editFootViews;

@property (nonatomic,strong) NSArray *typeArray;//药品类型数据
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (copy, nonatomic) NSString *type;

@end
