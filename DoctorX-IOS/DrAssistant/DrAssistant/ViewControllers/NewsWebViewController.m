//
//  NewsWebViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/19.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "NewsWebViewController.h"

@interface NewsWebViewController ()

@end

@implementation NewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *H_String = [NSString stringWithFormat:@"<h2 align='center'>%@</h2>",self.newsModel.title];
    NSString *authorString = [NSString stringWithFormat:@"<p>作者:%@</p><p>时间:%@</p>",self.newsModel.creator,self.newsModel.create_time];
    NSString *contentString = [NSString stringWithFormat:@"<div><p>%@</p></div>",self.newsModel.content];
    
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@",H_String,authorString,contentString];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
    [webView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:webView];
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
