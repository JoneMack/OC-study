//
//  RecordViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/5.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "RecordViewController.h"
#import "HealthDataEntity.h"
#import "ShowCaseDataCell.h"
@interface RecordViewController ()
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation RecordViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Key_AddHeathDataSuccess object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView  = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshData) name:Key_AddHeathDataSuccess object:nil];
    [self getUserData];
}
- (void)RefreshData
{
    [self getUserData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getUserData
{
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    NSDictionary *signDic = [BaseEntity sign:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: signDic];
    [dic safeSetObject:userID forKey:@"user_id"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:ClubParamListURl param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        HealthDataEntity *entity = [HealthDataEntity objectWithKeyValues:reponeObject];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (HealthDataEntity *info in entity.data) {
            
            if (info.TYPE == 1) {
                [arr safeAddObject: info];
            }
        }
        
        self.dataArr = [arr copy];
        NSLog(@"dataArr:%ld",self.dataArr.count);
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
