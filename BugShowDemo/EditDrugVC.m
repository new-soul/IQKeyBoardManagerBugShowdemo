//
//  EditDrugVC.m
//  EGO_Business
//
//  Created by qianxia_ios on 15/5/13.
//  Copyright (c) 2015年 qianxia_ios. All rights reserved.
//

#import "EditDrugVC.h"
//#import "QBImagePickerController.h"
//#import "CustomNavigationController.h"
//#import "UIImage+ScaleAspectFit.h"
//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"
//#import "TPKeyboardAvoidingScrollView.h"
//#import "UIImage+Extension.h"
//#import "CaptureViewController.h"
//#import "APIManager.h"
//#import "NSString+WTool.h"



#define UPLOADIMG_SIZE 95*ScaleX
#define FootView_Height 50

@interface EditDrugVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIView *footV;
}


@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UIButton *doneBtn;
@property(nonatomic,strong)NSMutableArray *imageArray;//选完照片数组
//@property(nonatomic,strong)TPKeyboardAvoidingScrollView *scrollView;
@property(nonatomic,assign)CGFloat height;//纪录弹出键盘的高度
@property(nonatomic,assign)CGFloat sizeHeight;//纪录scroll内容尺寸宽度
@property(nonatomic,assign)CGRect addImageBtnF;
@property(nonatomic,strong)NSArray *typeArray;

@end

@implementation EditDrugVC

-(id)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenKeyBoard) name:@"qiangdanViewAppear" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求药品类型数据
    
    [self initEditFootView];
    //self.imageArray = [NSMutableArray array];
    
    
}

-(void)initEditFootView{
    self.editFootView  = [EditDrugFootView editFootViews];
    self.editFootView.frame = CGRectMake(0, CGRectGetMaxY(self.editView.frame)+10, ScreenWidth, self.editFootView.frame.size.height);
    [self.view addSubview:self.editFootView];
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.editFootView.frame));
    
}

#pragma - UIKeyboardViewController delegate methods

- (void)alttextFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}

- (void)alttextViewDidEndEditing:(UITextView *)textView {
    NSLog(@"%@", textView.text);
}




#pragma mark -- EditDrugView delegate
-(void)addAction:(EditDrugView*)view withBtn:(UIButton*)btn
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [sheet showInView:self.view];
    
    
}



-(void)deleteBtnAction:(EditDrugView*)view withBtn:(UIButton*)btn
{
    for (UIImageView *images  in view.imgArray) {
        if (images.tag == btn.tag) {
            images.image = nil;
            images.hidden = YES;
            [self.imageArray removeObjectAtIndex:btn.tag -1];
            break;
            
        }
    }
    btn.hidden = YES;
    //[self showImageWithArray:self.imageArray];
    
}





//字符串是否全是空格
-(BOOL)isAllSpaceWithString:(NSString*)str
{
    BOOL flase = NO;
    //去掉前后空格
    NSString *str1 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //去掉中间空格
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str2.length == 0) {
        flase = YES;
    }
    
    return flase;
    
}

- (void)hideBtn:(NSInteger)tag {
    for (UIButton *btn in self.editView.btnArray) {
        if (btn.tag == tag) {
            btn.hidden = NO;
        }
    }
}
//显示删除按钮
- (void)showDeleteBtn:(NSInteger)tag {
    for (UIButton *btn in self.editView.deleteBtn) {
        if (btn.tag == tag) {
            btn.hidden = NO;
        }
    }
}
//隐藏删除按钮
- (void)hideDeleteBtn:(NSInteger)tag {
    for (UIButton *btn in self.editView.deleteBtn) {
        if (btn.tag == tag) {
            btn.hidden = YES;
        }
    }
}




#pragma mark --notification
-(void)hidenKeyBoard
{
    [self.editFootView endEditing:YES];
}


#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [self openCameraImagePicker];
    }
    
    if(buttonIndex ==1) {  // 相册选择
        //[self openQBImagePicker];
    }
}
- (void)openCameraImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -  UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.editFootView endEditing:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
