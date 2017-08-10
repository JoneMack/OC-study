//
//  HealthStateViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "HealthStateViewController.h"
#import "HealthDataEntity.h"
#import "HealthStateCell.h"
#import "ShowBloodSugarDataCell.h"
#import "ShowOxygenDataCell.h"
#import "ShowCaseDataCell.h"
@interface HealthStateViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation HealthStateViewController

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
            
            if (info.TYPE == 0) {
                [arr safeAddObject: info];
            }
        }
        
        self.dataArr = [arr copy];
        [self.tableView reloadData];
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
    } withTag:0];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *CellIdentiferId = @"zhuanjiaCell";
        NSLog(@"%@",self.ClubInfo.ID);
    HealthDataEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    NSLog(@"ClubInfo:%@",self.ClubInfo.ID);
    if([self.ClubInfo.ID isEqualToString:@"1"]){
            HealthStateCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            if (cell == nil) {
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"HealthStateCell" owner:nil options:nil];
                cell = [arr lastObject];
            };
           CGRect rect = cell.frame;
        if (entity.XL||entity.SZY||entity.SSY) {
            cell.SZY.text = [NSString stringWithFormat:@"舒张压（高压）：%@ 毫米汞柱", entity.SZY];
            cell.SSY.text = [NSString stringWithFormat:@"收缩压（低压）：%@ 毫米汞柱", entity.SSY];
            cell.XL.text = [NSString stringWithFormat:@"心率 ：%@ 次/分钟", entity.XL];
            rect.size.height = 100;
        }else{
            rect.size.height = 0;
        }
        cell.frame = rect;
        return cell;
    }else if([self.ClubInfo.ID isEqualToString:@"2"]){
        ShowBloodSugarDataCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ShowBloodSugarDataCell" owner:nil options:nil];
            cell = [arr lastObject];
        };
        CGRect rect = cell.frame;
        if (entity.KFXT||entity.CHXT) {
            cell.dateLabel.text=entity.RECORD_TIME;
            cell.kfLabel.text=[NSString stringWithFormat:@"%@ 毫摩尔/升",entity.KFXT];
            cell.chLabel.text=[NSString stringWithFormat:@"%@ 毫摩尔/升",entity.CHXT];
            rect.size.height = 100;
        }else{
            rect.size.height = 0;
            cell.hidden=TRUE;
        }
        cell.frame = rect;
        return cell;
    }else if([self.ClubInfo.ID isEqualToString:@"3"]){
        ShowOxygenDataCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ShowOxygenDataCell" owner:nil options:nil];
            cell = [arr lastObject];
        };
         CGRect rect = cell.frame;
        if (entity.XYBHD) {
            cell.oxyDateLabel.text=entity.RECORD_TIME;
            cell.oxyDataLabel.text=[NSString stringWithFormat:@"%@ %@",entity.XYBHD,@"%"];
            rect.size.height = 100;
        }else{
            rect.size.height = 0;
            cell.hidden=TRUE;
        }
        cell.frame = rect;
        return cell;
    }else{
        ShowCaseDataCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ShowCaseDataCell" owner:nil options:nil];
            cell = [arr lastObject];
        };
        CGRect rect = cell.frame;
        if (entity.RECORD) {
            cell.dateCaseCell.text=entity.RECORD_TIME;
            cell.dataCaseCell.text=entity.RECORD;
            rect.size.height = 100;
        }else{
            rect.size.height = 0;
            cell.hidden=TRUE;
        }
        cell.frame = rect;
        return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
