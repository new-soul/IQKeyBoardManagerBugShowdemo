//
//  EditDrugFootView.m
//  EGO_Business
//
//  Created by 叶德雄 on 15/5/18.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//

#import "EditDrugFootView.h"
#import "pickTypeView.h"
#import "AppDelegate.h"
#import "PMUtils.h"
#import "NSString+TextSzie.h"
#import "ZenKeyboard.h"

@interface EditDrugFootView ()<UITextFieldDelegate,UITextViewDelegate> {
    
}


@end

@implementation EditDrugFootView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //设置控件边框和颜色
    self.priceField.layer.borderWidth = 1.0f;
    self.priceField.delegate = self;
    self.priceField.keyboardType=UIKeyboardTypeNumberPad;
    self.priceField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 35)];
    self.priceField.leftViewMode = UITextFieldViewModeAlways;
    self.priceField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.priceField.layer.cornerRadius = 3.0f;
    self.priceField.layer.masksToBounds= YES;
    
    CGFloat with = [[UIScreen mainScreen] bounds].size.width;
    ZenKeyboard *keyboard = [[ZenKeyboard alloc] initWithFrame:CGRectMake(0, 0, with, 216)];
    keyboard.textField = self.priceField;
    
    self.nameField.layer.borderWidth = 1.0f;
    self.nameField.delegate = self;
    self.nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameField.layer.cornerRadius = 4.0f;
    self.nameField.layer.masksToBounds = YES;
    
    self.typeField.layer.borderWidth = 1.0f;
    self.typeField.delegate = self;
    self.typeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
    self.typeField.leftViewMode = UITextFieldViewModeAlways;
    self.typeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.typeField.layer.cornerRadius = 4.0f;
    self.typeField.layer.masksToBounds = YES;
    
    self.textView.layer.borderWidth = 1.0f;
    self.textView.delegate = self;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 4.0f;
    self.textView.layer.masksToBounds = YES;
    
    
}

+(instancetype)editFootViews
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EditDrugFootView" owner:nil options:nil] lastObject];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark -- UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.typeField) {
        [self endEditing:YES];
       
        pickTypeView *pick = [pickTypeView pickView];
        pick.typeArray = self.typeArray;
        //刷新数据，否则ios7会拿不到最新的数据
         [pick.picker reloadAllComponents];
         __weak typeof(pick) weakPick = pick;
          __weak typeof(self) weakSelf = self;
        [pick setSelectStype:^(NSString *type) {
            weakSelf.type = type;
            weakSelf.typeField.text = type;
        }];
        
        self.type = [self.typeArray objectAtIndex:0];
        self.typeField.text = self.type;
        
        [pick setRemoveView:^{
            [UIView animateWithDuration:0.35 animations:^{
                weakPick.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                weakPick.constraintBottom.constant = -280;
                [weakPick layoutIfNeeded];
                
            }completion:^(BOOL finished) {
                [weakPick removeFromSuperview];
            }];
        }];
        pick.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        pick.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        AppDelegate *appde =(AppDelegate *)[UIApplication sharedApplication].delegate;
        [appde.window.rootViewController.view addSubview:pick];
        
        //__weak typeof(pick) weakPick = pick;
        [pick layoutIfNeeded];
        [UIView animateWithDuration:0.35 animations:^{
            weakPick.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            weakPick.constraintBottom.constant = 0;
            [weakPick layoutIfNeeded];
            //[weakPick.picker reloadAllComponents];
            
        }];
        
        
        return NO;

    }
    else if (textField == self.priceField) {
        return YES;
    }
    else{
        
        return YES;
    }
}



#pragma mark --txtFDelegate--
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    //禁止系统自带的emoji表情输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField.text.containsEmoji) {
        
        NSString *text = textField.text;
        
        text = [text removeEmoji];
        
        textField.text = text;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  
    //禁止系统自带的emoji表情输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    return YES;


}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.containsEmoji) {
        
        NSString *text = textView.text;
        
        text = [text removeEmoji];
        
        textView.text = text;
    }
    
    return YES;

}

@end
