//
//  OrganizationController.m
//  styler
//
//  Created by wangwanggy820 on 14-6-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrganizationEvaluationController.h"
#import "EvaluationStore.h"

#define tableView_cell_height 60
@interface OrganizationEvaluationController ()

@end

@implementation OrganizationEvaluationController
{
    NSMutableArray *evaluations;
    LoadingStatusView *loadingView;
    BOOL isLoading;
    BOOL hasMore;
    int pageNo;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrganizationId:(int)organizationId
{
    if (self = [super init]) {
        self.organizationId = organizationId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initTableView];
    [self requestData];
}

-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_organization_evaluation navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) initTableView{
    CGRect frame = self.tableView.frame;
    frame.origin.y = self.header.frame.size.height;
    frame.size.height = self.view.frame.size.height - self.header.frame.size.height;
    self.tableView.frame = frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[OrganizationEvaluationCell class] forCellReuseIdentifier:@"OrganizationEvaluationCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    evaluations = [[NSMutableArray alloc] init];
    loadingView = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0, 0, screen_width, general_cell_height)];
    [loadingView updateStatus:network_status_loading animating:YES];
    isLoading = NO;
    hasMore = YES;
    pageNo = 1;
}

-(void)requestData{
    if (hasMore && !isLoading) {
        isLoading = YES;
        [[EvaluationStore shareInstance] getOrganizationEvaluations:^(Page *page, NSError *err) {
            isLoading = NO;
            if (!err) {
                if ([page isLastPage]) {
                    hasMore = NO;
                    [loadingView updateStatus:network_status_no_more animating:NO];
                }
                [evaluations addObjectsFromArray:page.items];
                pageNo++;
                [self.tableView reloadData];
            }else{
                [loadingView updateStatus:network_request_fail animating:NO];
            }
        } organizationId:self.organizationId pageNo:pageNo pageSize:20 refresh:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return evaluations.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == evaluations.count) {
        return general_cell_height;
    }
    return tableView_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == evaluations.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell addSubview:loadingView];
        return cell;
    }
    OrganizationEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganizationEvaluationCell"];
    [cell renderUIWithOrganizationEvaluation:evaluations[indexPath.row]];
    if (indexPath.row == evaluations.count - 1){
        cell.spliteLine.frame = CGRectMake(0, tableView_cell_height -splite_line_height, screen_width, splite_line_height);
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - navigation_height){
        if (hasMore && !isLoading) {
            [self requestData];
        }
    }
}

-(NSString *)getPageName{
    return page_name_organization_evaluation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
