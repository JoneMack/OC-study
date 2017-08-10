//
//  UserRefundController.m
//  styler
//
//  Created by wangwanggy820 on 14-7-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserHdcRefundController.h"
#import "HdcDigestView.h"
#import "HdcStore.h"
#import "OrganizationStore.h"
#import "HdcDigest.h"
#import "UserHdcController.h"
#import "UIViewController+Custom.h"

#define remind_cell_height 50


@interface UserHdcRefundController ()

@end

@implementation UserHdcRefundController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initHeader];
    [self initNoteView];
    [self loadData];
    [self initRefundCtrView];
    [self setRightSwipeGesture];
}

-(void)initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.view.frame = UIScreen.mainScreen.bounds;
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_refund navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void)loadData{
    //加载卡片信息
    if (self.userHdcNum != nil) {
        [HdcStore getUserHdcByUserHdcNums:^(NSArray *userHdcs, NSError *error) {
            if (error == nil) {
                self.userHdc = userHdcs[0];
                
                //加载商户信息
                [OrganizationStore getOrganizationById:^(Organization *orginzation, NSError *err) {
                    if(orginzation != nil){
                        self.organization = orginzation;
                        [self initHdcDigestView];
                        [self renderRefundCtrView];
                    }
                } organizationId:self.userHdc.organizationId hasStylists:NO];
            }
        } userHdcNums:self.userHdcNum];
    }else{
        [HdcStore getHdc:^(HairDressingCard *card, NSError *error) {
            if (error == nil) {
                self.card = card;
                //加载商户信息
                [OrganizationStore getOrganizationById:^(Organization *orginzation, NSError *err) {
                    if(orginzation != nil){
                        self.organization = orginzation;
                        [self initHdcDigestView];
                        [self renderRefundCtrView];
                    }
                } organizationId:((NSNumber*)self.card.saleRule.organizationIds[0]).intValue hasStylists:NO];
            }else{
            }
        } cardId:self.cardId];
    }
}

-(void) initNoteView{
    self.noteTitleLabel.font = [UIFont systemFontOfSize:small_font_size];
    self.noteTitleLabel.textColor = [ColorUtils colorWithHexString:red_color];
    
    self.noteContentLabel.font = [UIFont systemFontOfSize:small_font_size];
    self.noteContentLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    
    self.noteUpSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.noteUpSpliteLine.frame = CGRectMake(0, 0, self.refundNoteView.frame.size.width, splite_line_height);
    
    self.noteDownSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    self.noteDownSpliteLine.frame = CGRectMake(0, self.refundNoteView.frame.size.height-splite_line_height, self.refundNoteView.frame.size.width, splite_line_height);
}

-(HdcDigest *) getHdcDigest{
    if (self.userHdc != nil) {
        return [[HdcDigest alloc] initWithUserHdc:self.userHdc organization:self.organization];
    }else{
        return [[HdcDigest alloc] initWithHdc:self.card organization:self.organization];
    }
}

-(void) initHdcDigestView{
    CGRect frame = CGRectMake(0, self.header.bottomY, self.view.frame.size.width, splite_line_height);
    UIView *upSpliteLineView = [[UIView alloc] initWithFrame:frame];
    upSpliteLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.view addSubview:upSpliteLineView];
    
    frame.origin.y = [upSpliteLineView bottomY];
    frame.size.height = hdc_digest_view_height;
    HdcDigestView *hdcDigestView = [[HdcDigestView alloc] initWithFrame:frame];
    [hdcDigestView render:[self getHdcDigest]];
    [self.view addSubview:hdcDigestView];
    
    frame.origin.y = [hdcDigestView bottomY];
    frame.size.height = splite_line_height;
    UIView *downSpliteLineView = [[UIView alloc] initWithFrame:frame];
    downSpliteLineView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.view addSubview:downSpliteLineView];
}

-(void) initRefundCtrView{
    CGRect frame = self.refundCtrView.frame;
    frame.origin.y = self.view.frame.size.height - remind_cell_height;
    self.refundCtrView.frame = frame;
    
    self.refundPriceLabel.textColor = [ColorUtils colorWithHexString:red_color];
    self.refundPriceLabel.font = [UIFont boldSystemFontOfSize:big_font_size];
    
    CALayer *layer  = self.confirmRefundBtn.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:3];
}

-(void)renderRefundCtrView{
    
    if (self.userHdc != nil && self.userHdc.orderItemStatus == user_card_status_paid) {
        self.refundPriceLabel.text = [self.userHdc getPaymentAmountTxt];
        self.confirmRefundBtn.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
        self.confirmRefundBtn.userInteractionEnabled = YES;
    }else if(self.userHdc != nil){
        self.refundPriceLabel.text = [self.userHdc getPaymentAmountTxt];
        self.confirmRefundBtn.backgroundColor = [ColorUtils colorWithHexString:gray_text_color];
        self.confirmRefundBtn.userInteractionEnabled = NO;
    }else{
        HdcDigest *hdc = [self getHdcDigest];
        self.refundPriceLabel.text = hdc.specialOfferPriceString;
        self.confirmRefundBtn.backgroundColor = [ColorUtils colorWithHexString:gray_text_color];
        self.confirmRefundBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)applyRefund:(id)sender {
    [SVProgressHUD showWithStatus:network_status_loading];
    if (self.userHdcNum != nil) {
        NSArray *hdcNums = [NSArray arrayWithObject:self.userHdcNum];
        [HdcStore updateUserHdcStatus:^(NSError *error) {
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:@"申请成功" duration:2.0];
                NSArray *viewControllers = self.navigationController.viewControllers;
                for (UIViewController *controller in viewControllers) {
                    if ([controller isKindOfClass:[UserHdcController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        [((UserHdcController *)controller).userHdcNavView selectIndex:3];
                    }
                }
            }else{
                StylerException *exception = [[error userInfo] objectForKey:@"stylerException"];
                [SVProgressHUD showErrorWithStatus:exception.message duration:2.0];
            }
        } userHdcNums:hdcNums hdcStatus:3];
    }
}

-(NSString *)getPageName{
    return page_name_refund;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
