//
//  MenZhenYuYueController.m
//  DrAssistant
//
//  Created by hi on 15/9/8.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MenZhenYuYueController.h"
#import "MenZhenYuYueCell.h"
#import "YuYueListViewController.h"
#import "YuYueRecordController.h"
#import "SegmentContainerController.h"

@interface MenZhenYuYueController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong) SegmentContainerController *containerVC;
@end

@implementation MenZhenYuYueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%@",self.dataArr);
    self.view.backgroundColor = [UIColor defaultBgColor];
    
    self.title = @"门诊预约";
    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YuYueListViewController *sVC = [YuYueListViewController simpleInstance];
    sVC.dataArr = self.dataArr;
    sVC.dataEntity = self.dataEntity;
    sVC.title = @"门诊预约";
    
    YuYueRecordController *zVC = [YuYueRecordController simpleInstance];
    zVC.reciveDataArray = self.dataArr;
    zVC.title = @"预约记录";
    
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

@end
