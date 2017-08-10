//
//  YuYueOrderDateViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "YuYueOrderDateViewController.h"
#import "YuYueEntity.h"
#import "NameDataViewCell.h"
@interface YuYueOrderDateViewController ()

@end

@implementation YuYueOrderDateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self getData];
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
        self.dataDateArr = array;
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
    //NSLog(@"return self.dataDateArr.count%ld",(unsigned long)self.dataDateArr.count);
    return self.dataDateArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *CellIdentiferId = @"YuYueCell2";
    NameDataViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"NameDataViewCell" owner:nil options:nil];
        cell = [arr lastObject];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *entity = [self.dataDateArr safeObjectAtIndex: indexPath.row];
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
    if (_dataDateArr == nil) {
        _dataDateArr= [[NSMutableArray alloc] init];
    }
    return _dataDateArr;
}
@end
