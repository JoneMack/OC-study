//
//  ConfirmOrderController.m
//  styler
//
//  Created by wangwanggy820 on 14-6-27.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ConfirmHdcOrderController.h"
#import "UIViewController+Custom.h"
#import "UIView+Custom.h"
#import "ImageUtils.h"
#import "HdcStore.h"
#import "HdcDigestView.h"
#import "OrganizationStore.h"
#import "AlipayProcessor.h"
#import "AlipayWebController.h"
#import "AlipayProcessor.h"
#import "HdcDigest.h"
#import "AlixLibService.h"
#import "AlixPayOrder.h"
#import "DataSigner.h"
#import "CustomAlertView.h"
#import "RedEnvelopeStore.h"
#import "UserSelectRedEnvelopeController.h"
#import "WeiXinPayProcessor.h"
#import "PayProcessor.h"

#define left_label_width         150
#define price_width              30
#define price_height             22
#define left_btn_x               210
#define zhifubao_icon_height     38
#define zhifubao_icon_width      79
#define zhifubao_app_icon_width  38
#define pay_for_card_btn_padding 40
#define pay_type_label_y         17
#define remind_image_view_width  310
#define remind_label_y          5
#define remind_label_width      240
#define remind_label_height      25
#define right_remind_btn_x       245
#define default_single_max_buy_count  10
#define change_hdc_card_count_error_message  @"使用红包时一次只能购买1张美发卡"
#define selected_payment_icon     3


@interface ConfirmHdcOrderController ()

@end

@implementation ConfirmHdcOrderController
{
    UILabel *totalPrice;
    UIButton *leftBtn;
    UITextField *hdcCount;  // 购买的美发卡数量
    UIButton *rightBtn;
    int singleMaxBuy;
    UIView *bg;
    UIView *preView;
    NSArray *paymentTypes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self renderPaymentType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化数据
    paymentTypes = [[PayProcessor sharedInstance] getPaymentTypes];
    self.paymentType = [[PayProcessor sharedInstance] getDefaultPaymentType];
    singleMaxBuy = default_single_max_buy_count;
    
    // 初始化UI
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    [self initTableView];
    [self initPaymentBtn];
}

-(void)initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_buy_hdc navigationController:self.navigationController];
    //  支付说明提醒按钮
    int paymentRemindY = 0;
    if (IOS7) {
        paymentRemindY = status_bar_height;
    }
    UIButton *remindBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    remindBtn.frame = CGRectMake(right_remind_btn_x, paymentRemindY, 70, navigation_height);
    [remindBtn setTitle:@"支付说明" forState:UIControlStateNormal];
    [remindBtn setTitleColor:[ColorUtils colorWithHexString:red_color] forState:UIControlStateNormal];
    [remindBtn addTarget:self action:@selector(remindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:remindBtn];
    [self.view addSubview:self.header];
}

-(void)initAlertPaymentExplain{
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.hasInitialPromptHdcOrderPaymentExplain) {
        as.hasInitialPromptHdcOrderPaymentExplain = YES;
        [self remindBtnClick];
        [AppStatus saveAppStatus];
    }
}

