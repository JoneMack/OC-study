//
//  YBPayPasswordAlertView.m
//
//  Created by xubojoy on 2018/3/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "YBPayPasswordAlertView.h"
#import "UIColor+Expanded.h"
#import "UIButton+YBCategory.h"
#define KRIOS  ([UIScreen mainScreen].bounds.size.width*1.0/375.0)
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define PwdCtrlLicense @"123456789"

@interface YBPayPasswordAlertView()
{
    UIButton * forgetBtn;
    UIButton *queRenBtn;
}

@end
@implementation YBPayPasswordAlertView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.6;
        [self addSubview:self.blackView];
//        [self initWithView];
    }
    return self;
}

/**
 *  初始化界面
 */
-(void)initWithView
{
    if(self.alertView)
    {
        [self.alertView removeFromSuperview];
    }
    
    CGFloat keyboardHeight =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"keyboardHeight"] floatValue];
    if(keyboardHeight == 0)
    {
        keyboardHeight = 216*KRIOS;
    }
    //支付密码
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-keyboardHeight-218, screenWidth, 218)];
    self.alertView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8f8"];
    self.alertView.userInteractionEnabled=YES;
    
    [self addSubview:self.alertView];
    [self createTitle];
}
//创建标题
-(void)createTitle
{
    UILabel *theTitleShow = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 51)];
    theTitleShow.text=@"支付密码";
    theTitleShow.tag=300;
    [self.alertView addSubview:theTitleShow ];
    theTitleShow .font = [UIFont systemFontOfSize:18];
    theTitleShow .textColor = [UIColor colorWithHexString:@"696b70"];
    theTitleShow .textAlignment = NSTextAlignmentCenter;
    
    //close按钮
    UIButton * quiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quiteBtn setImage:[UIImage imageNamed:@"icon_dele"] forState:UIControlStateNormal];
    // self.quiteBtn.imageEdgeInsets=UIEdgeInsetsMake(8, 8, 8, 8);
    quiteBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [quiteBtn addTarget:self action:@selector(quiteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    quiteBtn.frame = CGRectMake(15, 7, 36, 36);
    [self.alertView addSubview:quiteBtn];
    [self createMessage];
    
}
-(void)createMessage
{
    if(self.passGuard)
    {
        [self.passGuard removeFromSuperview];
    }
    
    UIView *tempWhite=[UIView new];
    tempWhite.frame = CGRectMake(0, 51, screenWidth, 50);
    tempWhite.backgroundColor=[UIColor whiteColor];
    [self.alertView addSubview:tempWhite];
    
    self.passGuard = [[PassGuardTextField alloc]initWithFrame:CGRectMake(15, 0, screenWidth, 42)];
    
    [tempWhite addSubview:self.passGuard];
    
    [self.passGuard setM_license:PwdCtrlLicense];
    
    //self.passGuard.m_mode = YES;
    
    //左边view
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 95, 50)];
    UILabel * leftlbl = [[UILabel alloc]initWithFrame:CGRectMake(11, 0, 40, 50)];
    leftlbl.text = @"密码";
    leftlbl.font = [UIFont systemFontOfSize:15];
    leftlbl.textColor = [UIColor colorWithHexString:@"2a2b2d"];
    [leftView addSubview:leftlbl];
    
    self.passGuard.leftView = leftView;
    self.passGuard.leftViewMode = UITextFieldViewModeAlways;
    self.passGuard.secureTextEntry = YES;
    self.passGuard.returnKeyType = UIReturnKeyDone;
    [self.passGuard setPlaceholder:@"请输入支付密码"];
    [self.passGuard setM_uiapp:[UIApplication sharedApplication]];
    [self.passGuard setKeyboardType:UIKeyboardTypeDefault];
    self.passGuard.m_iMaxLen = 16;
    self.passGuard._DoneDelegate=self;
    self.passGuard._onchardelegate = self;
    //#to 添加密码键盘按下效果-----------
    self.passGuard.m_ikeypresstype = 2;
    [self.passGuard becomeFirstResponder];
    self.passGuard.font = [UIFont systemFontOfSize:15];
    self.passGuard.backgroundColor = [UIColor clearColor];
    [self.passGuard setM_strInput1:_randomKey];
    [self.passGuard setM_strInput2:_pubKey];
    
    
    forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgetBtn.frame = CGRectMake(screenWidth-15-110, tempWhite.frame.size.height+tempWhite.frame.origin.y, 110, 30);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font= [UIFont systemFontOfSize:12];
    forgetBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
    [self.alertView addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createButtons];
}

//忘记支付密码
-(void)forgetBtnClick:(UIButton *)btn
{
    [self.passGuard resignFirstResponder];
    if([self.delegate_pay respondsToSelector:@selector(forgetPayPassword)]){
      [self.delegate_pay forgetPayPassword];
    }
    [self close];
}

#pragma mark passguard delegate
-(void)OnChar:(id)sender Char:(NSString *)inchar
{
    NSLog(@"");
    if(inchar.length > 0)
    {
        [queRenBtn canUseButton];
    }else{
        [queRenBtn noUseButton];
    }
}
-(void)DoneFun:(id)sender
{
    [self.passGuard resignFirstResponder];
    if(_passGuard.text.length >0)
    {
        if(self.payPSWBlock)
        {
            self.payPSWBlock([self.passGuard getOutput4:2]);
            [self close];
        }
    }
}
#pragma mark 创建按钮
-(void)createButtons
{
    
    queRenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    queRenBtn.frame = CGRectMake(10, 218-30-45, screenWidth-20, 45);
    queRenBtn.backgroundColor=[UIColor clearColor];    //ylighGrayColor
    [queRenBtn noUseButton];
    [queRenBtn setButtonCorner];
    [queRenBtn setTitle:@"确定" forState:UIControlStateNormal];
    queRenBtn.tag=201;
    [queRenBtn addTarget:self action:@selector(onclinkButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:queRenBtn];
}
#pragma mark 事件 200 取消  201 确认
-(void)onclinkButton:(UIButton *)sender
{
    if(sender.tag==200)
    {
        if([self.delegate_pay respondsToSelector:@selector(closeAlert)])
        {
            [self.delegate_pay closeAlert];
        }
        [self close];
        
    }else if(sender.tag==201)
    {
        if([self.passGuard.text length]>0)
        {
            if(self.payPSWBlock)
            {
                self.payPSWBlock([self.passGuard getOutput4:2]);
            }
            
        }else
        {
            
        }
    }
}

-(void)quiteBtnClick:(UIButton *)btn
{
    if([self.delegate_pay respondsToSelector:@selector(closeAlert)]){
       [self.delegate_pay closeAlert];
    }
    [self close];
}


-(void)showInView:(UIView *)view
{
    
    [view addSubview:self];
}
-(void)close
{
    CATransform3D currentTransform = self.alertView.layer.transform;
    CGFloat startRotation = [[self.alertView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    self.alertView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    self.alertView.layer.opacity = 1.0f;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.alertView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
//                         [self.blackView removeFromSuperview];
//                         [self.alertView removeFromSuperview];
                     }
     ];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end

