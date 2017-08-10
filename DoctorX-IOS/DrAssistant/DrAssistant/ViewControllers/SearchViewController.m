//
//  SearchViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/14.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//


/*
 
此类：
 1，医生加患者好友
 2，患者加医生好友
 3，患者筛选区域加医生好友
 
结构构成：
 三个数据请求，
 一个表代理
 一个PickerView代理
 三个选择区域按钮及触发事件
 免费咨询
 
说明：
 1，self.dataArr是表数据源
 2，self.allArray是Picker的数据源
 
注意：
 Picker 单列显示，略显复杂，后续优化；
 筛选完成，数据显示返回成功，但没有完全的data数据
 
 */
#import "SearchViewController.h"
#import "SearchHeader.h"
#import "SearchHandler.h"
#import "MyPatientsCell.h"
#import "EMAlertView.h"
#import "GroupInfoEntity.h"
#import "DcoZoneSelModel.h"
#import "ZhuanJiaDetailController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface SearchViewController ()<SearchHeaderActionDelegate, UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,QRCodeReaderDelegate>
{
    NSInteger index;
    BOOL isSelectSure;
    NSString *_buKeDian;
    NSNumber *_orgId;
    NSString *_selectId;
    NSNumber *_depId;
}

@property (nonatomic,strong) UIView *editPickerView;
@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSMutableArray *array2ID;
@property (nonatomic,strong) NSMutableArray *array2name;

@property (nonatomic,strong) NSMutableArray *array3ID;
@property (nonatomic,strong) NSMutableArray *array3PID;
@property (nonatomic,strong) NSMutableArray *array3name;
@property (nonatomic,strong) NSMutableArray *array3Obj;

@property (nonatomic,strong) NSMutableArray *array4ID;
@property (nonatomic,strong) NSMutableArray *array4PID;
@property (nonatomic,strong) NSMutableArray *array4name;
@property (nonatomic,strong) NSMutableArray *array4Obj;
@property (nonatomic,strong) NSMutableArray *array5ID;

@property (nonatomic,strong) NSMutableArray *allArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SearchHeader *header;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSMutableArray *groupName;
@property (nonatomic, strong) NSMutableArray *groupId;

@property (nonatomic,strong)NSDictionary *resultDic_QR;
@end

@implementation SearchViewController
#pragma -
#pragma mark - ViewDidLoad

- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zxing_title_scan_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        [self showString:@"当前设备不支持"];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    NSLog(@"1111--%@",result);
    /*
     1111--doctor:{"loginName":"15538108235","realName":"Mi8sp","userType":"1","userid":1054}
     */
    //NSDictionary *dictionary=[[NSDictionary alloc]init];
    
    self.resultDic_QR=[self dictionaryWithJsonString:result];
    
    //NSLog(@"%@",[self.resultDic_QR objectForKey:@"doctor"]);
    //NSLog(@"%@",[self.resultDic_QR objectForKey:@"loginName"]);
    
    NSString *nameUser = [NSString stringWithFormat:@"%@",[self.resultDic_QR objectForKey:@"realName"]];
    if (nameUser.length == 0) {
        nameUser = @"此人";
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"要加%@为好友，是否确定",nameUser] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidAppear:(BOOL)animated
{
//    self.dataArr = @[];
//    [self.tableView reloadData];
    _pickerView.hidden = NO;
    _editPickerView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"添加病人";
    
    //[self addRightBtnAction];
    
    index = -1;
    isSelectSure = NO;
    _buKeDian = @"";
    
    _allArray = [[NSMutableArray alloc]init];
    
    _array2ID = [[NSMutableArray alloc]initWithCapacity:10];
    _array2name = [[NSMutableArray alloc]initWithCapacity:10];
    _array3ID = [[NSMutableArray alloc]initWithCapacity:10];
    _array3PID = [[NSMutableArray alloc]initWithCapacity:10];
    _array3name = [[NSMutableArray alloc]initWithCapacity:10];
    _array3Obj = [[NSMutableArray alloc]initWithCapacity:10];
    _array4ID = [[NSMutableArray alloc]initWithCapacity:10];
    _array4PID = [[NSMutableArray alloc]initWithCapacity:10];
    _array4name = [[NSMutableArray alloc]initWithCapacity:10];
    _array4Obj = [[NSMutableArray alloc]initWithCapacity:10];
    _array5ID = [[NSMutableArray alloc]init];
    self.groupId = [[NSMutableArray alloc]initWithCapacity:10];
    self.groupName = [[NSMutableArray alloc]initWithCapacity:10];
//    NSLog(@"%@",self.reciveGroupArray);
    
    for (GroupInfoEntity *entoty in self.reciveGroupArray) {
        
        [self.groupName addObject:entoty.groupname];
        [self.groupId addObject:entoty.ID];
    }
    
    self.header = [SearchHeader searchHeader];
    self.header.delegate = self;
    self.header.searchBar.delegate = self;
    
    self.header.backgroundColor = [UIColor whiteColor];
    
    if (self.searchType == searchTongHang)
    {
        self.title = @"我的同行";
        self.header.listHeaderName.text = @"我的同行列表";
        [self startRequestAndPage];
        [self initPickViewAndEditingView];
    }
    if ([self.isPatOrDoc isEqualToString:@"AddPat"])
    {
        self.title = @"我的患者";
        self.header.listHeaderName.text = @"要添加的患者列表";
        [self.header.v_YiYuan removeFromSuperview];
        [self.header.v_QuYU removeFromSuperview];
        [self.header.v_KeShi removeFromSuperview];
        self.header.frame = CGRectMake(0, 0, self.header.frame.size.width, self.header.frame.size.height - self.header.v_YiYuan.frame.size.height-10);
    }
    if ([self.isPatOrDoc isEqualToString:@"ICOMEFROMEFREEVIEWCONTROLLER"]) {
        self.title = @"免费咨询";
        self.header.listHeaderName.text = @"";
        [self startRequestAndPage];
        [self initPickViewAndEditingView];
    }
    if ([self.isPatOrDoc isEqualToString:@"TIANJIAYiShengWeiHaoYou"]) {
        self.title = @"我的医生";
        [self startRequestAndPage];
        [self initPickViewAndEditingView];
    }
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor defaultBgColor];
    

    
}
#pragma mark - 初始化picker和picker的确定按钮View
- (void)initPickViewAndEditingView
{
    self.editPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT+172, kSCREEN_WIDTH, 44)];
    self.editPickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.editPickerView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(kSCREEN_WIDTH-80, 0, 80, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(completedEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.editPickerView addSubview:sureBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 80, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.editPickerView addSubview:cancelBtn];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT+216, kSCREEN_WIDTH, 216)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}
#pragma mark - 开始请求 区域PickerView 数据

- (void)startRequestAndPage
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:AllOrgs_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@"---%@",reponeObject);
        
        DcoZoneSelModel *model = [DcoZoneSelModel objectWithKeyValues:reponeObject];
        
        NSMutableArray *arrayData = [model.data mutableCopy];
        
        if (arrayData.count == 0) {
            [self showString:@"请返回重试"];
            return ;
        }
        
        for (NSDictionary *dic in arrayData) {
            
            NSString *ORG_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ORG_TYPE"]];
            if ([ORG_type isEqualToString:@"1"]) {
                
                [_array2ID addObject:[dic objectForKey:@"ID"]];
                [_array2name addObject:[dic objectForKey:@"ORG_NAME"]];
            }
            if ([ORG_type isEqualToString:@"2"]) {

                [_array2ID addObject:[dic objectForKey:@"ID"]];
                [_array2name addObject:[dic objectForKey:@"ORG_NAME"]];
            }
            if ([ORG_type isEqualToString:@"3"]) {
               
                [_array3ID addObject:[dic objectForKey:@"ID"]];
                [_array3PID addObject:[dic objectForKey:@"parent_id"]];
                [_array3name addObject:[dic objectForKey:@"ORG_NAME"]];
                [_array3Obj addObject:dic];
            }
            if ([ORG_type isEqualToString:@"4"]) {
                
                [_array4ID addObject:[dic objectForKey:@"ID"]];
                [_array4PID addObject:[dic objectForKey:@"parent_id"]];
                [_array4name addObject:[dic objectForKey:@"ORG_NAME"]];
                [_array4Obj addObject:dic];
                
            }

        }
        
        NSLog(@"%@",[reponeObject objectForKey:@"msg"]);
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        [self showString:@"取数据不成功"];
        
    } withTag:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma mark - 按钮的点击事件
