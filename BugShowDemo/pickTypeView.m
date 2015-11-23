//
//  pickTypeView.m
//  EGO_Business
//
//  Created by 叶德雄 on 15/5/30.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//
#define DEFAULT_COLOR RGBA(66, 197, 254, 1)
#import "pickTypeView.h"

@implementation pickTypeView

+(instancetype)pickView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"pickTypeView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    //self.typeArray = @[@"保健品",@"中药",@"西药",@"处方药",@"非处方药",@"心脑血管"];
    self.picker.delegate = self;
    self.picker.dataSource = self;
   
    [self.picker selectRow:2 inComponent:0 animated:NO];
    if (ScreenHeight <= 568) {
         self.constraintHeight.constant = 200;
    }
   
}

- (IBAction)dismissPickerView:(id)sender {
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.constraintBottom.constant = -280;
        [self layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.typeArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.typeArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *lab=(UILabel*)[pickerView viewForRow:row forComponent:component];
    lab.textColor = RGBA(66, 197, 254, 1);

    NSString *title = self.typeArray[row];
    if (self.selectStype) {
        self.selectStype(title);
    }
    NSLog(@"%@",title);
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] firstObject];
    if (touch.view == self) {
        if (self.removeView) {
            self.removeView();
        }
    }
}

@end
