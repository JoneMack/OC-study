//
//  SubscribeHistoryViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/10.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define subscribe_history_cell_height 40

#import "SubscribeHistoryViewController.h"
#import "UserStore.h"
#import "SubscribeHistoryCell.h"
#import "PayViewController.h"
#import "SystemStore.h"
#import "SystemPromptController.h"

@interface SubscribeHistoryViewController ()

@property (nonatomic , strong) UILabel *myPointsLabel;


@end

@implementation SubscribeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeaderView];
    [self initBodyView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:notification_name_update_user_info object:nil];
}

- (void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"订阅记录" navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
}

-(void) initBodyView
{
    self.bodyView = [UIView new];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY);
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    [self.view addSubview:self.bodyView];
    
    
    self.contentBlockView = [[UIImageView alloc] init];
    self.contentBlockView.frame = CGRectMake(15, 15, screen_width - 15*2, 80);
    [self.contentBlockView setImage:[UIImage imageNamed:@"bg_colorful_small"]];
    self.contentBlockView.layer.borderWidth = 0;
    [self.bodyView addSubview:self.contentBlockView];
    
    // 第一根线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:@"ffffff" alpha:0.5];
    self.separatorLine.frame = CGRectMake(22, 22,
                                          (self.contentBlockView.frame.size.width - 93 - 22*2)/2 ,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    // 订阅说明
    self.myPointsLabel = [[UILabel alloc] init];
    self.myPointsLabel.font = [UIFont systemFontOfSize:13 weight:3];
    self.myPointsLabel.textAlignment = NSTextAlignmentCenter;
    self.myPointsLabel.frame = CGRectMake(self.separatorLine.rightX, 12, 93, 20);
    [self.contentBlockView addSubview:self.myPointsLabel];
    
    // 第二根线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:@"ffffff" alpha:0.5];
    self.separatorLine.frame = CGRectMake(self.myPointsLabel.rightX, 22,
                                          (self.contentBlockView.frame.size.width - 93 - 22*2)/2 ,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    // 时间越长越省钱哦
    self.commonLabel = [[UILabel alloc] init];
    self.commonLabel.text = @"去充值";
    self.commonLabel.font = [UIFont systemFontOfSize:13 weight:3];
    self.commonLabel.textAlignment = NSTextAlignmentCenter;
    self.commonLabel.frame = CGRectMake(0, 40, self.contentBlockView.frame.size.width, 20);
    [self.contentBlockView addSubview:self.commonLabel];
    
    [self fillMyPoints];
    [self initTableView];
    
    [self setupEvents];
}

-(void) fillMyPoints
{
    self.myPointsLabel.text = [NSString stringWithFormat:@"%d 财币" , [[AppStatus sharedInstance].user getUserCurrentPoint]];
}

-(void) setupEvents
{
    self.contentBlockView.userInteractionEnabled = YES;
    UITapGestureRecognizer *contentBlockEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payForPoint)];
    [self.contentBlockView addGestureRecognizer:contentBlockEvent];
    
}

-(void) initTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(19, self.contentBlockView.bottomY + 20, screen_width -19*2 , 100 );
    
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.bodyView addSubview:self.tableView];
    
    self.subscribeExpertLogs = [NSMutableArray new];
    [self loadData];
}

-(void) loadData
{
    [[UserStore sharedStore] findSubscribeExpertLogs:^(Page *page , NSError *err) {
        if (err == nil) {
            
            if (page.items.count > 0) {
                [self.subscribeExpertLogs addObjectsFromArray:page.items];
                [self.tableView reloadData];
            }
        }
    } userId:[[AppStatus sharedInstance].user.id intValue] pageNo:1 pageSize:20];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect tableFrame = self.tableView.frame;
    float newHeight = subscribe_history_cell_height * self.subscribeExpertLogs.count;
    float maxHeight = screen_height - tableView.frame.origin.y - self.headerView.frame.size.height - 20;
    if (maxHeight < newHeight) {
        newHeight = maxHeight;
        self.tableView.bounces = YES;
    }else{
        self.tableView.bounces = NO;
    }
    tableFrame.size.height = newHeight;
    self.tableView.frame = tableFrame;
    return self.subscribeExpertLogs.count;
}

-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return subscribe_history_cell_height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subscribeHistoryCellId = @"subscribeHistoryCellId";
    SubscribeHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:subscribeHistoryCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribeHistoryCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (self.subscribeExpertLogs.count != indexPath.row+1) {
            UIView *separatorLine = [[UIView alloc] init];
            separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_common_color];
            separatorLine.frame = CGRectMake(0, subscribe_history_cell_height - splite_line_height,
                                             cell.frame.size.width,
                                             splite_line_height);
            [cell.contentView addSubview:separatorLine];
        }
        
        
        
    }
    SubscribeExpertLog *log = self.subscribeExpertLogs[indexPath.row];
    [cell renderData:log];
    return cell;
}



-(void) payForPoint
{
    [[SystemStore sharedInstance] getAppInfo:^(AppInfo *appInfo, NSError *err) {
        if ([appInfo.pay isEqualToString:@"false"]) {
            SystemPromptController *promptController = [[SystemPromptController alloc] init];
            promptController.appInfo = appInfo;
            [self.navigationController pushViewController:promptController animated:YES];
        }else{
            PayViewController *payController = [[PayViewController alloc] init];
            [self.navigationController pushViewController:payController animated:YES];
        }
    }];
}


-(void) paySuccess
{
    [self fillMyPoints];
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
