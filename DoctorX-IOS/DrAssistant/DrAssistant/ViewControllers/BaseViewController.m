//
//  ViewController.m
//  DrAssistant
//
//  Created by hi on 15/8/27.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "WSProgressHUD.h"
#import "MMTransitionAnimator.h"
#import "TKTextFieldAutolocateController.h"



@interface BaseViewController ()<UIViewControllerTransitioningDelegate>
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
//    {
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    }
    self.view.backgroundColor = [UIColor defaultBgColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBtnAction];
}



+ (id)simpleInstance {
    NSString *defaultNibName = NSStringFromClass([self class]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-declarations"
    
    BaseViewController *inst = [[[self class] alloc]initWithNibName:defaultNibName bundle:nil];
    
    return inst;
#pragma clang diagnostic pop
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - addLeftNavBtn
- (void)addLeftBtnAction{

    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    [self.navigationItem setLeftBarButtonItem:self.backItem];

}
- (void)hideLeftBtn{
    self.backButton.hidden = YES;
}

#pragma mark - addRightNavBtn
- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{
    NSAssert(0, @"子类必须重载%s", __FUNCTION__);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing: YES];
}

#pragma mark - public method

- (void)showWithStatus: (NSString *)string
{
    [WSProgressHUD showWithStatus:string maskType:WSProgressHUDMaskTypeBlack];
}

- (void)dismissToast
{
    [WSProgressHUD dismiss];
}

- (void)showSuccessToast:(NSString *)msg
{   if ([Utils isBlankString: msg]) {return;}
    [WSProgressHUD showSuccessWithStatus:msg];
}

- (void)showErrorToast:(NSString *)msg
{   if ([Utils isBlankString: msg]) {return;}
    [WSProgressHUD showErrorWithStatus:msg];
}

- (void)showString:(NSString *)msg
{   if ([Utils isBlankString: msg]) {return;}
    [WSProgressHUD showImage:nil status:msg];
}

- (void)showSuccessAlert:(NSString*)errorMessage {
     if ([Utils isBlankString: errorMessage]) {return;}
    [self showTitle:@"成功信息" message:errorMessage];
}

- (void)showErrorAlert:(NSString*)errorMessage {
    [self showTitle:@"错误信息" message:errorMessage];
}

- (void)showTitle:(NSString*)title message:(NSString*)message {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}



@end