- (void)cancelEditing
{
    [self pickerViewAnimationOut];
}
- (void)completedEditing
{
    isSelectSure = YES;
    [self completeEditingAnimations];
    if (index != -1) {
        return;
    }
    
    if (!_orgId) {
        return;
    }
    if (!_depId) {
        return;
    }
    
    NSString *UserId = [GlobalConst shareInstance].loginInfo.login_name;

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:UserId forKey:@"account"];
    [dic setObject:_orgId forKey:@"orgId"];
    [dic setObject:_depId forKey:@"keId"];
    [[GRNetworkAgent sharedInstance] requestUrl:getMyDoctors_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@"---%@",reponeObject);
        
        UserEntity *entity = [UserEntity objectWithKeyValues: reponeObject];
        self.dataArr = entity.data;
        [self.tableView reloadData];
        [self.pickerView reloadAllComponents];
        //[self showString:@"msg"];
        
        NSLog(@"%@",[reponeObject objectForKey:@"msg"]);
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        [self showString:@"取数据不成功"];
        
    } withTag:0];

    
}
- (void)searchHeaderclickAtbtn:(SearchHeaderTag )tag
{
    switch (tag) {
            
        case QuYuTag:
        {
            NSLog(@"区域");
            _buKeDian = @"";
            
            [self pickerViewAnimationIn];
            if (index!=-1) {
                self.header.quYu.text = [_array2name safeObjectAtIndex:index];
            }else{
            self.header.quYu.text = [_array2name safeObjectAtIndex:0];
            }
            [_allArray removeAllObjects];
            for (NSString *str in _array2name) {
                [_allArray safeAddObject:str];
            }
            self.header.yiYuan.text = @"医院";
            self.header.keShi.text = @"科室";
            [self.pickerView reloadAllComponents];
        
            break;
        }
        case YiYuanTag:
        {
            NSLog(@"医院");
            
//            if (index == -1) {
//                NSLog(@"请先选择区域");
//                [self showString:@"请先选择区域"];
//                return;
//            }
           
            if (index!=-1) {
                self.header.quYu.text = [_array2name safeObjectAtIndex:index];
            }else{
                index=0;
            }
            self.header.keShi.text = @"科室";
            [_allArray removeAllObjects];
            NSString *indexString = [NSString stringWithFormat:@"%@",[_array2ID objectAtIndex:index]];
            NSInteger dept=1;
            for (NSDictionary *dic in _array3Obj) {
                NSString *ORG_PID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"parent_id"]];
                if ([ORG_PID isEqualToString:indexString]) {
                    self.header.quYu.text = [_array2name safeObjectAtIndex:index];
                    if (dept) {
                      self.header.yiYuan.text = [dic objectForKey:@"ORG_NAME"];
                       _selectId=[dic objectForKey:@"ID"];
                       _orgId=[dic objectForKey:@"ID"];
                        dept=0;
                    }
                    
                    [_allArray addObject:[dic objectForKey:@"ORG_NAME"]];
                }
            }
            if (_allArray.count != 0) {
                if (isSelectSure == YES) {
                    [self pickerViewAnimationIn];
                }
               [self.pickerView reloadAllComponents];
            }
            else
            {
                [self showString:@"此地区暂无医院"];
                [_allArray removeAllObjects];
                _selectId = @"禁止显示";
                self.dataArr = @[];
                [self.tableView reloadData];
                break;
            }

            break;
        }
        case KeShiTag:
        {
            NSLog(@"科室");
            _buKeDian = @"selectAera";
            [_array5ID removeAllObjects];
            [_array4ID removeAllObjects];
            [_allArray removeAllObjects];
            NSInteger dept=1;
            for (NSDictionary *dic in _array4Obj) {
                NSString *ORG_PID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"parent_id"]];
                if ([[NSString stringWithFormat:@"%@",ORG_PID] isEqualToString:[NSString stringWithFormat:@"%@",_selectId]]) {
                    if (dept) {
                        _depId=[dic objectForKey:@"ID"];
                        self.header.keShi.text = [dic objectForKey:@"ORG_NAME"];
                        dept=0;
                    }
                    [_array5ID addObject:[dic objectForKey:@"ID"]];
                    [_allArray addObject:[dic objectForKey:@"ORG_NAME"]];
                }
            }
            
            if (_allArray.count != 0) {
                if (isSelectSure == YES) {
                    [self pickerViewAnimationIn];
                }
                [self.pickerView reloadAllComponents];
                index = -1;
            }
            else
            {
                [self showString:@"此医院暂无科室"];
                self.dataArr = @[];
                [self.tableView reloadData];
                break;
            }
            
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark UITableView 协议方法
//===============================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    MyPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [MyPatientsCell patientCell];
    }
    
    UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    
    NSString *name = entity.REAL_NAME;
    
    if ([Utils isBlankString: name]) {
        
        name = @"－－";
    }else{
        
        if (![Utils isBlankString: entity.major]) {
             name=  [name stringByAppendingFormat:@"(%@)", entity.major];
        }
    }
    
    NSString *desc = entity.docDesc;
    if ([Utils isBlankString: entity.docDesc]) {
        desc = entity.address;
    }
    
    cell.nameLabel.text = name;
    cell.detailLabel.text = desc;
    [cell.avtarImageView sd_setImageWithURL:[NSURL URLWithString: entity.thumb] placeholderImage:[UIImage placeholderAvater]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    NSString *CERT_STATUS = [GlobalConst shareInstance].loginInfo.cert_status;
    NSString *UserId = [GlobalConst shareInstance].loginInfo.iD;
    NSLog(@"CERT_STATUS：%@",CERT_STATUS);

    // 免费咨询，进医生详情
    if ([self.isPatOrDoc isEqualToString:@"ICOMEFROMEFREEVIEWCONTROLLER"]) {
        
        
        UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
        ZhuanJiaDetailController *zhuanjia = [ZhuanJiaDetailController simpleInstance];
        zhuanjia.zhuanJiaInfo = entity;
        [self.navigationController pushViewController: zhuanjia animated:YES];
        return;
    }

    // 从我的病人，添加患者
    if ([self.isPatOrDoc isEqualToString:@"AddPat"])//医生加好友：先分组，经同意，方可
    {
        
        if (![CERT_STATUS isEqualToString:@"2"]) {
            [self showString:@"您还没经过认证,不能加好友"];
            return;
        }
//        [self docAddPatBeFriend:UserId andFriendId:entity.ID];
        [self docAddPatBeFriend:UserId andFriendId:entity.ID andFriendLoginName:entity.LOGIN_NAME addType:@"0"];
    }
    
    // 添加我的同行
    if ([self.isPatOrDoc isEqualToString:@"ICOMEFROMEMyTongHangController"]) {
        
        if (![CERT_STATUS isEqualToString:@"2"]) {
            [self showString:@"您还没经过认证,不能加好友"];
            return;
        }
//        [self docAddPatBeFriend:UserId andFriendId:entity.ID];
        [self docAddPatBeFriend:UserId andFriendId:entity.ID andFriendLoginName:entity.LOGIN_NAME addType:@"2"];
    }
    
    if ([self.isPatOrDoc isEqualToString:@"TIANJIAYiShengWeiHaoYou"])
    {
    // 患者加医生 好友：确定以后即可
//        __weak typeof(self) weakSelf = self;   //  暂时未使用到，注释
        
        [EMAlertView showAlertWithTitle:@"提示"
                                message:@"是否加为好友"
                        completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [self showWithStatus:@"请等待.."];
                                NSLog(@"OK");
                                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
                                
//                                // 拿到当前用户的ID
//                                [dic safeSetObject:UserId forKey:@"userId"];
//                                
//                                // 当前用户的身份
//                                [dic safeSetObject:@"false" forKey:@"isDoct"];
//                                
//                                // 要加的好友的账号
//                                [dic safeSetObject:entity.ID forKey:@"friendId"];
//                                [dic safeSetObject:@"true" forKey:@"agreed"];
                                
                                [dic safeSetObject:UserId forKey:@"account"];
                                [dic safeSetObject:@"0" forKey:@"group_id"];
                                [dic safeSetObject:entity.ID forKey:@"friend_id"];
                                [dic safeSetObject:@"1" forKey:@"type"];
                                [dic safeSetObject:@"" forKey:@"friend_name"];
                                [dic safeSetObject:@"" forKey:@"username"];
                                [dic safeSetObject:@"" forKey:@"join_time"];
                                
                                [[GRNetworkAgent sharedInstance] requestUrl:addUserToGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
                                    
                                    [self dismissToast];
                                    
                                    NSString *success = [reponeObject objectForKeyedSubscript:@"success"];                                    success = [NSString stringWithFormat:@"%@",success];
                                    if (success) {
                                        [self showString:@"好友申请成功,请耐心等待对方同意"];
                                         [[EaseMob sharedInstance].chatManager addBuddy: entity.LOGIN_NAME message:@"我想加您为好友" error:nil];
                                    }
                                } failure:^(GRBaseRequest *request, NSError *error) {
                                    
                                    [self showString:@"加好友不成功"];
                                    
                                } withTag:0];
                            }
                        } cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}

