//
//  MyDoctorViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyDoctorViewController.h"
#import "MyDoctorCell.h"
#import "MyDoctorHeader.h"
#import "CommonCell.h"
#import "ZhuanJiaDetailController.h"
#import "MenZhenYuYueController.h"
#import "MyDoctorEntity.h"
#import "MyDoctorHandler.h"
#import "SearchViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SRRefreshView.h"
@interface MyDoctorViewController ()<MyDoctorHeaderDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,SRRefreshDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) SRRefreshView *slimeView;
@end

@implementation MyDoctorViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)requestDataForDataSuce
{
    [self showWithStatus:@"请等待.."];
    [MyDoctorHandler requestDoctorList:^(BaseEntity *object) {
        [self dismissToast];
        UserEntity *entty = (UserEntity *)object;
        if (entty.success) {
            
            self.dataArr = [entty.data mutableCopy];
            [self.tableView reloadData];
        }else{
            
        }
        
    } fail:^(id object) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.tabBarController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self hideLeftBtn];
    
    MyDoctorHeader *header = [MyDoctorHeader shareInstance];
//    header.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 180);
    header.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView addSubview:self.slimeView];
    [self requestDataForDataSuce];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:PLACEHOLDERINSCROLL];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 80;
}

#pragma mark - HeaderActionDelegate
- (void)MyDoctorHeaderAction:(UIButton *)btn
{
    switch (btn.tag) {
        case AddDoctorTag:
        {
            SearchViewController *sVC = [SearchViewController simpleInstance];
            sVC.searchType = SearchDoctor;
            sVC.isPatOrDoc = @"TIANJIAYiShengWeiHaoYou";
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];
            
            break;
        }
            
        case MyYuYueTag:
        {
            MenZhenYuYueController *menVC = [MenZhenYuYueController simpleInstance];
            menVC.dataArr = self.dataArr;
            [self.tabBarController.navigationController pushViewController:menVC animated:YES];
            
            break;
        }
            
        case FreeZiXunTag:
        {
            SearchViewController *sVC = [SearchViewController simpleInstance];
            sVC.isPatOrDoc = @"ICOMEFROMEFREEVIEWCONTROLLER";
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];
           
            break;
        }
        default:
            break;
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static  NSString  *CellIdentiferId = @"myDoctorCell";
    CommonCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (!cell) {
        cell=[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:CellIdentiferId
                                     delegate:nil
                                  inTableView:tableView withRightButtonTitles:@[]];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    if (entity.REAL_NAME.length == 0) {
        cell.nameLabel.text = @"－－";
    }
    else
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", entity.REAL_NAME];
    }
    
    if (entity.major.length == 0 || entity.POST.length == 0) {
        cell.contentLabel.text = @"暂无信息";
    }
    else
    {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@-%@",entity.major,entity.POST];
    }
    
    NSURL *url = [NSURL URLWithString:entity.thumb];
    [cell.userImageView sd_setImageWithURL:url placeholderImage:[UIImage placeholderAvater]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    ZhuanJiaDetailController *zhuanjia = [ZhuanJiaDetailController simpleInstance];
    zhuanjia.zhuanJiaInfo = entity;
    [self.tabBarController.navigationController pushViewController: zhuanjia animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
        NSString *loginName = [GlobalConst shareInstance].loginInfo.login_name;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:entity.LOGIN_NAME forKey:@"account"];
        [dic safeSetObject:loginName forKey:@"friend"];
        [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
        
        [[GRNetworkAgent sharedInstance] requestUrl:delete_user_friends_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
            //NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",reponeObject);
            //[self dismissToast];
            BaseEntity *baseEntity = [BaseEntity objectWithKeyValues:reponeObject];
            if (baseEntity.success) {
                
                EMError *error = nil;
                // 删除好友
                BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:entity.LOGIN_NAME removeFromRemote:YES error:&error];
                if (isSuccess && !error) {
                    [self.dataArr removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            
        } failure:^(GRBaseRequest *request, NSError *error) {

        } withTag:0];
        
        
    }
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
    [self requestDataForDataSuce];
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


- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
