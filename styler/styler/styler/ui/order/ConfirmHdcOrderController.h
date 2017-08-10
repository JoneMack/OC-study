//
//  ConfirmOrderController.h
//  styler
//
//  Created by wangwanggy820 on 14-6-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define payment_status_waiting 1 //等待支付状态
#define payment_status_paying 2 //正在支付状态

#define pay_model_hdc 1 //美发卡支付模式
#define pay_model_user_hdc 2 //用户美发卡支付模式

#define select_icon_x 285


#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "HairDressingCard.h"
#import "Organization.h"
#import "UserHdc.h"
#import "HdcDigest.h"
#import "RedEnvelope.h"
#import "RedEnvelopeQuery.h"
#import "User.h"
#import "PayProcessor.h"


/*
该支付页面可以针对两种场景进行支付：
 1）美发卡支付场景
 2）用户美发卡支付场景
 有三个要点需要针对不同的场景分别处理：
 1）美发卡摘要视图
 2）更新美发卡数量
 3）确认支付
 */
@interface ConfirmHdcOrderController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *wrapperTableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) IBOutlet UIView *instructionViewBg;

@property (weak, nonatomic) IBOutlet UIView *instructionView;


@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) UILabel *rightLab;

@property int cardId;
@property int stylistId;  // 购买成功后用于收藏发型师用。
@property (nonatomic,strong) User *user;
@property (nonatomic, strong) HairDressingCard *card;
@property (nonatomic, copy) NSString *userHdcNum;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, strong) UserHdc *userHdc;
@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) RedEnvelope *selectRedEnvelope;
@property (nonatomic, strong) RedEnvelopeQuery *query;
@property (strong, nonatomic) NSMutableArray *redEnvelopes;
@property int lockedRedEnvelopeId;
@property (nonatomic, strong) RedEnvelope *lockedRedEnvelope;

@property PaymentType *paymentType;
@property float paymentAmount;

//支付模式
@property int payModel;
@property BOOL hasRedEnvelopes;

- (IBAction)submitPayment:(id)sender;
- (float)getPaymentAmountWithRedEnvelope:(float)price;
- (void)fillViewOtherInfo:(int)organizationId hairDressingCardId:(int)hairDressingCardId;
@end
