//
//  YuYueOrderNameViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "YuYueOrderNameViewController.h"
#import "NameDataViewCell.h"
#import "YuYueEntity.h"
@interface YuYueOrderNameViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YuYueOrderNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView = [UIView new];
    [self getData];
    
}
-(void)getData
{
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    NSDictionary *signDic = [BaseEntity sign:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: signDic];
    [dic safeSetObject:userID forKey:@"userId"];
    
    [Utils showStatusToast:@"请等待.."];
    [[GRNetworkAgent sharedInstance] requestUrl:getDoctorBespoke param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        [Utils dismissStatusToast];
        NSMutableArray *array = [reponeObject objectForKey:@"data"];
        if (array.count == 0) {
            [self showString:@"暂无预约"];
            return ;
        }
        self.dataNameArr = array;
        [self.tableView reloadData];
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
    } withTag:0];

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"self.dataNameArr.count:%ld",self.dataNameArr.count);
    return self.dataNameArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *CellIdentiferId = @"YuYueCell";
    NameDataViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"NameDataViewCell" owner:nil options:nil];
        cell = [arr lastObject];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     NSArray *entity = [self.dataNameArr safeObjectAtIndex: indexPath.row];
    cell.datelabel.text=[NSString stringWithFormat:@"%@",[entity objectForKey:@"time"]];
    if([[entity objectForKey:@"userName"] length]){
        cell.userLabel.text=[NSString stringWithFormat:@"%@",[entity objectForKey:@"userName"]];
    }else{
        cell.userLabel.text=[NSString stringWithFormat:@"%@",[entity objectForKey:@"userPhone"]];
    }
    cell.noteLabel.text=[NSString stringWithFormat:@"%@",[entity objectForKey:@"note"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
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
    if (_dataNameArr == nil) {
        _dataNameArr = [[NSMutableArray alloc] init];
    }
    return _dataNameArr;
}
@end