-(void)remindBtnClick{
    AppStatus *as = [AppStatus sharedInstance];
    int minimumPaymentAmount = (int)as.minimumPaymentAmount;
    NSString *msg;
    if (as.minimumPaymentAmount > minimumPaymentAmount) {
        msg = [NSString stringWithFormat:@"1、当应付金额大于500时，需选择支付宝余额支付或微信支付\n2、使用红包的面额大于美发卡金额时，支付金额为%.2f元" ,as.minimumPaymentAmount];
    }else{
        msg = [NSString stringWithFormat:@"1、当应付金额大于500时，需选择支付宝余额支付或微信支付\n2、使用红包的面额大于美发卡金额时，支付金额为%d元" ,minimumPaymentAmount];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付说明" message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)loadData{
    //加载卡片信息
    [SVProgressHUD showWithStatus:network_status_loading];
    if (self.payModel == pay_model_hdc) { 
        [self loadHdc];
    }else if(self.payModel == pay_model_user_hdc){
        [self loadUserHdc];
    }
}

-(void)loadHdc{
    [HdcStore getHdc:^(HairDressingCard *card, NSError *error) {
        if (error == nil) {
            self.card = card;
            if (card.saleRule.singleMaxBuy > 0) {
                singleMaxBuy = card.saleRule.singleMaxBuy;
            }
            [self fillViewOtherInfo:((NSNumber*)self.card.saleRule.organizationIds[0]).intValue
                 hairDressingCardId:card.id];
        }else{
            StylerException *exception = [[error userInfo] objectForKey:@"stylerException"];
            [SVProgressHUD showErrorWithStatus:exception.message duration:1.5];
        }
    } cardId:self.cardId];
}

-(void)loadUserHdc{
    [HdcStore getUserHdcByUserHdcNums:^(NSArray *userHdcs, NSError *error) {
        if (error == nil) {
            self.userHdc = userHdcs[0];
            [self fillViewOtherInfo:self.userHdc.organizationId hairDressingCardId:self.userHdc.hairDressingCardId];
        }
    } userHdcNums:self.userHdcNum];
}

-(void) fillViewOtherInfo:(int)organizationId hairDressingCardId:(int)hairDressingCardId{
    //加载商户信息
    [OrganizationStore getOrganizationById:^(Organization *orginzation, NSError *err) {
        if(orginzation != nil){
            self.organization = orginzation;
            [self.wrapperTableView reloadData];
            [self renderPaymentType];
        }
        
    } organizationId:organizationId hasStylists:YES];
    
    //查看是否有可用的红包
    [RedEnvelopeStore getMyRedEnvelopes:^(Page *page, NSError *error) {
        self.hasRedEnvelopes = (page.totalCount>0||self.hasRedEnvelopes)? YES : NO;
        if (self.hasRedEnvelopes) {
            self.redEnvelopes = [NSMutableArray new];
            [self.redEnvelopes addObjectsFromArray:page.items];
            [self.wrapperTableView reloadData];
            [self renderPaymentType];
        }
        [SVProgressHUD dismiss];
        [self initAlertPaymentExplain];
    } redEnvelopeQuery:nil hairDressingCardId:hairDressingCardId];
    
}

-(HdcDigest *) getHdcDigest{
    if (self.userHdc != nil) {
        return [[HdcDigest alloc] initWithUserHdc:self.userHdc organization:self.organization];
    }else{
        return [[HdcDigest alloc] initWithHdc:self.card organization:self.organization];
    }
}

-(void)initTableView{
    self.wrapperTableView.delegate = self;
    self.wrapperTableView.dataSource = self;
    self.wrapperTableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    CGRect frame = self.wrapperTableView.frame;
    frame.origin.y = [self.header bottomY];
    if ([UIApplication sharedApplication].keyWindow.frame.size.height == self.view.frame.size.height) {
        frame.size.height = self.view.frame.size.height-self.header.frame.size.height-tabbar_height;
    }else{
        
        frame.size.height = self.view.frame.size.height-self.header.frame.size.height-tabbar_height-status_bar_height;
    }

    self.wrapperTableView.frame = frame;
    self.wrapperTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - left_label_width - general_padding, 0, left_label_width, general_cell_height)];
    totalPrice.backgroundColor = [UIColor clearColor];
    totalPrice.font = [UIFont systemFontOfSize:default_font_size];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.textColor = [ColorUtils colorWithHexString:red_color];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1){
        return 4;
    }
    else if (section == 2)  // 支付方式
    {
        return paymentTypes.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return hdc_digest_view_height;
    }else if (indexPath.section == 1){
        if (!self.hasRedEnvelopes && indexPath.row == 2) {
            return 0;
        }
    }
    return general_cell_height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return general_cell_height;
    }else if (section == 2){
        return 0;
    }
    return general_padding;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) { // 美发卡摘要
        if (self.card != nil || self.userHdc != nil) {
            HdcDigest *hdc = [self getHdcDigest];
            HdcDigestView *hdcDigestView = [[HdcDigestView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, hdc_digest_view_height)];
            [hdcDigestView render:hdc];
            [cell addSubview:hdcDigestView];
        }
    }else if (indexPath.section == 1){ // 支付订单信息
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, 0, 80, general_cell_height)];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:default_font_size];
        leftLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        [cell.contentView addSubview:leftLabel];
        
        if (indexPath.row == 0) {
            UIView *upSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
            upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            [cell addSubview:upSpliteLine];
            
            leftLabel.text = @"单价";
            
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - left_label_width - general_padding, 0, left_label_width, general_cell_height)];
            rightLabel.backgroundColor = [UIColor clearColor];
            rightLabel.font = [UIFont systemFontOfSize:big_font_size];
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
            
            rightLabel.text = [[self getHdcDigest] specialOfferPriceString];
            
            [cell.contentView addSubview:rightLabel];
            
        }else if (indexPath.row == 1){
            
            //“数量”
            leftLabel.text = @"数量";
            
            //限购提示
            if (self.card.saleRule.singleMaxBuy > 0) {
                UILabel *countLabel = [[UILabel alloc] init];
                countLabel.text = [NSString stringWithFormat:@"每人限购%d张", self.card.saleRule.singleMaxBuy];
                CGRect frame = CGRectMake(40, 3, 80, general_cell_height);
                countLabel.frame = frame;
                countLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
                countLabel.font = [UIFont systemFontOfSize:smaller_font_size];
                [cell.contentView addSubview:countLabel];
            }
            float btn_increase_space = 20;
            //左边减号按钮
            leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(left_btn_x-btn_increase_space, price_height/2-btn_increase_space, price_width+2*btn_increase_space, price_height+2*btn_increase_space)];
            [leftBtn setImage:[UIImage imageNamed:@"minus_icon"] forState:UIControlStateNormal];
            [leftBtn setImage:[UIImage imageNamed:@"minus_icon"] forState:UIControlStateHighlighted];
            [leftBtn addTarget:self action:@selector(chooseNumOfCard:) forControlEvents:UIControlEventTouchUpInside];
            leftBtn.tag = 1;
            leftBtn.enabled = NO;
            [cell.contentView addSubview:leftBtn];
            //中间text
            hdcCount = [[UITextField alloc] initWithFrame:CGRectMake(left_btn_x + price_width + general_padding/2, price_height/2, price_width, price_height)];
            hdcCount.text = @"1";
            hdcCount.userInteractionEnabled = NO;
            hdcCount.textAlignment = NSTextAlignmentCenter;
            [hdcCount addStrokeBorderWidth:splite_line_height cornerRadius:2 color:[ColorUtils colorWithHexString:black_text_color]];
            [cell.contentView addSubview:hdcCount];
            //右边加号按钮
            
            rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(left_btn_x + 2*price_width + general_padding-btn_increase_space, price_height/2-btn_increase_space, price_width+2*btn_increase_space, price_height+2*btn_increase_space)];
            [rightBtn setImage:[UIImage imageNamed:@"plus_icon"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"plus_icon"] forState:UIControlStateHighlighted];
            [rightBtn addTarget:self action:@selector(chooseNumOfCard:) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.tag = 2;
            rightBtn.enabled = YES;
            [cell.contentView addSubview:rightBtn];
            
            BOOL btnEnabled = YES;
            if (self.payModel == pay_model_user_hdc) {
                btnEnabled = NO;
            }
            [rightBtn setEnabled:btnEnabled];
        }else if (indexPath.row == 2){
            if (self.hasRedEnvelopes) {
                leftLabel.text = @"使用红包";
                self.rightLab = [[UILabel alloc] init];
                self.rightLab.frame = CGRectMake(80, 0, 210, general_cell_height);
                if (self.selectRedEnvelope != nil) {
                    self.rightLab.text = [NSString stringWithFormat:@"%d元", self.selectRedEnvelope.amount];
                }else{
                    self.rightLab.text = @"请选择抵扣的红包";
                }
                self.rightLab.userInteractionEnabled = YES;
                self.rightLab.textAlignment = NSTextAlignmentRight;
                self.rightLab.font = [UIFont systemFontOfSize:default_font_size];
                self.rightLab.textColor = [ColorUtils colorWithHexString:red_color];
                [cell.contentView addSubview:self.rightLab];
                UIImageView *rightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abel_down_icon"]];
                rightImgView.frame = CGRectMake(290, (general_cell_height - 25)/2, 25, 25);
                [cell.contentView addSubview:rightImgView];
            }
        }
        else{
            leftLabel.text = @"应付金额";
            if (self.payModel == pay_model_hdc) {
                self.paymentAmount = [self getPaymentAmountWithRedEnvelope:self.card.specialOfferPrice];
            }else if (self.payModel == pay_model_user_hdc){
                self.paymentAmount = [self getPaymentAmountWithRedEnvelope:self.userHdc.specialOfferPrice];
            }
            
            totalPrice.text = [NSString stringWithFormat:@"￥%.0f", self.paymentAmount];
            if (self.paymentAmount > (int)self.paymentAmount) {
                totalPrice.text = [NSString stringWithFormat:@"￥%.2f", self.paymentAmount];
            }
        
            totalPrice.font = [UIFont systemFontOfSize:big_font_size];
            [cell addSubview:totalPrice];
            

        }
    }else if (indexPath.section == 2){  // 支付类型
//        [cell setClipsToBounds:YES];
//        [cell.contentView setClipsToBounds:YES];
        PaymentType *paymentType = paymentTypes[indexPath.row];
        
        // 渲染支付图标
        UIImageView *image;
        if ([paymentType isALIWEBPay]) {
            image = [[UIImageView alloc] initWithFrame:CGRectMake(0, (general_cell_height - zhifubao_icon_height)/2, zhifubao_icon_width, zhifubao_icon_height)];
        }else{
            image = [[UIImageView alloc] initWithFrame:CGRectMake(general_padding, (general_cell_height - zhifubao_app_icon_width)/2, zhifubao_app_icon_width, zhifubao_app_icon_width)];
        }
        image.image = [UIImage imageNamed:paymentType.paymentTypeIcon];
        [cell addSubview:image];

        // 渲染支付名称
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(general_padding+zhifubao_icon_width, 0, screen_width-zhifubao_icon_width, general_cell_height)];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.font = [UIFont systemFontOfSize:default_font_size];
        rightLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
        rightLabel.text = paymentType.paymentTypeName;
        [cell addSubview:rightLabel];
        
        // 选中状态
        UIImageView *selectImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sex_icon_select"]];
        float y = (general_cell_height - selectImgView.image.size.width)/2;
        selectImgView.frame = CGRectMake(select_icon_x, y, selectImgView.image.size.width, selectImgView.image.size.width);
        selectImgView.tag = 3;
        [cell.contentView addSubview:selectImgView];
        if ([self.paymentType.paymentTypeName isEqualToString:paymentType.paymentTypeName]) {
            selectImgView.hidden = NO;
        }else{
            selectImgView.hidden = YES;
        }
    }
    [self fillCellSpliteLine:cell indexPath:indexPath];
    return cell;
}


