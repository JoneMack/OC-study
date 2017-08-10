//
//  AboutController.m
//  styler
//
//  Created by System Administrator on 13-7-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "AboutUsController.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"

@interface AboutUsController ()

@end

@implementation AboutUsController
{
    NSArray *matches;
}
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.textView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initExtraInfo];
}

static int height =0;
-(void)initHeader
{
    HeaderView *header = [[HeaderView alloc]initWithTitle:page_name_about_us navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    height = header.frame.size.height;
}

-(void) initExtraInfo{

    self.textView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    NSString *text = self.textView.text;
    int length1 = text.length;
    text = [text stringByAppendingString:@"\n\n"];
    text = [text stringByAppendingString:[NSString stringWithFormat:@"软件版本：%@",[AppStatus sharedInstance].appVersion]];
    int length2 = text.length;
    text = [text stringByAppendingString:@"\n\n"];
    text = [text stringByAppendingString:@"官方微博：时尚猫官方微博"];
    int length3 = text.length;
    text = [text stringByAppendingString:@"\n\n"];
    text = [text stringByAppendingString:@" 400热线：400-156-1618"];
    int length4 = text.length;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
    //设置字体颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:gray_text_color] range:NSMakeRange(0,length1)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[ColorUtils colorWithHexString:black_text_color] range:NSMakeRange(length1,length3 - length1)];
    //设置字体大小
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:default_font_size] range:NSMakeRange(0, length4)];
    //设置链接              下划线
    [attrStr addAttribute:NSLinkAttributeName value:@"http://e.weibo.com/piaopiaoxiuwang"
                    range:[[attrStr string] rangeOfString:@"时尚猫官方微博"]];
    [attrStr addAttribute:NSLinkAttributeName value:@"tel://400-156-1618"
                    range:[[attrStr string] rangeOfString:@"400-156-1618"]];
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 7) {
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                         NSUnderlineColorAttributeName: [UIColor blueColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        //链接下划线
        self.textView.linkTextAttributes = linkAttributes;
    }else{
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(length2 + 7, length3 - length2 - 7)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(length3 + 9, length4 - length3 - 9)];
    }

    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    matches = [detector matchesInString:text options:0 range:NSMakeRange(0,text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        [attrStr addAttribute:NSUnderlinePatternSolid value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
    }
    
    
    
    self.textView.attributedText = attrStr;
    self.textView.scrollsToTop = NO;
    self.textView.delegate = self;
    CGRect frame =self.textView.frame;
    frame.origin.y = height + 2*general_padding;
    self.textView.frame = frame;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.description isEqual:@"tel://400-156-1618"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"400-156-1618" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        [MobClick event:log_event_name_call_org_phone];
        return NO;
    }
    [[UIApplication sharedApplication] openURL:URL];
    [MobClick event:log_event_name_share_to_sina_weibo attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"微博分享", @"分享",nil]];
    return YES;
}

#pragma mark -----UIAlertViewDelegate------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4001561618"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_about_us;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
