//
//  YuYueRecordController.m
//  DrAssistant
//
//  Created by hi on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "YuYueRecordController.h"
#import "YuYueRecordCell.h"
#import "MyDoctorHandler.h"
@interface YuYueRecordController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *data_note_Arr;
@property (strong, nonatomic) NSMutableArray *data_date_Arr;
@end

@implementation YuYueRecordController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    [self startRequest];
}
- (void)startRequest
{
    NSString *UserName = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:UserName forKey:@"account"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:GetMyBespoke param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@"--%@",reponeObject);
        self.dataArr = [reponeObject objectForKey:@"data"];
        NSLog(@"%@",self.dataArr);
        
//        for (NSDictionary *dic in self.dataArr) {
//            [self.data_note_Arr safeAddObject:[dic objectForKey:@"note"]];
//            [self.data_date_Arr safeAddObject:[dic objectForKey:@"time"]];
//        }
        
        
        [self.tableView reloadData];
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *CellIdentiferId = @"myDoctorCell";
    YuYueRecordCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"YuYueRecordCell" owner:nil options:nil];
        cell = [nibs lastObject];
    };
    
    NSDictionary *dic = [self.dataArr safeObjectAtIndex: indexPath.row];
    NSString *major = [dic safeObjectForKey:@"major"];
    if (![major length]) {
        major=@"";
    }
    NSString *POST = [dic objectForKey:@"post"];
    if (![POST length]) {
        POST=@"暂无信息";
    }
    NSString *doctorName = [dic objectForKey:@"doctorName"];
    if(![doctorName length]){
        doctorName = @"姓名：暂未填写";
    }
    cell.keMu.text = [NSString stringWithFormat:@"科目：%@",major];
    cell.name.text = doctorName;
    cell.yiYuan.text = [NSString stringWithFormat:@"职务：%@",POST];
    NSString *dateString = [dic objectForKey:@"time"];
    cell.date.text = [NSString stringWithFormat:@"预约时间  %@",dateString];
    cell.noteInfo.text = [dic objectForKey:@"note"];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)data_date_Arr
{
    if (_data_date_Arr == nil) {
        _data_date_Arr = [[NSMutableArray alloc] init];
    }
    return _data_date_Arr;
}

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (NSMutableArray *)data_note_Arr
{
    if (_data_note_Arr == nil) {
        _data_note_Arr = [[NSMutableArray alloc] init];
    }
    return _data_note_Arr;
}
- (NSMutableArray *)reciveDataArray
{
    if (_reciveDataArray == nil) {
        _reciveDataArray = [[NSMutableArray alloc]init];
    }
    
    return _reciveDataArray;
}

@end
