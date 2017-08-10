//
//  AddConsultationViewControllerViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/13.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "AddConsultationViewControllerViewController.h"
#import "AddConsultationView.h"
#import "MyPatientHandler.h"
#import "MultistageTableView.h"
#import "GroupInfoEntity.h"
#import "FriendSectionHeader.h"
#import "MyPatientsCell.h"
#import "ConsulAccountListViewController.h"
#import "HeadView.h"

@interface AddConsultationViewControllerViewController ()<AddConsultationViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,HeadViewDelegate>
{
    NSString *_huanZheName;
}
@property (nonatomic,strong) AddConsultationView *addConsultationView;
@property (nonatomic,strong) NSMutableArray      *dataSource;
@property (nonatomic,strong) NSMutableArray      *accountDataArr;
@property (strong,nonatomic) UITableView         *tableView;
@property (strong,nonatomic) NSString            *discribeAddPhone;
@end

@implementation AddConsultationViewControllerViewController

- (void)popViewControllerAndUPUP:(NSNotification *)notify
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"COMECONSULTLISTTOROOTVIEW" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popViewControllerAndUPUP:) name:@"COMECONSULTLISTTOROOTVIEW" object:nil];
    
    [self addRightBtnAction];
    
    self.addConsultationView.backgroundColor = [UIColor defaultBgColor];
    self.addConsultationView = [AddConsultationView addConsultationView];
    self.addConsultationView.delegate = self;
    self.addConsultationView.discribe_tv.delegate = self;
    [self.view addSubview:self.addConsultationView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    CGRect rect = CGRectMake(0, 108, kSCREEN_WIDTH, kSCREEN_HEIGHT-108);
//    self.mtableView = [[MultistageTableView alloc] initWithFrame:rect];
//    self.mtableView.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-108);
//    self.mtableView.backgroundColor = [UIColor clearColor];
//    self.mtableView.hidden = YES;
//    self.mtableView.alpha = 0;
//    self.mtableView.delegate = self;
//    self.mtableView.dataSource = self;
//    self.mtableView.tableView.tableFooterView = [UIView new];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 113, kSCREEN_WIDTH, kSCREEN_HEIGHT-113) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.tableView.alpha = 0;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.tableFooterView = [UIView new];
    
    
    [self showString:@"请等待.."];
    [MyPatientHandler getAllGroupWithType:0 success:^(BaseEntity *object) {
        if (object.success) {
            GroupListEntity *entity = (GroupListEntity *)object;
            self.dataSource = [entity.data mutableCopy];
            [self.tableView reloadData];
            
        }else{
            
        }
        
    } fail:^(id object) {
    }];
    
    [self.view addSubview:self.tableView];
    
    _accountDataArr = [[NSMutableArray alloc]init];
    
    [self getAllGroupWithDocType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{
    [self.view endEditing:YES];
    
    NSLog(@"%@",_accountDataArr);
    if ([self.addConsultationView.patName_lab.text isEqualToString:@"点击选择会诊患者"]) {
        [self showString:@"请选择患者"];
        return;
    }
    if ([self.addConsultationView.discribe_tv.text isEqualToString:@"病情描述"]) {
        [self showString:@"请描述患者病情"];
        return;
    }
    
    ConsulAccountListViewController *accountList = [ConsulAccountListViewController simpleInstance];
    accountList.huanZheName = _huanZheName;
    accountList.discribeString = [NSString stringWithFormat:@"%@卍_%@",self.addConsultationView.discribe_tv.text,self.discribeAddPhone];
    accountList.reciveAccountArray = self.accountDataArr;
    [self.navigationController pushViewController:accountList animated:YES];
}

- (void)tapHopViewSelector:(UITapGestureRecognizer *)tapG
{
    NSLog(@"!!!");
//    UITapGestureRecognizer *tap = tapG;
//    UIView *iview = (UIView*)tap.view;

    [UIView animateWithDuration:0.3 animations:^{
        self.addConsultationView.arrows_image.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.tableView.hidden = NO;
        self.tableView.alpha = 1;
    }];
    
    self.addConsultationView.hopView.userInteractionEnabled = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source
#pragma mark - Table view data source
#pragma mark 加载数据

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GroupInfoEntity *friendGroup = self.dataSource[section];
    NSInteger count = friendGroup.isOpened ? friendGroup.friends.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identity=@"cell-identity";
    MyPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier: identity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPatientsCell" owner:nil options:nil] firstObject];
    }
    
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex: indexPath.section];
    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath.row];
    if ([friend.REAL_NAME length] != 0)
    {
        cell.nameLabel.text = friend.REAL_NAME;
    }
    else
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"患者(%@)",friend.PHONE];
    }
    //cell.accessoryType=3;
    if (friend.docDesc.length == 0) {
        cell.detailLabel.text = @"暂无信息";
    }
    else
    {
        cell.detailLabel.text = friend.docDesc;
    }
    
    [cell.avtarImageView sd_setImageWithURL:[NSURL URLWithString: friend.thumb] placeholderImage:[UIImage placeholderAvater]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    headView.contentView.backgroundColor = [UIColor whiteColor];
    headView.delegate = self;
    headView.friendGroup = self.dataSource[section];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex: indexPath.section];
    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath.row];
    if ([friend.REAL_NAME length])
    {
        self.addConsultationView.patName_lab.text = friend.REAL_NAME;
    }
    else
    {
        self.addConsultationView.patName_lab.text = [NSString stringWithFormat:@"患者(%@)",friend.PHONE];
    }
    _huanZheName = self.addConsultationView.patName_lab.text;
    self.discribeAddPhone = friend.LOGIN_NAME;
//    [_accountDataArr safeAddObject:friend];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.addConsultationView.arrows_image.transform = CGAffineTransformMakeRotation(-M_PI_2/180);;
        self.tableView.alpha = 0;
        self.tableView.hidden = YES;
    }];
    
    self.addConsultationView.hopView.userInteractionEnabled = YES;

}

- (void)clickHeadView
{
    [self.tableView reloadData];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if (textView.text.length == 0)
    {
        textView.text = @"病情描述";
        textView.textColor = [UIColor darkGrayColor];
    }
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)accountDataArr
{
    if (_accountDataArr == nil){
        _accountDataArr = [NSMutableArray array];
    }
    return _accountDataArr;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.addConsultationView.discribe_tv.text = @"病情描述";
    self.addConsultationView.discribe_tv.textColor = [UIColor darkGrayColor];
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan:withEvent:");
//    [self.view endEditing:YES];
//    [super touchesBegan:touches withEvent:event];
//}
- (void)getAllGroupWithDocType
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic safeSetObject:@"1" forKey:@"type"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getGroups_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        GroupListEntity *entity = [GroupListEntity objectWithKeyValues: reponeObject];
        NSMutableArray *tempArr;
        tempArr = [entity.data mutableCopy];
        
        for (GroupInfoEntity *entityGroup in tempArr) {
            for (UserEntity *friend in entityGroup.friends) {
                [_accountDataArr safeAddObject:friend];
            }
        }
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}

@end