/**
 *  渲染cell的分隔线
 */
-(void) fillCellSpliteLine:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIView *downSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, hdc_digest_view_height - splite_line_height, screen_width, splite_line_height)];
        downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell addSubview:downSpliteLine];
    }else if (indexPath.section == 1){
        UIView *downSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(general_padding, general_cell_height - splite_line_height, screen_width, splite_line_height)];
        if (self.hasRedEnvelopes && indexPath.row == 2) {
            downSpliteLine.hidden = NO;
        }else if(indexPath.row == 2){
            downSpliteLine.hidden = YES;
        }
        if (indexPath.row == 3) {
            CGRect frame = downSpliteLine.frame;
            frame.origin.x = 0;
            frame.origin.y = general_cell_height - splite_line_height;
            downSpliteLine.frame = frame;
        }
        downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell.contentView addSubview:downSpliteLine];
        
    }else if (indexPath.section == 2){  // 支付类型的分隔线
        
        if (indexPath.row == 0){ // 第一个cell的上分隔线
            UIView *upSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
            upSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
            [cell.contentView addSubview:upSpliteLine];
        }
        
        UIView *downSpliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, general_cell_height-splite_line_height, screen_width, splite_line_height)];
        downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        if (indexPath.row == paymentTypes.count-1) { // 最后一个cell的下分隔线
            [cell.contentView addSubview:downSpliteLine];
        }else{  // 不是最后一个cell的下分隔线
            CGRect frame = downSpliteLine.frame;
            frame.origin.x = general_padding;
            downSpliteLine.frame = frame;
            [cell.contentView addSubview:downSpliteLine];
        }
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, general_cell_height)];
    if (section ==1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, pay_type_label_y, screen_width, general_cell_height/2)];
        label.textColor = [ColorUtils colorWithHexString:black_text_color];
        label.font = [UIFont systemFontOfSize:default_font_size];
        label.text = @"支付方式";
        [view addSubview:label];
        
    }
    return view;
}

