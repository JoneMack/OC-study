//
//  UserSelectRedEnvelopeController.h
//  styler
//
//  Created by 冯聪智 on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Custom.h"
#import "RedEnvelope.h"

@interface UserSelectRedEnvelopeController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myRedEnvelopeTableView;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) LoadingStatusView *lsv;
@property (strong, nonatomic) UIImageView *selectImgView;

@property (retain, nonatomic) RedEnvelope *selectRedEnvelope;

@property (nonatomic, strong) NSMutableArray *redEnvelopes;
//@property (nonatomic, strong) RedEnvelope *lockedRedEnvelope;
@property int hairDressingCardId;


-(id) initWithSelectRedEnvelope:( RedEnvelope *)selectRedEnvelope hairDressingCardId:(int)hairDressingCardId;
@end
