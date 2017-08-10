//
//  ExpertDetailViewController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/23.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define expert_detail_messages_status_waiting_load 1
#define expert_detail_messages_status_loading      2
#define expert_detail_messages_status_load_over    3
#define expert_detail_messages_status_load_fail    4
#define index_messages_status_load_success 5

#define event_index_init_load              1
#define event_index_load_success           2
#define event_index_load_over              3
#define event_index_load_fail              4
#define event_index_pull_up                5

#import <UIKit/UIKit.h>
#import "Expert.h"
#import "ExpertMessage.h"
#import "ExpertMessageFrame.h"

@interface ExpertDetailViewController : UIViewController <UITableViewDataSource , UITableViewDelegate , UIAlertViewDelegate>

@property (nonatomic , strong) UITableView *bodyView;

@property (nonatomic , strong) UITableViewHeaderFooterView *headerView;


@property (nonatomic , strong) UITableViewHeaderFooterView *segmentView;
@property (nonatomic , strong) UIButton *infoListBtn;
@property (nonatomic , strong) UIButton *achievementBtn;
@property (nonatomic , strong) UIView *separatorLine;

@property (nonatomic , strong) Expert *expert;
@property (nonatomic , strong) NSMutableArray *expertMessages;
@property (nonatomic , strong) NSMutableArray *expertMessagesFrames;

-(id) init;
-(id) initWithExpert:(Expert *)expert;
-(void) transformEvent:(int)eventType;
@end