#pragma mark - seearch 搜索方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *CERT_STATUS = [GlobalConst shareInstance].loginInfo.cert_status;
    
    if ([self.isPatOrDoc isEqualToString:@"ICOMEFROMEFREEVIEWCONTROLLER"])
    {
        [self searchWithNameByNmae:searchBar.text];
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        return;
    }
    if ([self.isPatOrDoc isEqualToString:@"AddPat"]) {
        if (![CERT_STATUS isEqualToString:@"2"]) {
            [self showString:@"您还没经过认证,不能加好友"];
            searchBar.text = @"";
            [searchBar resignFirstResponder];
            return;
        }
        [self searchWithName:searchBar.text type:2];
    }
    if (self.searchType == searchTongHang)
    {
        if (![CERT_STATUS isEqualToString:@"2"]) {
            [self showString:@"您还没经过认证,不能加好友"];
            searchBar.text = @"";
            [searchBar resignFirstResponder];
            return;
        }
        [self searchWithName:searchBar.text type:1];
    }
    if ([self.isPatOrDoc isEqualToString:@"TIANJIAYiShengWeiHaoYou"]) {
        [self searchWithName:searchBar.text type:1];
    }
//    else
//    {
//        [self searchWithName:searchBar.text type:1];
//    }
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchWithNameByNmae:(NSString *)name
{
    if ([Utils isBlankString: name]) {
        [self showString:@"请输入账号"];
    }
    [self showWithStatus:@"请等待.."];
    [SearchHandler searchUserWithAccountByNmae:name success:^(BaseEntity *object) {
        [self dismissToast];
        if (object.success) {
            
            UserEntity *entity = (UserEntity *)object;
            self.dataArr = entity.data;
            [self.tableView reloadData];
            
            [self showString:entity.msg];
        }else{
            
        }
    } fail:^(id object) {
        [self showString:@"未查到"];
    }];
    
}

