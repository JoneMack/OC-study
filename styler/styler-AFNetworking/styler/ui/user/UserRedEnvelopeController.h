//
//  UserRedEnvelopeController.h
//  styler
//
//  Created by System Administrator on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentView.h"
#import "RedEnvelopeQuery.h"

@interface UserRedEnvelopeController : UIViewController<CustomSegmentViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) CustomSegmentView *redEnvelopeNavView;
@property (weak, nonatomic) IBOutlet UITableView *redEnvelopeTableView;
@property (strong, nonatomic) LoadingStatusView *lsv;

@property (nonatomic, strong) RedEnvelopeQuery *query;
@property (nonatomic, strong) NSMutableArray *redEnvelopes;

@end
