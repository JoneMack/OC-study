//
//  MapFindCommunityListController.m
//  xiangyu
//
//  Created by xubojoy on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MapFindCommunityListController.h"
#import "AppDelegate.h"
@interface MapFindCommunityListController ()

@end

@implementation MapFindCommunityListController
- (instancetype)initWithTitle:(NSString *)titleName{
    self = [super init];
    if (self) {
        self.titleName = titleName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHeaderView];
}
- (void)initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:self.titleName navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.drawerController = [(AppDelegate*)[UIApplication sharedApplication].delegate drawerController];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
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

@end
