//
//  SetSexController.m
//  styler
//
//  Created by aypc on 13-9-30.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SetSexController.h"
#import "ImageUtils.h"
#import "UserStore.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"

@interface SetSexController ()

@end

@implementation SetSexController
{
    HeaderView* header;
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
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initView];
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:page_name_setting_sex navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void)initView
{
    selectedSex = [AppStatus sharedInstance].user.gender;
    [self showSexSelectedIcon:selectedSex];
    
    self.upSpliteLine.frame = CGRectMake(self.upSpliteLine.frame.origin.x, self.upSpliteLine.frame.origin.y, self.upSpliteLine.frame.size.width,  splite_line_height) ;
    self.upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.middleSpliteLine.frame = CGRectMake(self.middleSpliteLine.frame.origin.x, self.middleSpliteLine.frame.origin.y, self.middleSpliteLine.frame.size.width,  splite_line_height) ;
    self.middleSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.downSpliteLine.frame = CGRectMake(self.downSpliteLine.frame.origin.x, self.downSpliteLine.frame.origin.y, self.downSpliteLine.frame.size.width,  splite_line_height) ;
    self.downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    self.topView.frame = CGRectMake(0, header.frame.size.height, screen_width, self.topView.frame.size.height);
}

- (IBAction)setMaleSex:(id)sender {
    selectedSex = 1;
    [self showSexSelectedIcon:selectedSex];
}

- (IBAction)sexFemaleSex:(id)sender {
    selectedSex = 0;
    [self showSexSelectedIcon:selectedSex];
}

-(void)showSexSelectedIcon:(int)sex
{
    if (!sex) {
        self.femaleSelectedIcon.image = [UIImage loadImageWithImageName:@"sex_icon_select"];
        self.maleSelectedIcon.image = [UIImage new];
    }else
    {
        self.maleSelectedIcon.image = [UIImage loadImageWithImageName:@"sex_icon_select"];
        self.femaleSelectedIcon.image = [UIImage new];
    }
    [self popToFrontViewController:nil];
    [MobClick event:log_event_name_submit_new_gender];
}



-(void)popToFrontViewController:(id)sender
{
    
    AppStatus *as = [AppStatus sharedInstance];
    if (selectedSex == as.user.gender) {
        //[super popToFrontViewController:sender];
    }else
    {
        [SVProgressHUD showWithStatus:@"正在处理，请稍等..."];
        [[UserStore sharedStore] updateGender:^(NSError *err)
         {
             if (err == nil) {
                 [SVProgressHUD dismiss];
                 [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_user_gender object:nil];
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }userId:as.user.idStr gender:selectedSex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_setting_sex;
}

- (void)viewDidUnload {
    [self setMaleSelectedIcon:nil];
    [self setFemaleSelectedIcon:nil];
    [super viewDidUnload];
}
@end
