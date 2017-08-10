//
//  JieZhenViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "JieZhenViewController.h"
#import "RequesPageForJieZhuan.h"
#import "ZhuanZhenTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
@interface JieZhenViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation JieZhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"接诊记录";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.rowHeight = 120;
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    
    [RequesPageForJieZhuan startRequestWithStringWithDataArray:^(id response) {
        ZhuanJieZhenProContect *zhuanJieZhenInfo = [[ZhuanJieZhenProContect alloc]init];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        tempArray = [zhuanJieZhenInfo packageDataWithObject:response];
        
        for (ZhuanJieZhenEntity *entity in tempArray) {
            
            NSString *receiveUserID = [NSString stringWithFormat:@"%@",entity.RECEIVE_USER_ID];
            
            if ([receiveUserID isEqualToString:userID]) {
                [self.dataArr safeAddObject:entity];
            }
        }
        
        [self.tableView reloadData];
        
    } withErrorBlock:^(id json) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:PLACEHOLDERINSCROLL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *CellIdentiferId = @"myDoctorCell";
    ZhuanZhenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ZhuanZhenTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZhuanJieZhenEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    
    cell.name_lab.text = [NSString stringWithFormat:@"%@",entity.SEND_USER];
    cell.ZhuanRuYiYuan_lab.text = [NSString stringWithFormat:@"转入医院:%@",entity.OUT_ORG];
    cell.patientPhone_lab.text = [NSString stringWithFormat:@"患者电话:%@",entity.PHONE];
    cell.zhuaChuZhenDuan_lab.text = [NSString stringWithFormat:@"转出诊断:%@",entity.MEDICAL_INTRODUCTION];
    
    NSURL *url = [NSURL URLWithString:entity.SEND_THUMB];
    [cell.headPic_image sd_setImageWithURL:url placeholderImage:[UIImage placeholderAvater]];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
@end
