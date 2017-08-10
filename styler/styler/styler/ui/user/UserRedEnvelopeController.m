//
//  UserRedEnvelopeController.m
//  styler
//
//  Created by System Administrator on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserRedEnvelopeController.h"
#import "UIView+Custom.h"
#import "UserRedEnvelopeCell.h"
#import "UIViewController+Custom.h"
#import "RedEnvelope.h"
#import "RedEnvelopeStore.h"
#import "RedEnvelopeQuery.h"
#import "WebContainerController.h"

@interface UserRedEnvelopeController ()

@end

@implementation UserRedEnvelopeController

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
    
    self.query = [RedEnvelopeQuery new];
    self.query.pageNo = 1;
    self.query.pageSize = 100;
    self.query.userId = [AppStatus sharedInstance].user.idStr.intValue;
    self.query.statues = [[NSArray alloc] initWithObjects:@(red_envelope_status_bind) ,@(red_envelope_status_locked), nil];
    
    [self initView];
    [self initHeader];
    [self initUserRedEnvelopeNavView];
    [self initLoadingStatusView];
    [self initRedEnvelopTableView];
}

- (void) initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goback:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    [self setRightSwipeGestureAndAdaptive];
}

- (void)initHeader
{
    self.headerView = [[HeaderView alloc] initWithTitle:page_name_my_red_envelope navigationController:self.navigationController];
    [self.view addSubview:self.headerView];
}

- (void)initUserRedEnvelopeNavView
{
    NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"未使用",@"已使用",@"已过期", nil];
    self.redEnvelopeNavView = [[CustomSegmentView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height+splite_line_height, screen_width, general_cell_height)];
    [self.redEnvelopeNavView render:btnTitleArray currentIndex:0];
    self.redEnvelopeNavView.delegate = self;
    self.redEnvelopeNavView.backgroundColor = [ColorUtils colorWithHexString:white_text_color];
    
    UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, general_cell_height-splite_line_height, screen_width, splite_line_height)];
    downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.redEnvelopeNavView addSubview:downSpeliteLine];
    
    [self.view addSubview:self.redEnvelopeNavView];
}

-(void)selectSegment:(int)inx{
    self.redEnvelopes = nil;
    [self.redEnvelopeTableView reloadData];
    switch (inx) {
        case 0:
            self.query.statues = [[NSArray alloc] initWithObjects:@(red_envelope_status_bind), @(red_envelope_status_locked) ,nil];
            break;
        case 1:
            self.query.statues = [[NSArray alloc] initWithObjects:@(red_envelope_status_used), nil];
            break;
        case 2:
            self.query.statues = [[NSArray alloc] initWithObjects:@(red_envelope_status_expired), nil];
            break;
        default:
            break;
    }
    [self loadData];
}

-(void) initLoadingStatusView{
    self.lsv = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, loading_view_height)];
    [self.lsv updateStatus:network_status_loading animating:YES];
}

-(void) initRedEnvelopTableView{
    self.redEnvelopeTableView.frame = CGRectMake(0, self.redEnvelopeNavView.bottomY, self.view.frame.size.width, self.view.frame.size.height - self.redEnvelopeNavView.bottomY);
    self.redEnvelopeTableView.dataSource = self;
    self.redEnvelopeTableView.delegate = self;
    
    self.redEnvelopeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.redEnvelopeTableView registerClass:[UserRedEnvelopeCell class] forCellReuseIdentifier:NSStringFromClass([UserRedEnvelopeCell class])];
    
    [self loadData];
}

-(void) loadData{
    
    [RedEnvelopeStore getMyRedEnvelopes:^(Page *page, NSError *error) {
        if (page != nil) {
            self.redEnvelopes = [[NSMutableArray alloc] initWithArray:page.items];
            [self.redEnvelopeTableView reloadData];
        }else{
            StylerException *exception = [[error userInfo] objectForKey:@"stylerException"];
            [SVProgressHUD showErrorWithStatus:exception.message duration:2.0];
        }
    } redEnvelopeQuery:self.query hairDressingCardId:0];
}

#pragma mark -列表的dataSource
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.redEnvelopes == nil || self.redEnvelopes.count == 0){
        return 1;
    }
    return self.redEnvelopes.count;
}

#pragma mark -列表的代理
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return user_red_envelope_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.redEnvelopes == nil || self.redEnvelopes.count == 0) {
        UITableViewCell *cell = [UITableViewCell new];
        float y = (user_red_envelope_cell_height-loading_view_height)/2;
        CGRect frame = self.lsv.frame;
        frame.origin.y = y;
        self.lsv.frame = frame;
        [cell.contentView addSubview:self.lsv];
        
        if(self.redEnvelopes == nil){
        }else if (self.redEnvelopes.count == 0) {
            [self.lsv updateStatus:network_status_no_more animating:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UserRedEnvelopeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserRedEnvelopeCell class])];
    RedEnvelope *redEnvelope = self.redEnvelopes[indexPath.row];
    BOOL lastRow = (indexPath.row==(self.redEnvelopes.count-1)?YES:NO);
    [cell render:redEnvelope withSplite:YES last:lastRow showRedEnvelopeStatusFlag:YES];
    [cell.selectImgView setHidden:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];

    RedEnvelope *redEnvelope = self.redEnvelopes[indexPath.row];
    AppStatus *as = [AppStatus sharedInstance];
    NSString *url = [NSString stringWithFormat:@"%@/app/redEnvelopes/%d", as.webPageUrl,redEnvelope.id];
    WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:url title:@"红包使用规则"];
    [self.navigationController pushViewController:wcc animated:YES];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_my_red_envelope;
}

@end
