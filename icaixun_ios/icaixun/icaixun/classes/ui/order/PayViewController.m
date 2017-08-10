//
//  PayViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/9.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define PAY_COIN_HEIGHT 49
#define PAY_COIN_MARGIN_LEFT 30

#import "PayViewController.h"
#import "WXPayProcessor.h"
#import "PayStore.h"
#import "UserStore.h"
#import "SystemStore.h"
#import "SystemPromptController.h"

@interface PayViewController ()

@end

@implementation PayViewController

-(void) viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePaySuccess) name:notification_name_update_pay_success object:nil];
}

-(void) initView
{
    // 设置大背景
    UIImage *bgImg = [UIImage imageNamed:@"bg_reg_640@2x.jpg"];
    self.view.layer.contents = (id) bgImg.CGImage;
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"充值" navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initBodyView
{
    self.bodyView = [[UIView alloc] init];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.frame.size.height);
    [self.view addSubview:self.bodyView];
    
    [self initFirstRow];
    [self initSecondRow];
    [self initThirdRow];
    [self initFourthRow];
    [self updateUserInfo];
    [self setupEvents];
}

-(void) initFirstRow
{
    self.commonTextLabel = [[UILabel alloc] init];
    self.commonTextLabel.text = @"我的财币";
    self.commonTextLabel.textColor = [UIColor whiteColor];
    self.commonTextLabel.font = [UIFont systemFontOfSize:12 weight:10];
    self.commonTextLabel.frame = CGRectMake((screen_width - 130) /2, 35, 55, 20);
    [self.bodyView addSubview:self.commonTextLabel];
    
    self.myCoinLabel = [[UILabel alloc] init];
    self.myCoinLabel.text = [NSString stringWithFormat:@"%d" , [[AppStatus sharedInstance].user getUserCurrentPoint]];
    self.myCoinLabel.textAlignment = NSTextAlignmentCenter;
    self.myCoinLabel.textColor = [UIColor whiteColor];
    self.myCoinLabel.font = [UIFont systemFontOfSize:20 weight:10];
    self.myCoinLabel.frame = CGRectMake(self.commonTextLabel.rightX,
                                        30, 70, 30);
    [self.bodyView addSubview:self.myCoinLabel];
    
    self.commonTextLabel = [[UILabel alloc] init];
    self.commonTextLabel.text = @"注意：1财币=1元";
    self.commonTextLabel.hidden = YES;
    self.commonTextLabel.textColor = [UIColor whiteColor];
    self.commonTextLabel.font = [UIFont systemFontOfSize:11];
    self.commonTextLabel.frame = CGRectMake(0, 55, screen_width, 20);
    self.commonTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.bodyView addSubview:self.commonTextLabel];
    
}

