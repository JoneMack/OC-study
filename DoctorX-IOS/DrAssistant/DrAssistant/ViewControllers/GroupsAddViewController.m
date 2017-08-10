//
//  GroupsAddViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/13.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "GroupsAddViewController.h"

@interface GroupsAddViewController ()

@end

@implementation GroupsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"新建群组";
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(commitDataAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.gView.layer.borderColor = [UIColor colorWithRed:50 green:50 blue:50 alpha:1].CGColor;
    //self.gView.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)commitDataAction{
    NSLog(@"GroupsAdd");
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