- (void)searchWithName:(NSString *)name type:(NSInteger)type
{
    if ([Utils isBlankString: name]) {
        [self showString:@"请输入账号"];
    }
    [self showWithStatus:@"请等待.."];
    [SearchHandler searchUserWithAccount:name type:type success:^(BaseEntity *object) {
        [self dismissToast];
        if (object.success) {
            
            UserEntity *entity = (UserEntity *)object;
            self.dataArr = entity.data;
            [self.tableView reloadData];
            
        }else{
            
        }
        
    } fail:^(id object) {
        [self showString:@"未查到"];
    }];
}

- (void)docAddPatBeFriend:(NSString *)userId andFriendId:(NSString *)friendId andFriendLoginName:(NSString *)loginname addType:(NSString*)type
{
    NSString *titleMessage;
    // 添加我的同行
    if ([self.isPatOrDoc isEqualToString:@"ICOMEFROMEMyTongHangController"]) {
        titleMessage = @"请为我的同行选择一个分组";
    }
    else
    {
        titleMessage = @"请为我的患者选择一个分组";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    int A = -1;
    for (NSString *groupName in self.groupName) {
        A++;
        [alert addAction:[UIAlertAction actionWithTitle:groupName
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    
//                                                    [self requestHandlerForAddFriend:[self.groupId objectAtIndex:A] andFriendId:friendId andUserName:userId];
                                                    [self requestHandlerForAddFriend:[self.groupId objectAtIndex:A] andFriendId:friendId andUserName:userId andfriendLoginName:loginname type:type];
                                                    
                                                }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                NSLog(@"取消");
                                            }]];
   
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)requestHandlerForAddFriend:(NSString *)groupId andFriendId:(NSString *)friendId andUserName:(NSString *)accound andfriendLoginName:(NSString *)loginName type:(NSString*)type
{
   // NSString *UserLoginName = [GlobalConst shareInstance].loginInfo.login_name;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    
    [dic safeSetObject:accound forKey:@"account"];
    [dic safeSetObject:groupId forKey:@"group_id"];
    [dic safeSetObject:friendId forKey:@"friend_id"];
    [dic safeSetObject:type forKey:@"type"];
    [dic safeSetObject:@"" forKey:@"friend_name"];
    [dic safeSetObject:@"" forKey:@"username"];
    [dic safeSetObject:@"" forKey:@"join_time"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:addUserToGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSLog(@"---%@",reponeObject);

        NSString *msg = [reponeObject objectForKey:@"msg"];
        NSString *success = [reponeObject objectForKeyedSubscript:@"success"];
        NSLog(@"%@",msg);
        success = [NSString stringWithFormat:@"%@",success];
        
        if ([success isEqualToString:@"1"]) {
             [[EaseMob sharedInstance].chatManager addBuddy:loginName message:@"我想加您为好友" error:nil];
//            [[EaseMob sharedInstance].chatManager addBuddy: entity.LOGIN_NAME message:@"我想加您为好友" error:nil];
            [self showString:@"好友申请已发送成功"];
        }
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        [self showString:@"申请发送不成功"];
        
    } withTag:0];
}

