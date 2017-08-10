//
//  TongJiListViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/19.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "TongJiListViewController.h"
#import "PatientListViewController.h"
#import "PeerListViewController.h"
#import "BespokeListViewController.h"
#import "JzzzListViewController.h"
@interface TongJiListViewController ()

@end

@implementation TongJiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftBtnAction];
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

- (IBAction)patientList:(id)sender {
    PatientListViewController *pVC = [PatientListViewController simpleInstance];
    pVC.title=@"患者统计";
    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)peerList:(id)sender {
    PeerListViewController *pVC = [PeerListViewController simpleInstance];
    pVC.title=@"同行统计";
    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)bespokeList:(id)sender {
    BespokeListViewController *pVC = [BespokeListViewController simpleInstance];
    pVC.title=@"预约统计";
    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)jzzzList:(id)sender {
    JzzzListViewController *pVC = [JzzzListViewController simpleInstance];
    pVC.title=@"接诊转诊统计";
    [self.navigationController pushViewController:pVC animated:YES];
}
@end
