//
//  MarriageViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MarriageViewController.h"

@interface MarriageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *unmarried;
@property (weak, nonatomic) IBOutlet UIButton *married;
@property (weak, nonatomic) IBOutlet UIButton *bereft;
@property (weak, nonatomic) IBOutlet UIButton *divorce;

@end

@implementation MarriageViewController
- (IBAction)buttonAction:(UIButton *)sender {
    if (_marredBlock) {
        _marredBlock(sender.tag + 1);
    }
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