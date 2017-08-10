//
//  UserProtrolViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/11/26.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "UserProtrolViewController.h"

@interface UserProtrolViewController ()

@end

@implementation UserProtrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
    webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:webView];

    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"UserProtocal" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
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