- (float) getPaymentAmountWithRedEnvelope:(float)price{
    
    if (self.selectRedEnvelope != nil) {
        price = price-self.selectRedEnvelope.amount < [[AppStatus sharedInstance] minimumPaymentAmount ] ? [[AppStatus sharedInstance] minimumPaymentAmount ] : price-self.selectRedEnvelope.amount;
    }
    return price;
}

-(void)chooseNumOfCard:(UIButton *)btn{
    // 修改美发卡的数量
    int numOfCard = hdcCount.text.intValue;
    if (btn.tag == 1) {
        numOfCard = (numOfCard-1<1 ) ? 1 : (numOfCard-1) ;
    }else if (btn.tag == 2){
        
        if (self.selectRedEnvelope != nil && numOfCard+1 >1) {
            NSString *msg = change_hdc_card_count_error_message;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            
            [alert show];
            return;
        }
        numOfCard++;
    }
    hdcCount.text = [NSString stringWithFormat:@"%d",numOfCard];
    
    // 处理修改数量的按钮
    if (numOfCard == 1 && btn.tag == 1) {
        leftBtn.enabled = NO;
        rightBtn.enabled = YES;
        
    }else if (numOfCard == singleMaxBuy){
        leftBtn.enabled = YES;
        rightBtn.enabled = NO;
    }else{
        leftBtn.enabled = YES;
        rightBtn.enabled = YES;
    }
   
    // 重新算计总价
    int specialOfferPriceInt = (int)self.card.specialOfferPrice;
    if (self.card.specialOfferPrice > (float)specialOfferPriceInt) {
        totalPrice.text = [NSString stringWithFormat:@"￥%.2f", numOfCard*self.card.specialOfferPrice];
    }else{
        totalPrice.text = [NSString stringWithFormat:@"￥%d", numOfCard*specialOfferPriceInt];
    }
    [MobClick event:log_event_name_choose_hdc_count attributes:nil];
}

