//
//  ZhuanZhenJieZhenViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ZhuanZhenJieZhenViewController.h"
#import "SegmentContainerController.h"
#import "JieZhenViewController.h"
#import "ZhuanZhenViewController.h"
#import "SaveZhuanZhenViewController.h"

@interface ZhuanZhenJieZhenViewController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong) SegmentContainerController *containerVC;

@end

@implementation ZhuanZhenJieZhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor defaultBgColor];
    [self addRightBtnAction];
    self.title = @"接诊/转诊";
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    JieZhenViewController *sVC = [JieZhenViewController simpleInstance];
    sVC.title = @"接诊纪录";
    
    ZhuanZhenViewController *zVC = [ZhuanZhenViewController simpleInstance];
    zVC.title = @"转诊记录";
    
    NSArray *vcs = @[sVC, zVC];
    _containerVC = [[SegmentContainerController alloc]initWithControllers:vcs
                    
                                                             topBarHeight:statusHeight + navigationHeight
                                                     parentViewController:self];
    _containerVC.delegate = self;
    
    UIColor *nor_color = COLOR(0, 174, 191, 1.0);
    _containerVC.menuBackGroudColor = self.view.backgroundColor;
    _containerVC.menuIndicatorColor = nor_color;
    _containerVC.menuItemTitleColor = [UIColor blackColor];
    _containerVC.menuItemSelectedTitleColor = nor_color;
    
    [self.view addSubview:_containerVC.view];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"%ld",(long)index);
}

#pragma mark - addRightNavBtn
- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addHealthDataBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    //UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"＋" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{
    NSLog(@"@@@@@");
    
    SaveZhuanZhenViewController *save = [SaveZhuanZhenViewController simpleInstance];
    save.title = @"转诊录入";
    [self.navigationController pushViewController:save animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
