//
//  SetNameController.m
//  styler
//
//  Created by System Administrator on 13-5-22.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SetNameController.h"
#import "UserStore.h"
#import "StylerException.h"
#import "ImageUtils.h"
#import "Toast+UIView.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"

@interface SetNameController ()

@end

@implementation SetNameController
{
    HeaderView *header;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initFooter];
}



-(void) initHeader{
    header = [[HeaderView alloc]initWithTitle:page_name_setting_name navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void) initFooter{
    self.upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.upSpliteLine.frame = CGRectMake(self.upSpliteLine.frame.origin.x, self.upSpliteLine.frame.origin.y, self.upSpliteLine.frame.size.width,  splite_line_height) ;
    self.downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.downSpliteLine.frame = CGRectMake(self.downSpliteLine.frame.origin.x, self.downSpliteLine.frame.origin.y, self.downSpliteLine.frame.size.width,  splite_line_height) ;
    self.saveBut.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
    CALayer *layer = self.saveBut.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
    
    self.nameIn.delegate = self;
    
    self.topView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    CGRect frame = self.topView.frame;
    frame.origin.y = header.frame.size.height + general_margin;
    self.topView.frame = frame;}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.nameIn resignFirstResponder];
    [self saveNewName:self.nameIn];
    return YES;
}



- (IBAction)saveNewName:(id)sender {
//    self.nameIn.text = @"输入";
    if([self.nameIn.text isEqualToString:@""]){
        [self.view makeToast:@"请输入新的用户名" duration:1.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    [MobClick event:log_event_name_submit_new_name];
    [SVProgressHUD showWithStatus:@"正在处理，请稍等..."];
    AppStatus *as = [AppStatus sharedInstance];
    [[UserStore sharedStore] updateName:^(NSError *err) {
        if(err == nil){
            [SVProgressHUD showSuccessWithStatus:@"修改成功！" duration:1.0];
            [self.navigationController popViewControllerAnimated:YES];
            NSNotification *notification = [NSNotification notificationWithName:notification_name_update_user_name object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            [SVProgressHUD dismiss];
            StylerException *exception = [[err userInfo] objectForKey:@"stylerException"];
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        }
    } userId:as.user.idStr name:self.nameIn.text];
}

-(NSString *)getPageName{
    return page_name_setting_name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