-(int)currentCardNum{
    int numOfCard = hdcCount.text.intValue;
    return numOfCard;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 || (indexPath.section == 1 && indexPath.row == 2)) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {  // 选择红包
        int numOfCard = hdcCount.text.intValue;
        if (numOfCard > 1) { // 美发卡数量大于一张时，不能选择红包，给用户提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:change_hdc_card_count_error_message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }else if(numOfCard == 1){  // 进入红包列表选择页面
            UserSelectRedEnvelopeController *urc = [[UserSelectRedEnvelopeController alloc] initWithSelectRedEnvelope:self.selectRedEnvelope hairDressingCardId:self.getHairDressingCardId];
            urc.redEnvelopes = self.redEnvelopes;
            [self.navigationController pushViewController:urc animated:YES];
        }
    }
    
    if (indexPath.section == 2) {  // 选择了支付类型
        self.paymentType = [[PayProcessor sharedInstance] getPaymentTypes][indexPath.row];
        [self renderPaymentType];
    }
}

-(int) getHairDressingCardId{
    if (self.payModel == pay_model_hdc) {
        return self.card.id;
    }else if (self.payModel == pay_model_user_hdc){
        return self.userHdc.hairDressingCardId;
    }
    return 0;
}

-(void) renderPaymentType{
    NSIndexPath *indexPath = nil;
    for (int i=0 ; i<[[PayProcessor sharedInstance] getPaymentTypes].count ; i++) {
        PaymentType *paymentType = [[PayProcessor sharedInstance] getPaymentTypes][i];
        indexPath = [NSIndexPath indexPathForRow:i inSection:2];
        UITableViewCell *cell = [self.wrapperTableView cellForRowAtIndexPath:indexPath];
        UIView *selectedImage = [cell viewWithTag:selected_payment_icon];
        if ([self.paymentType.paymentTypeName isEqualToString:paymentType.paymentTypeName]) {
            selectedImage.hidden = NO;
        }else{
            selectedImage.hidden = YES;
        }
    }

}

#pragma mark -----------立即支付---------
-(void)initPaymentBtn{
    CGRect frame = self.confirmBtn.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - general_padding;
    self.confirmBtn.frame = frame;
    [self.confirmBtn addStrokeBorderWidth:0 cornerRadius:2 color:nil];
    [self.confirmBtn setBackgroundImage:[ImageUtils createPureColorImage:self.confirmBtn.frame.size andColor:[ColorUtils colorWithHexString:red_default_color]] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[ImageUtils createPureColorImage:self.confirmBtn.frame.size andColor:[ColorUtils colorWithHexString:black_text_color]] forState:UIControlStateHighlighted];
}

