//
//  StylistEvaluationsController.m
//  styler
//
//  Created by wangwanggy820 on 14-3-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistEvaluationsController.h"
#import "PostEvaluationController.h"
#import "UserLoginController.h"
#import "EvaluationPictureController.h"
#import "EvaluationStore.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"
#import "StylistSummaryView.h"
#import "StylistIntroductionController.h"

#define evaluation_btn_origin_x     270
#define evaluation_btn_size_width   44
#define evaluation_btn_size_height  44
#define checkArrayMaxCount          1000

BOOL bCheck[checkArrayMaxCount];
@interface StylistEvaluationsController ()

@end

@implementation StylistEvaluationsController
{
    LoadingStatusView *loading;
    int pageNo;
    int pageSize;
    BOOL hasMore;
    BOOL isLoading;
    int totalCount;
    NSMutableString *authorizedInfoStr;
}
@synthesize evaluationArray;

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
    [self initStylistEvaluationTableView];
}

#pragma  mark ---- 初始化整个View ----
-(void)initView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveSenderedEvaluationForStylist:) name:notification_name_post_evaluation object:nil];
}

//接收消息推送  ---  自己已经发送评价后 -----
-(void)haveSenderedEvaluationForStylist:(NSNotification *)notification
{
    [self requestStylistEvaluation];
}

#pragma mark   初始化头部
-(void)initHeader{
    self.header = [[HeaderView alloc]initWithTitle:self.stylist.nickName navigationController:self.navigationController];
    
    [self.view addSubview:self.header];
}

#pragma mark ---  评价列表初始化
-(void)initStylistEvaluationTableView{
    float height = self.view.frame.size.height - self.header.frame.size.height;
    self.stylistEvaluationTableView.frame = CGRectMake(0, self.header.frame.size.height +splite_line_height, screen_width, height);
    self.stylistEvaluationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.stylistEvaluationTableView.delegate = self;
    self.stylistEvaluationTableView.dataSource = self;
    [self.stylistEvaluationTableView registerClass:[StylistEvaluationCell class] forCellReuseIdentifier:@"StylistEvaluationCell"];
    evaluationArray = [[NSMutableArray alloc] init];
    loading = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, general_cell_height)];
    pageNo = 1;
    pageSize = 10;
    isLoading = NO;
    hasMore = YES;
    [self requestStylistEvaluation];
}

-(void)requestStylistEvaluation{
    AppStatus *as = [AppStatus sharedInstance];
    if (!as.isConnetInternet) {
        [loading updateStatus:network_request_fail animating:NO];
        return;
    }
    [loading updateStatus:@"正在加载，请稍等..." animating:YES];
    isLoading = YES;
    EvaluationStore *es = [EvaluationStore shareInstance];
    [es getEvaluationList:^(Page *page, NSError *err){
        if (!err) {
            if (page.totalCount <= pageNo*pageSize) {
                hasMore = NO;
                [loading updateStatus:network_status_no_more animating:NO];
            }
            [evaluationArray addObjectsFromArray:page.items];
            [self.stylistEvaluationTableView reloadData];
            pageNo++;
            isLoading = NO;
            totalCount = page.totalCount;
        }
    } stylistId:self.stylist.id pageNo:pageNo pageSize:pageSize refresh:YES];
}

#pragma mark --------dataSource------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && [self.stylist.expertTotalCount getAverageScore] == 0){
        return 0;
    }
    if (section == 0) {
        return 2;
    }
    return evaluationArray.count + 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 && evaluationArray.count>0) {
        return general_padding;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row== 0) {
            if ([NSStringUtils isNotBlank:self.stylist.authorizedInfo]) {
                return general_cell_height;
            }else{
                return 0;
            }
        }
        return general_cell_height;
        
    }else{
        if (indexPath.row == evaluationArray.count) {
            return general_cell_height;
        }
        return [StylistEvaluationCell getCellHightFor:[evaluationArray objectAtIndex:indexPath.row] andBold:!bCheck[indexPath.row]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *downSpliteLine = [[UIView alloc]init];
    downSpliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            if ([NSStringUtils isNotBlank:self.stylist.authorizedInfo]) {
                UILabel *authorizedInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, 0, screen_width-general_padding, general_cell_height)];
                authorizedInfoStr = [[NSMutableString alloc] initWithString:self.stylist.authorizedInfo];
                [authorizedInfoStr replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, authorizedInfoStr.length)];
                authorizedInfoLab.text = [NSString stringWithFormat:@"简介：%@",authorizedInfoStr];
                authorizedInfoLab.font = [UIFont systemFontOfSize:default_font_size];
                downSpliteLine.frame = CGRectMake(general_padding, general_cell_height - splite_line_height, screen_width-general_padding, splite_line_height);
                [cell.contentView addSubview:downSpliteLine];
                [cell.contentView addSubview:authorizedInfoLab];
            }
        }else if (indexPath.row == 1){
            //各项评价信息
            UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(general_padding, 0, screen_width-general_padding, general_cell_height)];
            scoreLabel.backgroundColor = [UIColor clearColor];
            scoreLabel.attributedText = [self.stylist getStylistScore];;
            scoreLabel.textAlignment = NSTextAlignmentLeft;
            scoreLabel.font = [UIFont systemFontOfSize:default_font_size];
            [cell.contentView addSubview:scoreLabel];
            downSpliteLine.frame = CGRectMake(0, general_cell_height - splite_line_height, screen_width, splite_line_height);
            [cell.contentView addSubview:downSpliteLine];
        }
        return cell;
    }
    else{
        if (indexPath.row == evaluationArray.count) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell addSubview:loading];
            return cell;
        }
        
        StylistEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StylistEvaluationCell"];
        cell.delegate = self;
        [cell loadUIForDic:[evaluationArray objectAtIndex:indexPath.row] andBold:!bCheck[indexPath.row]];
        if (indexPath.row == 0) {
            [cell renderUpline:YES];
        }else{
            [cell renderUpline:NO];
        }
        return cell;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (hasMore && !isLoading) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
            [self requestStylistEvaluation];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == evaluationArray.count) {
            if (!hasMore||isLoading) {
                return NO;
            }
        }
        return YES;
    }
   else if (indexPath.section == 0 && indexPath.row == 1) {
        return NO;
    }
    return YES;
}
#pragma mark -----------delegate -----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
    if (indexPath.row == 0) {
        [MobClick event:log_event_name_view_stylist_introduction attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(self.stylist.id), @"发型师id", nil]];

       StylistIntroductionController *eic = [[StylistIntroductionController alloc] init];
        eic.stylistName = self.stylist.nickName;
        eic.introductionTxt = authorizedInfoStr;
        [self.navigationController pushViewController:eic animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == evaluationArray.count) {
            [self requestStylistEvaluation];
            return;
        }
        bCheck[indexPath.row] = !bCheck[indexPath.row];
        [tableView reloadData];
    }
}

#pragma mark --------- 图片点击 delegate---------
-(void)tapThumbImageWith:(id)stylistEvaluationCell andImageTag:(int)tag
{
    StylistEvaluationCell * edc = stylistEvaluationCell;
    NSIndexPath * indexPath = [self.stylistEvaluationTableView indexPathForCell:edc];
    if (indexPath.section == 1) {
        StylistEvaluation * evaluation = [evaluationArray objectAtIndex:indexPath.row];
        EvaluationPictureController *ecp = [[EvaluationPictureController alloc] initWithResourceType:from_url evaluation:evaluation];
        [ecp jumpToPage:tag];
        [self.navigationController pushViewController:ecp animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_stylist_evaluations;
}

@end
