//
//  OrganizationDetailInfoController.h
//  styler
//
//  Created by wangwanggy820 on 14-4-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationStore.h"
#import "HairDressingCard.h"
#import "RewardActivityProcessor.h"
#import "RedEnvelopeActivityRemindView.h"
#import "RewardActivityResultView.h"
#import "ShareContent.h"

@interface OrganizationDetailInfoController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,ISSShareViewDelegate,ISSViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) UIButton *shareBtn;

@property int organizationId;
@property (strong, nonatomic) Organization *organization;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) HairDressingCard *hdc;
@property (strong, nonatomic) NSArray *hdcs;

@property (strong, nonatomic) RedEnvelopeActivityRemindView *remindRedViewBg;
@property (strong, nonatomic) RewardActivityResultView *receiveRedViewBg;


-(id)initWithOrganizationId:(int)organizationId;
-(ShareContent *) collectionShareContent;

@end
