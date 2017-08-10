//
//  GroupDiscribeViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/11/5.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "GroupDiscribeViewController.h"

@interface GroupDiscribeViewController ()

@end

@implementation GroupDiscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"病情描述";
    self.view.backgroundColor = [UIColor defaultBgColor];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, kSCREEN_WIDTH-20, 84)];
    lab.text = self.groupDiscribe;
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
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
