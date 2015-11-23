//
//  EditDrugView.m
//  EGO_Business
//
//  Created by qianxia_ios on 15/5/13.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//

#import "EditDrugView.h"

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

@implementation EditDrugView

-(void)awakeFromNib{
    [super awakeFromNib];
   
    for (UIImageView *images in self.imgArray) {
        if (ScreenWidth > 320) {
             images.frame = CGRectMake(images.frame.origin.x, images.frame.origin.y == 8 ? 8 : images.frame.origin.y+20, images.frame.size.width, images.frame.size.height+20);
        }
       
        images.layer.cornerRadius = 4.0f;
        images.layer.masksToBounds = YES;
    }
    for (UIButton *btn in self.deleteBtn) {
        if (ScreenWidth > 320) {
            btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y == 10 ? 10 : btn.frame.origin.y+20, btn.frame.size.width, btn.frame.size.height);
        }
        btn.hidden = YES;
    }
    for (UIButton *btn in self.btnArray) {
        btn.hidden = YES;
    }
    self.addImgBtn.layer.cornerRadius = 4.0f;
    self.addImgBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addImgBtn.layer.borderWidth = 0.5f;
    self.addImgBtn.layer.masksToBounds = YES;
    
    
}
+(instancetype)editViews
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EditDrugView" owner:nil options:nil] lastObject];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteBtnAction:withBtn:)]) {
        [self.delegate deleteBtnAction:self withBtn:sender];
    }
}

- (IBAction)addAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addAction:withBtn:)]) {
        [self.delegate addAction:self withBtn:sender];
    }
    
}
- (IBAction)showBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(showBtnAction:withBtn:)]) {
        [self.delegate showBtnAction:self withBtn:sender];
    }
    
    UIScrollView *scrollView =  (UIScrollView*)self.superview;
    [scrollView setContentOffset:CGPointMake(0, -20) animated:YES];
}



@end
