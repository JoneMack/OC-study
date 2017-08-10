//
//  MyShareViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/8/31.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyShareViewController.h"
#import <MessageUI/MessageUI.h>
@interface MyShareViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (IBAction)sendEmail:(id)sender
{
   // NSLog(@"1");
    [self sendmail];

}
- (IBAction)sendMessage:(id)sender
{
   // NSLog(@"2");
    [self msg2];
}

- (void)msg2
{
    // 判断用户设备能否发送短信
    if (![MFMessageComposeViewController canSendText]) {
        [self showString:@"您的手机不能发送短信"];
        return;
    }
    
    // 1. 实例化一个控制器
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    // 2. 设置短信内容
    // 1) 收件人
    controller.recipients = @[];
    
    // 2) 短信内容
    controller.body = @"《医生助理》，作为一家为中国医生提供“专属助理”服务的公司，我们将会第一时间搭建起您和医生联系的桥梁，并及时推荐更适合您疾病治疗的专科医生，细腻、贴心、持续、无缝隙的医生助理服务将会带给您更加便捷、高效的医疗体验！官方网址：www.5idoctor.com ";
    
    // 3) 设置代理
    controller.messageComposeDelegate = self;
    
    // 3. 显示短信控制器
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark 短信控制器代理方法
/**
 短信发送结果
 
 MessageComposeResultCancelled,     取消
 MessageComposeResultSent,          发送
 MessageComposeResultFailed         失败
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%d", result);
    
    // 在面向对象程序开发中，有一个原则，谁申请，谁释放！
    // *** 此方法也可以正常工作，因为系统会将关闭消息发送给self
    //    [controller dismissViewControllerAnimated:YES completion:nil];
    
    // 应该用这个！！！
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//激活邮件功能
- (void)sendmail
{
    // 1. 先判断能否发送邮件
    if (![MFMailComposeViewController canSendMail]) {
        // 提示用户设置邮箱
        [self showString:@"请先设置手机邮箱"];
        return;
    }
    
    // 2. 实例化邮件控制器，准备发送邮件
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    // 1) 主题
    [controller setSubject:@"这款App分享给你！"];
    // 2) 收件人
    [controller setToRecipients:@[]];
    
    // 3) cc 抄送
    // 4) bcc 密送
    // 5) 正文
    [controller setMessageBody:@"《医生助理》，作为一家为中国医生提供“专属助理”服务的公司，我们将会第一时间搭建起您和医生联系的桥梁，并及时推荐更适合您疾病治疗的专科医生，细腻、贴心、持续、无缝隙的医生助理服务将会带给您更加便捷、高效的医疗体验！官方网址：www.5idoctor.com " isHTML:YES];
    
    // 6) 附件
    UIImage *image = [UIImage imageNamed:@"Icon-60.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    // 1> 附件的二进制数据
    // 2> MIMEType 使用什么应用程序打开附件
    // 3> 收件人接收时看到的文件名称
    // 可以添加多个附件
    [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"icon.png"];
    
    // 7) 设置代理
    [controller setMailComposeDelegate:self];
    
    // 显示控制器
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - 邮件代理方法
/**
 MFMailComposeResultCancelled,      取消
 MFMailComposeResultSaved,          保存邮件
 MFMailComposeResultSent,           已经发送
 MFMailComposeResultFailed          发送失败
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
//    NSLog(@"%d", result);
    [self dismissViewControllerAnimated:YES completion:nil];
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
