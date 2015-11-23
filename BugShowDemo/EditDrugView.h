//
//  EditDrugView.h
//  EGO_Business
//
//  Created by qianxia_ios on 15/5/13.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditDrugView;
@protocol EditDrugViewDelegate <NSObject>

-(void)addAction:(EditDrugView*)view withBtn:(UIButton*)btn;
-(void)showBtnAction:(EditDrugView*)view withBtn:(UIButton*)btn;
-(void)deleteBtnAction:(EditDrugView*)view withBtn:(UIButton*)btn;

@end

@interface EditDrugView : UIView

@property IBOutletCollection(UIImageView) NSArray *imgArray;
@property IBOutlet UIButton *addImgBtn;
@property IBOutletCollection(UIButton) NSArray *btnArray;
@property IBOutlet UIImageView *playIamge;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deleteBtn;

- (IBAction)deleteAction:(UIButton *)sender;



- (IBAction)addAction:(id)sender;
- (IBAction)showBtnAction:(UIButton *)sender;
+(instancetype)editViews;

@property(nonatomic,assign)id <EditDrugViewDelegate> delegate;

@end
