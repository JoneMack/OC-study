//
//  dutyAssistantController.m
//  DrAssistant
//
//  Created by 刘湘 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "dutyAssistantController.h"

@interface dutyAssistantController ()

@end

@implementation dutyAssistantController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lablec.layer.cornerRadius=8;
    _lablec.layer.masksToBounds=YES;
    self.blueView.layer.cornerRadius = 10.0;
    self.blueView.layer.masksToBounds = YES;
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
