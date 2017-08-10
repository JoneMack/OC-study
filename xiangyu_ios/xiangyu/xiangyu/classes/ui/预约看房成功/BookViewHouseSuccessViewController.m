//
//  BookViewHouseSuccessViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "BookViewHouseSuccessViewController.h"

@interface BookViewHouseSuccessViewController ()

@end

@implementation BookViewHouseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
}

- (void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"提交成功" navigationController:self.navigationController];
    [self.headerViewBlock addSubview:self.headerView];
}


-(void) initBodyView
{
    [self.viewMyBookHistory setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    [self.viewMyBookHistory setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.viewMyBookHistory.layer.masksToBounds = YES;
    self.viewMyBookHistory.layer.cornerRadius = 5;
    
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
