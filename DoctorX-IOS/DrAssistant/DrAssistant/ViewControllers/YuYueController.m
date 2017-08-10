//
//  YuYueController.m
//  DrAssistant
//
//  Created by taller on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "YuYueController.h"
#import "SegmentContainerController.h"
#import "YuYueOrderDateViewController.h"
#import "YuYueOrderNameViewController.h"
#import  "YuYueEntity.h"
@interface YuYueController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong) SegmentContainerController *containerVC2;
@end

@implementation YuYueController
- (void)viewDidLoad {
//
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor defaultBgColor];
    
    self.title = @"预约我的";
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YuYueOrderNameViewController *sVC = [YuYueOrderNameViewController simpleInstance];
    sVC.title = @"按名字";
    
    YuYueOrderDateViewController *zVC = [YuYueOrderDateViewController simpleInstance];
    zVC.title = @"按时间";
    NSArray *vcs = @[sVC, zVC];
    _containerVC2 = [[SegmentContainerController alloc]initWithControllers:vcs
                    
                                                             topBarHeight:statusHeight + navigationHeight
                                                     parentViewController:self];
    _containerVC2.delegate = self;
    
    UIColor *nor_color = COLOR(0, 174, 191, 1.0);
    _containerVC2.menuBackGroudColor = self.view.backgroundColor;
    _containerVC2.menuIndicatorColor = nor_color;
    _containerVC2.menuItemTitleColor = [UIColor blackColor];
    _containerVC2.menuItemSelectedTitleColor = nor_color;
    [self.view addSubview:_containerVC2.view];
}
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"%ld",(long)index);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud removeObjectForKey:@"YUYUEDATAARRAY"];
}

@end
