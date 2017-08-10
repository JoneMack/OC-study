//
//  MyEvaluationsController.m
//  styler
//
//  Created by wangwanggy820 on 14-4-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "MyEvaluationsController.h"
#import "MyEvaluationCell.h"
#import "EvaluationStore.h"
#import "Toast+UIView.h"
#import "StylerException.h"
#import "UserLoginController.h"
#import "PostEvaluationController.h"
#import "Evaluation.h"
#import "EvaluationPictureController.h"
#import "StylistProfileController.h"
#import "LoadingStatusView.h"
#import "UIViewController+Custom.h"
#import "StylistStore.h"

#define checkArrayMaxCount   1000
#define splite_line_origin_x 55
#define avatar_image_height  50
#define loading_status_view_height    40
BOOL bCheck[checkArrayMaxCount];

@interface MyEvaluationsController ()

@end

@implementation MyEvaluationsController
{
    int pageNo;
    int pageSize;
    BOOL hasMore;
    BOOL isLoading;
    int loadNum;//大于等于1时表示为页面已经有内容
    LoadingStatusView *loading;
}
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
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    for (int i = 0; i < checkArrayMaxCount; i++) {
        bCheck[i] = 0;
    }
    pageNo = 1;
    pageSize = 10;
    hasMore = YES;
    isLoading = NO;
    loadNum = 1;
    [self initEvaluationTableView];
    [self requestEvaluationList];
}

#pragma mark --- all View---
-(void)initView{
    //self.view.backgroundColor = [UIColor redColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestEvaluationList) name:notification_name_update_post_queue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestEvaluationList) name:notification_name_update_my_evaluations object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestEvaluationList) name:notification_name_user_login object:nil];
}

#pragma mark -- header --
-(void)initHeader
{
    self.header = [[HeaderView alloc]initWithTitle:page_name_my_evaluations navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

#pragma mark ---- 评价列表
-(void)initEvaluationTableView
{
    int height = self.view.frame.size.height - self.header.frame.size.height;
    self.evaluationsTableView.frame = CGRectMake(0, self.header.frame.size.height + splite_line_height, screen_width, height);
    self.evaluationsTableView.backgroundColor = [UIColor clearColor];
    self.evaluationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.evaluationsTableView registerClass:[MyEvaluationCell class] forCellReuseIdentifier:@"MyEvaluationCell"];
    self.evaluationsTableView.delegate = self;
    self.evaluationsTableView.dataSource = self;
    
    loading = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, general_cell_height)];
}

-(void)requestEvaluationList
{
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.isConnetInternet) {
        [loading updateStatus:network_request_fail animating:NO];
        return;
    }
    [loading updateStatus:@"正在加载，请稍等..." animating:YES];
    if (!self.evaluationsArray) {
        self.evaluationsArray = [[NSMutableArray alloc] init];
    }
    isLoading = YES;

    EvaluationStore *es = [EvaluationStore shareInstance];
    [es getUserEvaluations:^(Page *page, NSError *err) {
        if (!err) {
            isLoading = NO;
            if (page.totalCount <= pageNo*pageSize) {
                hasMore = NO;
                [loading updateStatus:network_status_no_more animating:NO];
            }
            [self.evaluationsArray addObjectsFromArray:page.items];
            [self.evaluationsTableView reloadData];
            pageNo++;
            loadNum++;
        }else{
            [loading updateStatus:network_unconnect_note animating:NO];
        }
    }pageNo:pageNo pageSize:pageSize refresh:NO];
}

#pragma mark -- dataSource -- -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.evaluationsArray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.evaluationsArray.count) {
        return general_cell_height;
    }
    float height = [MyEvaluationCell getCellHightFor:[self.evaluationsArray objectAtIndex:indexPath.row] fold:!bCheck[indexPath.row]];
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.evaluationsArray.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell addSubview:loading];
        return cell;
    }
    static NSString * evaluationCellIndentifier = @"MyEvaluationCell";
    MyEvaluationCell * cell = [tableView dequeueReusableCellWithIdentifier:evaluationCellIndentifier];
    Evaluation * evaluation = [self.evaluationsArray objectAtIndex:indexPath.row];
    
    [cell renderUI:evaluation fold:!bCheck[indexPath.row]];
    cell.delegate = self;
    [cell.gotoProfilePageBtn addTarget:self action:@selector(jumpToProfilePage:) forControlEvents:UIControlEventTouchUpInside];
    cell.gotoProfilePageBtn.tag = indexPath.row;
    return cell;
}

-(void)jumpToProfilePage:(UIButton *)sender
{
    Evaluation *evaluation = [self.evaluationsArray objectAtIndex:sender.tag];
    [[StylistStore sharedStore] getStylist:^(Stylist *stylist, NSError *err) {
        if (stylist != nil && stylist.id > 0) {
            StylistProfileController *stylistProfile = [[StylistProfileController alloc]initWithStylistId:evaluation.stylistEvaluation.stylistId];
            
            stylistProfile.stylist = evaluation.stylistEvaluation.stylist;
            [self.navigationController pushViewController:stylistProfile animated:YES];
            
            [MobClick event:log_event_name_goto_stylist_profile attributes:[NSDictionary dictionaryWithObjectsAndKeys:evaluation.stylistEvaluation.stylist.name, @"发型师名字",nil]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"该发型师已下架" duration:1.0];
        }
    } stylistId:evaluation.stylistEvaluation.stylistId refresh:NO];
    
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.evaluationsArray.count) {
        if (!hasMore||isLoading) {
            return NO;
        }
    }
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (hasMore && !isLoading) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
            [self requestEvaluationList];
        }
    }
}
#pragma mark --- delegate ----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.evaluationsArray.count) {
        [self requestEvaluationList];
        return;
    }
    bCheck[indexPath.row] = bCheck[indexPath.row]?NO:YES;
    [self.evaluationsTableView reloadData];
}

-(void)tapThumbImageWith:(id)myEvaluationCell andImageTag:(int)tag
{
    MyEvaluationCell *edc = myEvaluationCell;
    NSIndexPath *indexPath = [self.evaluationsTableView indexPathForCell:edc];
    EvaluationPictureController *ecp;
    
    Evaluation *evaluation = [self.evaluationsArray objectAtIndex:indexPath.row];
    if (evaluation.stylistEvaluation.evaluationPictures && evaluation.stylistEvaluation.evaluationPictures.count > 0) {
        ecp = [[EvaluationPictureController alloc]initWithResourceType:from_image evaluation:evaluation.stylistEvaluation];
    }else
    {
        ecp = [[EvaluationPictureController alloc]initWithResourceType:from_url evaluation:evaluation.stylistEvaluation];
    }
    [ecp jumpToPage:tag];
    [self.navigationController pushViewController:ecp animated:YES];
    
    [MobClick event:log_event_name_check_evluation_picture attributes:[NSDictionary dictionaryWithObjectsAndKeys:evaluation.stylistEvaluation.stylist.name, @"发型师名字",nil]];
}

-(NSString *)getPageName{
    return page_name_my_evaluations;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
