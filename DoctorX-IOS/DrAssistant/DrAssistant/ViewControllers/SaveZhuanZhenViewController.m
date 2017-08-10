//
//  SaveZhuanZhenViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "SaveZhuanZhenViewController.h"
#import "SaveZhuanZhenView.h"
#import "RequesPageForJieZhuan.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
@interface SaveZhuanZhenViewController ()<SaveZhuanZhenViewActionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isOne;
    NSString *_clickGetHosID;
    NSString *_clickGetDocID;
    NSString *_out_org_ID;
    UIControl *_control;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SaveZhuanZhenView *saveView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *dataArr_HospitalID;
@property (nonatomic,strong) NSMutableArray *dataArr_HospitalName;
@property (nonatomic,strong) NSMutableArray *dataArr_DoctorID;
@property (nonatomic,strong) NSMutableArray *dataArr_DoctorName;

@end

@implementation SaveZhuanZhenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self registerForKeyboardNotifications];
    isOne = NO;
    
    [self.dataArr removeAllObjects];
    [self registerLJWKeyboardHandler];
    [self addRightBtnAction];
    self.saveView = [SaveZhuanZhenView saveZhuanZhenView];
    self.saveView.delegate = self;
    [self.view addSubview:self.saveView];
    [self.saveView.Bg_controlView addTarget:self action:@selector(touchesScreen) forControlEvents:UIControlEventTouchUpInside];
    self.saveView.patientPhone_tf.keyboardType = UIKeyboardTypeNumberPad;
    // Do any additional setup after loading the view from its nib.
    
    _control = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _control.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _control.hidden = YES;
    [self.view addSubview:_control];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-290)/2,138, 290, 396) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_control addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - addRightNavBtn
- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"录入" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{/*
  {
  "IN_ORG": "河南省人民医院",
  "RECEIVE_USER": "于红淘",
  "SEND_USER": "",
  "RECEIVE_THUMB": "http://172.21.102.199:8080/doctorx/upload/2015/09/08/14/42c9a539-fa7f-4ed0-a3df-52d998b9bd32_mmexport1441692142073.jpg",
  "ID": 40,
  "SEX": 0,
  "PHONE": "患得患失",
  "MEDICAL_INTRODUCTION": "家校互動不",
  "OUT_ORG_ID": -1,
  "IN_ORG_ID": 3,
  "RECEIVE_USER_ID": 4,
  "RECEIVE_DEPT_ID": 0,
  "SEND_USER_ID": 948,
  "SEND_DEPT_ID": 0,
  "STATUS": 0,
  "type": 0
  }
  */
    if ([self.saveView.zhuanRuYiYuan_lab.text isEqualToString:@"转入医院"]) {
        [self showString:@"请填写完整"];
        return;
    }
    if ([self.saveView.zhuanRuYiSheng_lab.text isEqualToString:@"转入医生"]) {
        [self showString:@"请填写完整"];
        return;
    }
    if (self.saveView.patientName_tf.text.length == 0 || self.saveView.patientPhone_tf.text.length == 0 || self.saveView.patientDescribe_tf.text.length == 0) {
        [self showString:@"请填写完整"];
        return;
    }
    
    
    NSString *userID = [GlobalConst shareInstance].loginInfo.iD;
    
    if ([NSString stringWithFormat:@"%@",_out_org_ID].length == 0 || [NSString stringWithFormat:@"%@",_clickGetDocID].length == 0 || [NSString stringWithFormat:@"%@",userID].length == 0) {
        
        [self showString:@"加载异常，请返回重试"];
        return;
    }

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
//    [dic setObject:@"" forKey:@"ID"];
   [dic setObject:self.saveView.patientName_tf.text forKey:@"REAL_NAME"];
//    [dic setObject:@"" forKey:@"SEX"];
    
    [dic setObject:self.saveView.patientPhone_tf.text forKey:@"PHONE"];
    [dic setObject:self.saveView.patientDescribe_tf.text forKey:@"MEDICAL_INTRODUCTION"];
    [dic setObject:_out_org_ID forKey:@"OUT_ORG_ID"];
    [dic setObject:_out_org_ID forKey:@"IN_ORG_ID"];
    [dic setObject:_clickGetDocID forKey:@"RECEIVE_USER_ID"];
    [dic setObject:@"0" forKey:@"RECEIVE_DEPT_ID"];
    [dic setObject:userID forKey:@"SEND_USER_ID"];
    [dic setObject:@"0" forKey:@"SEND_DEPT_ID"];
    [dic setObject:@"1" forKey:@"STATUS"];
    
//    [dic setObject:@"" forKey:@"CREATE_DATE"];
//    [dic setObject:@"" forKey:@"reverse"];
//    [dic setObject:@"" forKey:@"type"];
    
    
    [RequesPageForJieZhuan saveZhuanJieZhenDataUpLoad:dic withSuccess:^(id response) {
        NSLog(@"%@",response);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADZHUANZHENDATA" object:nil];

        [self showString:@"录入完成"];
        self.saveView.patientName_tf.text = @"";
        self.saveView.patientPhone_tf.text = @"";
        self.saveView.patientDescribe_tf.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    } withErrorBlock:^(id response) {
        
    }];
    
    
}

