//
//  MyQRCodeViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/11/27.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "UIImage+MDQRCode.h"
@interface MyQRCodeViewController ()

@end

@implementation MyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     doctor:{"loginName":"15136269111","realName":"刘啦啦","userType":"2","userid":1060}

     private long userid;
     private String loginName;
     private String realName;
     private String userType; // 用户类型, 1 医生 2 患者
     */
    NSString *userId = [GlobalConst shareInstance].loginInfo.iD;
    NSString *userLoginName = [GlobalConst shareInstance].loginInfo.login_name;
    NSString *userRealName = [GlobalConst shareInstance].loginInfo.real_name;
    long userType = [GlobalConst shareInstance].loginInfo.user_type;
    
    NSString *QRString = [NSString stringWithFormat:@"{\"loginName\":\"%@\",\"realName\":\"%@\",\"userType\":\"%ld\",\"userid\":%@}",userLoginName,userRealName,userType,userId];
    
    NSLog(@"%@",QRString);
    
    self.ORImage.image = [UIImage mdQRCodeForString:QRString size:100.0];
    
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