-(void) initSecondRow
{
    // 边框
    self.commonView = [[UIView alloc] init];
    self.commonView.frame = CGRectMake(PAY_COIN_MARGIN_LEFT ,
                                       self.commonTextLabel.bottomY + 28,
                                       screen_width - PAY_COIN_MARGIN_LEFT*2,
                                       PAY_COIN_HEIGHT);
    self.commonView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.commonView.layer.borderWidth = border_width;
    self.commonView.layer.cornerRadius = 10;
    self.commonView.layer.masksToBounds = YES;
    self.commonView.backgroundColor = [ColorUtils colorWithHexString:@"000000" alpha:0.1];
    [self.bodyView addSubview:self.commonView];
    
    // 文本
    self.commonTextLabel = [[UILabel alloc] init];
    self.commonTextLabel.text = @"充值财币";
    self.commonTextLabel.textColor = [UIColor whiteColor];
    self.commonTextLabel.font = [UIFont systemFontOfSize:13];
    self.commonTextLabel.frame = CGRectMake(10, 0, 60, PAY_COIN_HEIGHT);
    [self.commonView addSubview:self.commonTextLabel];
    
    // 提示文本
    UILabel *remindTextLabel = [[UILabel alloc] init];
    remindTextLabel.frame = CGRectMake(PAY_COIN_MARGIN_LEFT, self.commonView.frame.origin.y+PAY_COIN_HEIGHT, screen_width - PAY_COIN_MARGIN_LEFT*2, 20);
    remindTextLabel.text = @"提示：单次充值上限1000财币";
    remindTextLabel.textColor = [UIColor whiteColor];
    remindTextLabel.font = [UIFont systemFontOfSize:12];
    [self.bodyView addSubview:remindTextLabel];
    
    // 减
    self.reduceCoinBtn = [[UIButton alloc] init];
    [self.reduceCoinBtn setTitle:@"—" forState:UIControlStateNormal];
    [self.reduceCoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reduceCoinBtn.titleLabel setFont:[UIFont systemFontOfSize:20 weight:10]];
    self.reduceCoinBtn.frame = CGRectMake(self.commonView.frame.size.width - 130,
                                          0, PAY_COIN_HEIGHT-10, PAY_COIN_HEIGHT);
    [self.commonView addSubview:self.reduceCoinBtn];
    
    // 输入金额
    self.addCoinField = [[UITextField alloc] init];
    self.addCoinField.text = @"500";
    self.addCoinField.textAlignment = NSTextAlignmentCenter;
    self.addCoinField.delegate = self;
    self.addCoinField.textColor = [UIColor whiteColor];
    self.addCoinField.frame = CGRectMake(self.reduceCoinBtn.rightX, 0, 57, PAY_COIN_HEIGHT);
    
    [self.addCoinField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.addCoinField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.commonView addSubview:self.addCoinField];
    
    // 加
    self.addCoinBtn = [[UIButton alloc] init];
    [self.addCoinBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.addCoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addCoinBtn.titleLabel setFont:[UIFont systemFontOfSize:30 weight:10]];
    self.addCoinBtn.frame = CGRectMake(self.addCoinField.rightX, 0, PAY_COIN_HEIGHT-13, PAY_COIN_HEIGHT-5);
    [self.commonView addSubview:self.addCoinBtn];
}

-(void) initThirdRow
{
    // 第一根线
    CGRect lineFrame = CGRectMake( 37, self.commonView.bottomY+50,
                                  (screen_width - 37*2 -112)/2 , splite_line_height);
    self.commonView = [[UIView alloc] init];
    [self.commonView setBackgroundColor:[ColorUtils colorWithHexString:@"ffffff" alpha:0.3]];
    self.commonView.frame = lineFrame;
    [self.bodyView addSubview:self.commonView];
    
    // 提示
    self.commonTextLabel = [[UILabel alloc] init];
    self.commonTextLabel.text = @"选择支付方式";
    self.commonTextLabel.textColor = [UIColor whiteColor];
    self.commonTextLabel.font = [UIFont systemFontOfSize:13];
    self.commonTextLabel.frame = CGRectMake(self.commonView.rightX + 15,
                                            self.commonView.bottomY-9, 79, 15);
    [self.bodyView addSubview:self.commonTextLabel];
    
    // 第二根线
    lineFrame = CGRectMake( self.commonTextLabel.rightX+15, self.commonView.bottomY,
                           self.commonView.frame.size.width, splite_line_height);
    self.commonView = [[UIView alloc] init];
    [self.commonView setBackgroundColor:[ColorUtils colorWithHexString:@"ffffff" alpha:0.3]];
    self.commonView.frame = lineFrame;
    [self.bodyView addSubview:self.commonView];
    
}

