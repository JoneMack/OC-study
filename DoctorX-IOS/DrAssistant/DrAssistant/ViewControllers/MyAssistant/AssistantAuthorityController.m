//
//  AssistantAuthorityController.m
//  DrAssistant
//
//  Created by 刘湘 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AssistantAuthorityController.h"
#import "AssistantAuthorityTableViewCell.h"
@interface AssistantAuthorityController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy)NSString *indif;
@property(nonatomic,copy)NSArray *dataArr;

@end

@implementation AssistantAuthorityController
@synthesize dataArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indif=@"AssistantAuthorityTableViewCell";
    UINib *nib = [UINib nibWithNibName:_indif bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:_indif];
    _tableView.tableFooterView=[[UIView alloc] init];
    [self getASLimitInfo];
}
- (void)getASLimitInfo
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[account]]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getAssistantLimits_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        dataArr = [reponeObject objectForKey:@"data"];
        [self.tableView reloadData];
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        
    } withTag:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssistantAuthorityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:_indif forIndexPath:indexPath];
    UISwitch* mySwitch = [[ UISwitch alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-84,10.0,79,27)];
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:14];
    if(indexPath.row==1){
        cell.textLabel.text=@"是否允许助理管理\"我的患者\"";
        mySwitch.tag=2;
        if ([[NSString stringWithFormat:@"%@",[dataArr objectForKey:@"vipDoctor_enable"]] isEqualToString:@"1"]) {
            [mySwitch setOn:YES animated:YES];
        }
    }else{
        cell.textLabel.text=@"是否允许助理管理\"我的同行\"";
        mySwitch.tag=1;
        if ([[NSString stringWithFormat:@"%@",[dataArr objectForKey:@"vipP_enable"]] isEqualToString:@"1"]) {
            [mySwitch setOn:YES animated:YES];
        }
    }
    [mySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:mySwitch];//添加到视图
    return cell;
}
- (void) switchValueChanged:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    if(control.tag==2){
        if ([control isOn]) {
            [self setASLimitInfo:9 :1];
        }else{
            [self setASLimitInfo:9 :0];
        }
    }else{
        if ([control isOn]) {
            [self setASLimitInfo:1 :9];
        }else{
            [self setASLimitInfo:0 :9];
        }
    }
}
- (void)setASLimitInfo:(NSInteger)vipPatientEnable :(NSInteger)vipDoctorEnable
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:[NSString stringWithFormat:@"%ld",vipPatientEnable] forKey:@"vipPatientEnable"];
    [dic safeSetObject:[NSString stringWithFormat:@"%ld",vipDoctorEnable]  forKey:@"vipDoctorEnable"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[account]]];
    [[GRNetworkAgent sharedInstance] requestUrl:updateLimits_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
