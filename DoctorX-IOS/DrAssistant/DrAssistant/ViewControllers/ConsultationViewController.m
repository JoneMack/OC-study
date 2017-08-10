//
//  ConsultationViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/13.
//  Copyright © 2015年 Doctor. All rights reserved.
//

/****** 会诊 *******/

#import "ConsultationViewController.h"
#import "AddConsultationViewControllerViewController.h"
#import "ChatViewController.h"
#import "SRRefreshView.h"
#import "UIScrollView+EmptyDataSet.h"
@interface ConsultationViewController ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *groupIDArr;
@property (strong, nonatomic) SRRefreshView *slimeView;
@end

@implementation ConsultationViewController
- (void)reloadChatGroup:(NSNotification *)notify
{
    [self requestChatGroups];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CREATHUIZHECHATGROUPRELOADDATA" object:nil];
}
- (void)requestChatGroups
{
    [_dataArr removeAllObjects];
    
    [self showWithStatus:@"请等待……"];
    NSString *userName = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    
    [dic setValue:userName forKey:@"user"];
    [dic setValue:@"0" forKey:@"type"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:GetChatGroups param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@"%@",reponeObject);
        [self dismissToast];
        NSMutableArray *tempArray = [reponeObject safeObjectForKey:@"data"];
        for (NSDictionary *dic in tempArray) {
            
            NSString *chatName = [dic safeObjectForKey:@"name"];
            NSRange range = [chatName rangeOfString:@"ZZDBDZKJYXGS"];
            if (range.length >0) {
                
                NSString * result = [chatName substringFromIndex:range.location];
                NSLog(@"%@",result);
                if ([result isEqualToString:@"ZZDBDZKJYXGS2"]) {
                    NSString *resString = [[chatName componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                    [_dataArr safeAddObject:resString];
                    [self.groupIDArr addObject:[dic safeObjectForKey:@"id"]];
                }
            }
            
        }
        [self.tableView reloadData];
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadChatGroup:) name:@"CREATHUIZHECHATGROUPRELOADDATA" object:nil];
    
    [self requestChatGroups];
    self.title = @"会诊";
    [self addRightBtnAction];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - tableView PlaceHold
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:PLACEHOLDERINSCROLL];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{
    AddConsultationViewControllerViewController *addHuiZhen = [AddConsultationViewControllerViewController simpleInstance];
    [self.navigationController pushViewController:addHuiZhen animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *CellIdentiferId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.dataArr safeObjectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:[NSString stringWithFormat:@"%@",[self.groupIDArr safeObjectAtIndex:indexPath.row]] isGroup:YES];
    chatController.friend_type = self.friend_IDType;
    chatController.title = [NSString stringWithFormat:@"%@",[self.dataArr safeObjectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:chatController animated:YES];
}
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (NSMutableArray *)groupIDArr
{
    if (_groupIDArr == nil) {
        _groupIDArr = [[NSMutableArray alloc]init];
    }
    return _groupIDArr;
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate

//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self requestChatGroups];
    [_slimeView endRefresh];
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

@end
