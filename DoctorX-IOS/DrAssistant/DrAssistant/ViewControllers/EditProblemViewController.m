//
//  EditProblemViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "EditProblemViewController.h"
#import "AddProblemViewController.h"

@interface EditProblemViewController ()

@end

@implementation EditProblemViewController
- (IBAction)addProblemAction:(id)sender {
    AddProblemViewController *editVC = [AddProblemViewController simpleInstance];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
