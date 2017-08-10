//
//  UserSelectRedEnvelopeController.m
//  styler
//
//  Created by 冯聪智 on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserSelectRedEnvelopeController.h"
#import "UserRedEnvelopeCell.h"
#import "RedEnvelope.h"
#import "RedEnvelopeStore.h"
#import "ConfirmHdcOrderController.h"
#import "UIViewController+Custom.h"

@interface UserSelectRedEnvelopeController ()

@end

@implementation UserSelectRedEnvelopeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithSelectRedEnvelope:( RedEnvelope *)selectRedEnvelope hairDressingCardId:(int)hairDressingCardId{
    self = [super init];
    if (self) {
        self.selectRedEnvelope = selectRedEnvelope;
        self.hairDressingCardId = hairDressingCardId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initHeaderView];
    [self initLoadingStatusView];
    [self initMyRedEnvelopeTableView];
    [self setRightSwipeGesture];

}

- (void) initView
{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goback:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe ];
    [self setRightSwipeGestureAndAdaptive];
}

- (void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:page_name_user_select_red_envelope navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

-(void) initLoadingStatusView{
    self.lsv = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [self.lsv updateStatus:network_status_loading animating:YES];
}

- (void) initMyRedEnvelopeTableView
{
    self.myRedEnvelopeTableView.frame = CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.headerView.frame.size.height);
    
    self.myRedEnvelopeTableView.dataSource = self;
    self.myRedEnvelopeTableView.delegate = self;
    
    self.myRedEnvelopeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myRedEnvelopeTableView registerClass:[UserRedEnvelopeCell class] forCellReuseIdentifier:NSStringFromClass([UserRedEnvelopeCell class])];
    
}

#pragma mark -列表的dataSource
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.redEnvelopes == nil || self.redEnvelopes.count == 0) {
        return 1;
    }
    return self.redEnvelopes.count;
}

#pragma mark -列表的代理
- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return user_red_envelope_cell_height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.redEnvelopes == nil || self.redEnvelopes.count == 0) {
        UITableViewCell *cell = [UITableViewCell new];
        float y = (user_red_envelope_cell_height - loading_view_height)/2;
        CGRect frame = self.lsv.frame;
        frame.origin.y = y;
        self.lsv.frame = frame;
        [cell.contentView addSubview:self.lsv];
        
        if (self.redEnvelopes == nil) {
        }else if (self.redEnvelopes.count == 0){
            [self.lsv updateStatus:network_status_no_more animating:NO];
        }
        return cell;
    }
    
    UserRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserRedEnvelopeCell class])];
    RedEnvelope *redEnvelope = self.redEnvelopes[indexPath.row];
    BOOL lastRow = (indexPath.row == (self.redEnvelopes.count-1)?YES:NO);
    [cell render:redEnvelope withSplite:YES last:lastRow showRedEnvelopeStatusFlag:NO];
    
    if (self.selectRedEnvelope != nil && [redEnvelope.redEnvelopeNo isEqualToString:self.selectRedEnvelope.redEnvelopeNo]) {
        [cell.selectImgView setHidden:NO];
    }else{
        [cell.selectImgView setHidden:YES];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
    RedEnvelope *selectedRedEnvelope = self.redEnvelopes[indexPath.row];
    // 如果 self.seletedRedEnvelope 不为空，则将self的隐藏
    ConfirmHdcOrderController * chc = (ConfirmHdcOrderController *)[self getLastViewController];
    if (self.selectRedEnvelope != nil && [self.selectRedEnvelope.redEnvelopeNo isEqualToString:selectedRedEnvelope.redEnvelopeNo] ) {
        chc.selectRedEnvelope = nil;
    }else{
        [MobClick event:log_event_name_select_red_envelope];
        chc.selectRedEnvelope = selectedRedEnvelope;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_user_select_red_envelope;
}

@end
