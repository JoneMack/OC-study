//
//  PatientDetailController.m
//  DrAssistant
//
//  Created by hi on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "PatientDetailController.h"
#import "PatientDetialHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "PatientDetailTableViewCell.h"
#import "ChatViewController.h"
#import "CaseDetailViewController.h"

@interface PatientDetailController ()<UITableViewDataSource,UITableViewDelegate,PatientDetialHeader>
{
    BOOL _isBasicInfo;
    NSString *_sendNameString;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PatientDetialHeader *header;

@property (nonatomic,strong) NSArray *leftLabArray;
@property (nonatomic,strong) NSArray *rightlabArray;
@property (nonatomic,strong) NSMutableArray *recordDataArray;

@end

@implementation PatientDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isBasicInfo = YES;
    _recordDataArray = [[NSMutableArray alloc]init];
    
    _header = [PatientDetialHeader patientDetialHeader];
    _header.delegate = self;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = _header;
    self.tableView.backgroundColor = [UIColor defaultBgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40.0f;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    _header.nameForFriend.text = _userInfoEntity.REAL_NAME;
    _sendNameString = _userInfoEntity.REAL_NAME;
    _header.phoneForFriend.text = _userInfoEntity.LOGIN_NAME;
    _header.pic_img.layer.masksToBounds = YES;
    _header.pic_img.layer.cornerRadius = 50;
    
    [self initSettingViewPlugins];
    [self initDataSle];
    
    [self getPatientRecordInfoByAFN];
}
- (void)initDataSle
{
    self.leftLabArray = [[NSArray alloc]initWithObjects:@"姓名",@"性别",@"生日",@"家庭地址",@"电话",@"身份证",@"籍贯",@"婚否", nil];
    
    NSString *male;
    if (_userInfoEntity.SEX) {
        male = @"男";
    }
    else
    {
        male = @"女";
    }
    
    NSString *marry;
    if ([_userInfoEntity.MARRIAGE isEqualToString:@"1"]) {
        marry = @"已婚";
    }
    if ([_userInfoEntity.MARRIAGE isEqualToString:@"0"]) {
        marry = @"未婚";
    }
    
    self.rightlabArray = [[NSArray alloc]initWithObjects:_userInfoEntity.REAL_NAME,male,_userInfoEntity.BIRTHDAY,_userInfoEntity.address,_userInfoEntity.PHONE,_userInfoEntity.ID_CARD_NO,_userInfoEntity.NATION,marry, nil];
    
}

- (void)initSettingViewPlugins
{
    [_header.pic_img sd_setImageWithURL:[NSURL URLWithString: _userInfoEntity.thumb] placeholderImage:[UIImage placeholderAvater]];
    
    [_header.basicInfo_btn addTarget:self action:@selector(jiBenXinXiClick) forControlEvents:UIControlEventTouchUpInside];
    
    _header.basicInfo_btn.backgroundColor = [UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1];
    [_header.basicInfo_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_header.bingLiInfo_btn addTarget:self action:@selector(bingLiXinXiClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)patientDetialHeaderclickAtbtn:(UIButton *)button
{
    if (button.tag == 1) {
        NSLog(@"在线联系");
        EMBuddy *buddy = [EMBuddy buddyWithUsername: self.userInfoEntity.LOGIN_NAME];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:buddy.username]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.username isGroup:NO];
        if (self.userInfoEntity.REAL_NAME.length == 0) {
            chatVC.title = self.userInfoEntity.PHONE;
        }else
        {
            chatVC.title = self.userInfoEntity.REAL_NAME;
        }
        chatVC.msg_type = doctor_to_patient;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    if (button.tag == 2) {
        NSLog(@"电话联系");
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_userInfoEntity.LOGIN_NAME];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

- (void)jiBenXinXiClick
{
    _isBasicInfo = YES;
    
    NSLog(@"基本信息");
    _header.basicInfo_btn.backgroundColor = [UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1];
    [_header.basicInfo_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _header.bingLiInfo_btn.backgroundColor = [UIColor whiteColor];
    [_header.bingLiInfo_btn setTitleColor:[UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
    

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40.0f;
    [self.tableView reloadData];
}

- (void)bingLiXinXiClick
{
    _isBasicInfo = NO;
    
    NSLog(@"病例信息");
    _header.bingLiInfo_btn.backgroundColor = [UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1];
    [_header.bingLiInfo_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _header.basicInfo_btn.backgroundColor = [UIColor whiteColor];
    [_header.basicInfo_btn setTitleColor:[UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
    

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 62.0f;
    
    [self.tableView reloadData];
}


- (void)getPatientRecordInfoByAFN
{
    [self showString:@"请稍等"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_userInfoEntity.LOGIN_NAME forKey:@"username"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    [[GRNetworkAgent sharedInstance] requestUrl:getMyRecord param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@"--%@",reponeObject);
        [self dismissToast];
        self.recordDataArray = [reponeObject safeObjectForKey:@"data"];
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isBasicInfo) {
        return self.leftLabArray.count;
    }
    else
    {
        return self.recordDataArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*        PatientDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    //
    //        if (!cell) {
    //            cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientDetailTableViewCell" owner:nil options:nil] firstObject];
    //        }
     */

     if (_isBasicInfo) {
         static NSString *cellIdentifier = @"Cell1";
         
         
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if (!cell) {
             cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         NSString *strNil = [self.rightlabArray safeObjectAtIndex:indexPath.row];
         if (strNil.length == 0) {
             strNil = @"暂无信息";
         }
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[self.leftLabArray safeObjectAtIndex:indexPath.row],strNil];
         
         return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Cell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *RECORD = [[self.recordDataArray safeObjectAtIndex:indexPath.row]safeObjectForKey:@"RECORD"];
        if (RECORD.length == 0) {
            RECORD = @"";
        }
        NSString *RECORD_TIME = [[self.recordDataArray safeObjectAtIndex:indexPath.row]safeObjectForKey:@"RECORD_TIME"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",RECORD];
        cell.detailTextLabel.text = RECORD_TIME;
        cell.imageView.image = [UIImage imageNamed:@"xiaoxizhongxin.png"];
        return cell;
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 此处：由于选择某行是在查看病例按钮Action里，_isBasicInfo已赋值为NO。
    
    if (_isBasicInfo == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CaseDetailViewController *caseDetailVC = [CaseDetailViewController simpleInstance];
        caseDetailVC.reciveDataDic = [self.recordDataArray safeObjectAtIndex:indexPath.row];
        caseDetailVC.reciveNameString = _sendNameString;
        caseDetailVC.fromPatientDetail = @"LAIZI_XIANGQINGBINGLIXINXI";
        [self.navigationController pushViewController:caseDetailVC animated:YES];
    }
    
}

@end