-(void) initFourthRow
{
    // 边框
    CGRect borderFrame = CGRectMake(PAY_COIN_MARGIN_LEFT,
                                    self.commonTextLabel.bottomY+28,
                                    screen_width-PAY_COIN_MARGIN_LEFT*2, PAY_COIN_HEIGHT);
    self.commonView = [[UIView alloc] init];
    self.commonView.frame = borderFrame;
    self.commonView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.commonView.layer.borderWidth = border_width;
    self.commonView.layer.cornerRadius = 10;
    self.commonView.layer.masksToBounds = YES;
    self.commonView.backgroundColor = [ColorUtils colorWithHexString:@"000000" alpha:0.1];
    [self.bodyView addSubview:self.commonView];
    
    // 微信支付icon
    self.weixinIconView = [[UIImageView alloc] init];
    self.weixinIconView.image = [UIImage imageNamed:@"weixin_icon"];
    self.weixinIconView.frame = CGRectMake(10, 10, 30, 30);
    [self.commonView addSubview:self.weixinIconView];
    
    // 微信支付 label
    self.commonTextLabel = [[UILabel alloc] init];
    self.commonTextLabel.text = @"微信支付";
    self.commonTextLabel.textColor = [UIColor whiteColor];
    self.commonTextLabel.font = [UIFont systemFontOfSize:14];
    self.commonTextLabel.frame = CGRectMake(self.weixinIconView.rightX+15, 0, 60, borderFrame.size.height);
    [self.commonView addSubview:self.commonTextLabel];
    
    // 选中状态
    self.selectedView = [[UIImageView alloc] init];
    self.selectedView.image = [UIImage imageNamed:@"icon_select"];
    self.selectedView.frame = CGRectMake(self.commonView.frame.size.width - 30, 14.5, 20, 20);
    [self.commonView addSubview:self.selectedView];
    
    // 支付
    self.payBtn = [[UIButton alloc] init];
    [self.payBtn setTitle:@"马上充值" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[ColorUtils colorWithHexString:orange_text_color ] forState:UIControlStateNormal];
    [self.payBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:10]];
    self.payBtn.backgroundColor = [UIColor whiteColor];
    self.payBtn.layer.cornerRadius = 10;
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.frame = CGRectMake(PAY_COIN_MARGIN_LEFT, self.commonView.bottomY + 65,
                                   screen_width - PAY_COIN_MARGIN_LEFT*2, PAY_COIN_HEIGHT);
    [self.bodyView addSubview:self.payBtn];
    
}

-(void) setupEvents
{
    [self.reduceCoinBtn addTarget:self action:@selector(reducePoint) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addCoinBtn addTarget:self action:@selector(addPoint) forControlEvents:UIControlEventTouchUpInside];
    
    [self.payBtn addTarget:self action:@selector(payPoint) forControlEvents:UIControlEventTouchUpInside];
}

-(void) reducePoint
{
    int currentPoint = [self.addCoinField.text intValue];
    currentPoint--;
    if (currentPoint < 1) {
        currentPoint = 1;
    }
    self.addCoinField.text = [NSString stringWithFormat:@"%d" , currentPoint];
}


-(void) addPoint
{
    int currentPoint = [self.addCoinField.text intValue];
    currentPoint++;
    if (currentPoint > 1000) {
        currentPoint = 1000;
    }
    self.addCoinField.text = [NSString stringWithFormat:@"%d" , currentPoint];
}

//#pragma mark 监听 输入框 输入内容
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (self.addCoinField == textField) {
//        if (textField.text.length >= 4 && textField.text.intValue >1000) {
//            int currentPoint = [self.addCoinField.text intValue];
//            currentPoint = floor(currentPoint/10);
//            self.addCoinField.text = [NSString stringWithFormat:@"%d" , currentPoint];
//        }
//    }
//    return YES;
//}

- (void)textFieldEditingChanged:(id)sender
{
    if (sender == self.addCoinField) {
        if (self.addCoinField.text.intValue > 1000) {
            NSString *currentPoint = [self.addCoinField.text substringToIndex:[self.addCoinField.text length]-1];
            self.addCoinField.text = currentPoint;
        }else if (self.addCoinField.text.intValue == 0){
            self.addCoinField.text = @"";
        }
    }
}

#pragma mark - 触摸事件使键盘失去第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.addCoinField == textField) {
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        self.addCoinField.text = @"1";
    }
    
    if ([textField.text isEqualToString:@"0"]) {
        self.addCoinField.text = @"1";
    }
}

-(void) payPoint
{
 
    NSString *point = self.addCoinField.text;
    
    [PayStore postNewOrder:^(PointOrder *pointOrder, NSError *err) {
        if (err == nil) {
            
            [WXPayProcessor sharedInstance].point = point;
            [[WXPayProcessor sharedInstance] payPoint:^(NSError *err) {
            } userId:[AppStatus sharedInstance].user.id
                                              orderNo:pointOrder.orderNo
                                            payAmount:[NSString stringWithFormat:@"%f",pointOrder.amount]];
        }
    } userId:[AppStatus sharedInstance].user.id point:point payAmount:point];
}

-(void) updatePaySuccess
{
    [self performSelector:@selector(updateUserInfo) withObject:nil afterDelay:3];
    
}

-(void) updateUserInfo
{
    [[UserStore sharedStore] myUserInfo:^(User *user, NSError *err) {
        if (err == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_update_user_info object:nil];
            self.myCoinLabel.text = [NSString stringWithFormat:@"%d" , [[AppStatus sharedInstance].user getUserCurrentPoint]];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