- (IBAction)submitPayment:(id)sender {
    [SVProgressHUD showWithStatus:network_status_loading];
    if (self.payModel == pay_model_hdc) {
        [self submitHdcPayment:self.card.id];
        [MobClick event:log_event_name_submit_hdc_order
             attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.paymentType.paymentTypeName, @"支付方式", nil]];
    }else if(self.payModel == pay_model_user_hdc){
        [self submitUserHdcPayment];
        [MobClick event:log_event_name_submit_hdc
             attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.paymentType.paymentTypeName, @"支付方式", nil]];
    }else{
        [SVProgressHUD dismiss];
    }
}

//提交用户美发卡支付
-(void) submitUserHdcPayment{
    
    int redEnvelopeId = self.selectRedEnvelope != nil ? self.selectRedEnvelope.id:-1;
    AppStatus *as = [AppStatus sharedInstance];
    [HdcStore updateUserHdcOrder:^(UserHdc *order, NSError *error) {
        if (error == nil) {
            PayProcessor *payProcessor = [PayProcessor sharedInstance];
            [payProcessor setPayFrom:self.from];
            [payProcessor addPayingCard:self.userHdc];
            
            // 微信支付
            if ([self.paymentType isTenPay]) {
                WeiXinPayProcessor * wxpay = [WeiXinPayProcessor sharedInstance];
                wxpay.delegate = payProcessor;
                [wxpay doWeixinpay:[order getAlipayOutTradeTitle]
                        outTradeNo:[order getAlipayOutTradeNo]
                        totalPrice:[order getUserHdcPaymentTotalPrice]];
            }
            // 支付宝支付
            else{
                AlipayProcessor *ap = [AlipayProcessor sharedInstance];
                ap.delegate = payProcessor;
                AlixPayOrder *payOrder = [ap buildAlixPayOrderByUserHdc:self.userHdc];
                [ap doAlipay:payOrder paymentType:self.paymentType navigationController:self.navigationController];
            }
        }else{
            StylerException *exception = [[error userInfo] objectForKey:@"stylerException"];
            NSLog(@"更新订单出错: 错误status:%d, 信息:%@" , [exception status], [exception message]);
        }
    } userId:as.user.idStr.intValue hdcOrderItemId:self.userHdc.id redEnvelopeId:redEnvelopeId];
    
}

//提交美发卡支付
-(void) submitHdcPayment:(int)hairDressingCardId{
    
    AppStatus *as = [AppStatus sharedInstance];
    int redEnvelopeId = self.selectRedEnvelope != nil ? self.selectRedEnvelope.id:-1;
    [HdcStore createHdcOrder:^(HdcOrder *hdcOrder, NSError *error) {
        if (error == nil) {
            
            PayProcessor *payProcessor = [PayProcessor sharedInstance];
            [payProcessor setPayFrom:self.from];
            [payProcessor addHdcOrder:hdcOrder];
            
            // 微信支付
            if([self.paymentType isTenPay]){
                WeiXinPayProcessor * wxpay = [WeiXinPayProcessor sharedInstance];
                wxpay.delegate = payProcessor;
                [wxpay doWeixinpay:[hdcOrder getOutTradeTitle]
                        outTradeNo:[hdcOrder getOutTradeNo]
                        totalPrice:[hdcOrder getPaymentTotalAmount]];
            }
            // 支付宝支付
            else{
                AlipayProcessor *ap = [AlipayProcessor sharedInstance];
                ap.delegate = payProcessor;
                AlixPayOrder *payOrder = [ap buildAlixPayOrderByHdcOrder:hdcOrder];
                [ap doAlipay:payOrder paymentType:self.paymentType navigationController:self.navigationController];
            }
            
        }else{
            StylerException *exception = [[error userInfo] objectForKey:@"stylerException"];
            [SVProgressHUD showErrorWithStatus:exception.message duration:2.0];
        }
    } userId:as.user.idStr.intValue hairDressingCardId:hairDressingCardId organizationId:self.organization.id hdcCount:[self currentCardNum] redEnvelopeId:redEnvelopeId stylistId:self.stylistId];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}


-(NSString *)getPageName
{
    return page_name_buy_hdc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
