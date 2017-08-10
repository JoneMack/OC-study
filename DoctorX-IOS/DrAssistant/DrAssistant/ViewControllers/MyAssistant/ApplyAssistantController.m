//
//  ApplyAssistantController.m
//  DrAssistant
//
//  Created by 刘湘 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ApplyAssistantController.h"
#import "AppleAssistantTableViewCell.h"
@interface ApplyAssistantController ()
@property(nonatomic,copy)NSString *indif;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ApplyAssistantController

- (void)viewDidLoad {
    [super viewDidLoad];
   _indif=@"AppleAssistantTableViewCell";
    UINib *nib = [UINib nibWithNibName:_indif bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:_indif];
    _tableView.tableFooterView=[[UIView alloc] init];
     //_tableView.frame=CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
//2015-09-28
//taller
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppleAssistantTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:_indif forIndexPath:indexPath];
    cell.baseLable.font=[UIFont fontWithName:@"Arial" size:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.baseLable.text=@"三级医院，主任医师及副主任医生可申请配备";// 51,121,189
        cell.baseBtn.tag=333;
        [cell.baseBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:121/255.0 blue:189/255.0 alpha:1] forState:UIControlStateNormal];
        cell.assTypeNameLab.text = @"专属助理";
        cell.imageAndAssTypView.backgroundColor = [UIColor colorWithRed:51/255.0 green:121/255.0 blue:189/255.0 alpha:1];
    }else if(indexPath.row==1){
        cell.baseLable.text=@"二级及以上医院，副主任及以上可申请配备"; //98,171,24
        cell.baseBtn.tag=222;
        [cell.baseBtn setTitleColor:[UIColor colorWithRed:98/255.0 green:171/255.0 blue:24/255.0 alpha:1] forState:UIControlStateNormal];
        cell.imageAndAssTypView.backgroundColor = [UIColor colorWithRed:98/255.0 green:171/255.0 blue:24/255.0 alpha:1];
        cell.assTypeNameLab.text = @"在线助理";
    }else if (indexPath.row==2){
        cell.baseLable.text=@"免费培训您选派的助理(可自下级医生、研究生、进修医生、实习生中选派)，并免费提供\"医生助理Pad端\"软件一套";
        cell.baseBtn.tag=111;// 230,92,40
        [cell.baseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cell.imageAndAssTypView.backgroundColor = [UIColor colorWithRed:230/255.0 green:92/255.0 blue:40/255.0 alpha:1];
        cell.assTypeNameLab.text = @"助理培训";
    }
    [cell.baseBtn addTarget:self action:@selector(addAssistant:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)addAssistant:(UIButton*)btn {
    int type=0;
    switch (btn.tag) {
        case 333:
            type=1;
            break;
        case 222:
            type=2;
            break;
        default:
            type=3;
            break;
    }
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:account forKey:@"username"];
    [dic safeSetObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[account]]];
    [[GRNetworkAgent sharedInstance] requestUrl:applyAssistant param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        
    } withTag:0];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

@end
