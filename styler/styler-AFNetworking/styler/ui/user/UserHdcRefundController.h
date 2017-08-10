//
//  UserRefundController.h
//  styler
//
//  Created by wangwanggy820 on 14-7-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "UserHdc.h"
#import "HairDressingCard.h"
#import "Organization.h"
#import "HdcDigestView.h"

@interface UserHdcRefundController : UIViewController

@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) HdcDigestView *hdcDigestView;

@property (weak, nonatomic) IBOutlet UIView *refundNoteView;
@property (weak, nonatomic) IBOutlet UIView *noteUpSpliteLine;
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteContentLabel;
@property (weak, nonatomic) IBOutlet UIView *noteDownSpliteLine;


@property (weak, nonatomic) IBOutlet UILabel *refundPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *refundCtrView;
@property (weak, nonatomic) IBOutlet UIButton *confirmRefundBtn;

@property int cardId;
@property (nonatomic, copy)NSString *userHdcNum;
@property HairDressingCard *card;
@property UserHdc *userHdc;
@property Organization *organization;

- (IBAction)applyRefund:(id)sender;

@end