#pragma mark - Picker 协议方法
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_allArray count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return pickerView.frame.size.width;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"--------%@",_allArray);
    NSString *name = [_allArray safeObjectAtIndex:row];
    NSLog(@"name:%@",name);
    NSLog(@"%ld",row);
    NSLog(@"--------%@",_array4ID);
    
    if ([_buKeDian isEqualToString:@"selectAera"]) {
        _depId = [_array5ID safeObjectAtIndex:row];
        //_depId = [[_array4Obj safeObjectAtIndex:row] objectForKey:@"ID"];
        
        index = -1;
        self.header.keShi.text = name;
    }
    else
    {
        index = row;
    }
    NSLog(@"%@",_depId);
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_allArray safeObjectAtIndex:row];
}
#pragma mark - PickerView 的进出动画
- (void)pickerViewAnimationIn
{
    [UIView animateWithDuration:0.27 animations:^{
        
        self.editPickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-260, [UIScreen mainScreen].bounds.size.width, 44);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            
            self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216, [UIScreen mainScreen].bounds.size.width, 216);
        }];
    }];
}
- (void)pickerViewAnimationOut
{
    [UIView animateWithDuration:0.27 animations:^{
        self.pickerView.frame = CGRectMake(0, kSCREEN_HEIGHT+216, kSCREEN_WIDTH, 216);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.editPickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+172, [UIScreen mainScreen].bounds.size.width, 44);
        }];
    }];
}
- (void)completeEditingAnimations
{
    [UIView animateWithDuration:0.27 animations:^{
        self.pickerView.frame = CGRectMake(0, kSCREEN_HEIGHT+216, kSCREEN_WIDTH, 216);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.editPickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+172, [UIScreen mainScreen].bounds.size.width, 44);
        }];
    }];
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *user_type = [NSString stringWithFormat:@"%ld",[GlobalConst shareInstance].loginInfo.user_type];
    NSString *CERT_STATUS = [GlobalConst shareInstance].loginInfo.cert_status;

    NSString *UserId = [GlobalConst shareInstance].loginInfo.iD;
    NSString *fID = [NSString stringWithFormat:@"%@",[self.resultDic_QR objectForKey:@"userid"]];
    NSString *fLgNeme = [NSString stringWithFormat:@"%@",[self.resultDic_QR objectForKey:@"loginName"]];
    /*
     doctor:{"loginName":"15136269111","realName":"刘啦啦","userType":"2","userid":1060}
     private long userid;
     private String loginName;
     private String realName;
     private String userType; // 用户类型, 1 医生 2 患者
     */
    
    if (buttonIndex == 0) {
        NSLog(@"11");
        // 从我的病人，添加患者
        if ([self.isPatOrDoc isEqualToString:@"AddPat"])//医生加好友：先分组，经同意，方可
        {
            
            if (![CERT_STATUS isEqualToString:@"2"]) {
                [self showString:@"您还没经过认证,不能加好友"];
                return;
            }

            [self docAddPatBeFriend:UserId andFriendId:fID andFriendLoginName:fLgNeme addType:@"0"];
        }
        
        // 添加我的同行
        if ([self.isPatOrDoc isEqualToString:@"ICOMEFROMEMyTongHangController"]) {
            
            if (![CERT_STATUS isEqualToString:@"2"]) {
                [self showString:@"您还没经过认证,不能加好友"];
                return;
            }

            [self docAddPatBeFriend:UserId andFriendId:fID andFriendLoginName:fLgNeme addType:@"2"];
        }
        
        if ([self.isPatOrDoc isEqualToString:@"TIANJIAYiShengWeiHaoYou"])
        {
            // 患者加医生 好友：确定以后即可
            //        __weak typeof(self) weakSelf = self;   //  暂时未使用到，注释
            
            [EMAlertView showAlertWithTitle:@"提示"
                                    message:@"是否加为好友"
                            completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                                if (buttonIndex == 1) {
                                    [self showWithStatus:@"请等待.."];
                                    NSLog(@"OK");
                                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
                                    
                                    [dic safeSetObject:UserId forKey:@"account"];
                                    [dic safeSetObject:@"0" forKey:@"group_id"];
                                    [dic safeSetObject:fID forKey:@"friend_id"];
                                    [dic safeSetObject:@"1" forKey:@"type"];
                                    [dic safeSetObject:@"" forKey:@"friend_name"];
                                    [dic safeSetObject:@"" forKey:@"username"];
                                    [dic safeSetObject:@"" forKey:@"join_time"];
                                    
                                    [[GRNetworkAgent sharedInstance] requestUrl:addUserToGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
                                        
                                        [self dismissToast];
                                        
                                        NSString *success = [reponeObject objectForKeyedSubscript:@"success"];                                    success = [NSString stringWithFormat:@"%@",success];
                                        if (success) {
                                            [self showString:@"好友申请成功,请耐心等待对方同意"];
                                            [[EaseMob sharedInstance].chatManager addBuddy: fLgNeme message:@"我想加您为好友" error:nil];
                                        }
                                    } failure:^(GRBaseRequest *request, NSError *error) {
                                        
                                        [self showString:@"加好友不成功"];
                                        
                                    } withTag:0];
                                }
                            } cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定", nil];
        }
    }
    
}
#pragma mark - ViewWillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _editPickerView.hidden = YES;
    _pickerView.hidden = YES;
//    [_editPickerView removeFromSuperview];
//    [_pickerView removeFromSuperview];
    
}
/* Json - Dic*/
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

@end
