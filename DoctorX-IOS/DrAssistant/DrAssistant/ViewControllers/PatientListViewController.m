//
//  PatientListViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/27.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "PatientListViewController.h"

@interface PatientListViewController ()

@end

@implementation PatientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];//[BASEURL s:@"/actions/report/patientList"];
    [Utils showStatusToast:@"请稍后..."];
    self.webView.scalesPageToFit=YES;
    NSString* reqAddr=[NSString stringWithFormat:@"%@%@%@",BASEURL,@"/actions/report/patientList?userId=",[GlobalConst shareInstance].loginInfo.iD];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:reqAddr]];
    //加载指定url对应的网址
    [self.webView loadRequest:request];
    [Utils dismissStatusToast];
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
