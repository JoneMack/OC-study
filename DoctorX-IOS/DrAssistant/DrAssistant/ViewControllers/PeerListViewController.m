//
//  PeerListViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/27.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "PeerListViewController.h"

@interface PeerListViewController ()

@end

@implementation PeerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [Utils showStatusToast:@"请稍后..."];
    self.webView.scalesPageToFit=YES;
    NSString* reqAddr=[NSString stringWithFormat:@"%@%@%@",BASEURL,@"/actions/report/peerList?userId=",[GlobalConst shareInstance].loginInfo.iD];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:reqAddr]];
    [Utils dismissStatusToast];
    //加载指定url对应的网址
    [self.webView loadRequest:request];
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
