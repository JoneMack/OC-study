//
//  MyCaseViewController.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyCaseViewController.h"
#import "CaseDetailViewController.h"
#import "HealthDataEntity.h"
#import "ShowCaseDataCell.h"

@interface MyCaseViewController ()
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation MyCaseViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Key_AddHeathDataSuccess object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    self.navigationItem.rightBarButtonItem = addBtn;
    // ContainerView
    self.tableView.frame=CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.tableView.tableFooterView  = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshData) name:Key_AddHeathDataSuccess object:nil];
    [self getUserData];
}
- (void)RefreshData
{
    [self getUserData];
}


- (void)addButtonAction
{
    CaseDetailViewController *caseVC = [CaseDetailViewController simpleInstance];
    [self.navigationController pushViewController:caseVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getUserData
{
    [self showWithStatus:@"请等待.."];
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    NSDictionary *signDic = [BaseEntity sign:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: signDic];
    [dic safeSetObject:userID forKey:@"user_id"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:ClubParamListURl param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        [self dismissToast];
        HealthDataEntity *entity = [HealthDataEntity objectWithKeyValues:reponeObject];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (HealthDataEntity *info in entity.data) {
            
            if (info.TYPE == 1) {
                [arr safeAddObject: info];
            }
        }
        self.dataArr = [arr copy];
        [self.tableView reloadData];
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
    } withTag:0];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *CellIdentiferId = @"zhuanjiaCell";
    HealthDataEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    ShowCaseDataCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ShowCaseDataCell" owner:nil options:nil];
        cell = [arr lastObject];
    };
    cell.dateCaseCell.text=entity.RECORD_TIME;
    cell.dataCaseCell.text=entity.RECORD;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CaseDetailViewController *caseDetailVC = [CaseDetailViewController simpleInstance];
    caseDetailVC.healthInfo = [self.dataArr safeObjectAtIndex: indexPath.row];
    caseDetailVC.reciveNameString = [GlobalConst shareInstance].loginInfo.real_name;
    caseDetailVC.fromPatientDetail = @"LAIZI_MyCaseViewController";
    caseDetailVC.title=@"病历信息";
    [self.navigationController pushViewController:caseDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
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