- (void)recordZhuanZhenInfoAction:(UIButton *)sender
{
    switch (sender.tag) {
        case SearchHospitalBtnTag:
        {
            NSLog(@"@");
            isOne = YES;
            _control.hidden = NO;
            [self searchHospitalForJieZhuan];
        }
            break;
        case SearchDoctorBtnTag:
        {
            NSLog(@"@@");
            
            [self searchDoctorForJieZhuan];
        }
            break;
        default:
            break;
    }
}

- (void)searchHospitalForJieZhuan
{
    [self.dataArr removeAllObjects];
    [RequesPageForJieZhuan searchHospital:nil withSuccess:^(id response) {
        NSLog(@"%@",response);
        NSMutableArray *tempArray = [response objectForKey:@"data"];
        
        for (NSDictionary *dic in tempArray) {
            [self.dataArr_HospitalID safeAddObject:[dic objectForKey:@"ID"]];
            [self.dataArr safeAddObject:[dic objectForKey:@"ORG_NAME"]];
        }
        NSLog(@"%@",self.dataArr_HospitalID);
        [self.tableView reloadData];
    } withErrorBlock:^(id response) {
        
    }];
}
- (void)searchDoctorForJieZhuan
{
    if (_clickGetHosID == nil) {
        [Utils showString:@"请先选择医院"];
        return;
    }
    isOne = NO;
//    _control.hidden = NO;
    [self.dataArr removeAllObjects];
    [RequesPageForJieZhuan searchDoctor:_clickGetHosID withSuccess:^(id response) {
        NSLog(@"%@",response);
        NSMutableArray *tempArray = [response objectForKey:@"data"];
        if (tempArray.count == 0) {
            [Utils showString:@"此医院暂无更多医生"];
            _control.hidden = YES;
            [self.tableView reloadData];
            return ;
        }
        else
        {
            _control.hidden = NO;
            for (NSDictionary *dic in tempArray) {
                [self.dataArr_DoctorID safeAddObject:[dic objectForKey:@"ID"]];
                [self.dataArr safeAddObject:[dic objectForKey:@"REAL_NAME"]];
            }
            
            [self.tableView reloadData];
        }
        _out_org_ID = _clickGetHosID;
        _clickGetHosID = nil;
    } withErrorBlock:^(id response) {
        
    }];
}
/*
 
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.dataArr safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isOne) {
        _clickGetHosID = [self.dataArr_HospitalID safeObjectAtIndex:indexPath.row];
        NSLog(@"%@",_clickGetHosID);
        NSString *nameString = [self.dataArr safeObjectAtIndex:indexPath.row];
        NSLog(@"%@",nameString);
        self.saveView.zhuanRuYiYuan_lab.text = nameString;
        _control.hidden = YES;
    }
    else
    {
        NSString *nameString = [self.dataArr safeObjectAtIndex:indexPath.row];
        NSLog(@"%@",nameString);
        self.saveView.zhuanRuYiSheng_lab.text = nameString;
        _clickGetDocID = [self.dataArr_DoctorID safeObjectAtIndex:indexPath.row];
        NSLog(@"%@",_clickGetDocID);
        _clickGetHosID = nil;
        _control.hidden = YES;
    }
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
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (NSMutableArray *)dataArr_HospitalID
{
    if (!_dataArr_HospitalID) {
        _dataArr_HospitalID = [[NSMutableArray alloc]init];
    }
    return _dataArr_HospitalID;
}
- (NSMutableArray *)dataArr_HospitalName
{
    if (!_dataArr_HospitalName) {
        _dataArr_HospitalName = [[NSMutableArray alloc]init];
    }
    return _dataArr_HospitalName;
}

- (NSMutableArray *)dataArr_DoctorID
{
    if (!_dataArr_DoctorID) {
        _dataArr_DoctorID = [[NSMutableArray alloc]init];
    }
    return _dataArr_DoctorID;
}
- (NSMutableArray *)dataArr_DoctorName
{
    if (!_dataArr_DoctorName) {
        _dataArr_DoctorName = [[NSMutableArray alloc]init];
    }
    return _dataArr_DoctorName;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)touchesScreen
{
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _control.hidden = YES;
    [_control removeFromSuperview];
}

@end
