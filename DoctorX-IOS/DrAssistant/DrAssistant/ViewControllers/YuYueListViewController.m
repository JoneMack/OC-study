//
//  YuYueListViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "YuYueListViewController.h"
#import "MenZhenYuYueCell.h"
#import "MyDoctorHandler.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
@interface YuYueListViewController ()<GoYuYueDelegate>
{
    NSString *getPickerDate;
    NSString *_doc_id;
    UIButton *_sureBtn;
    UIControl *_controlGround;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *netSourceIDArray;
@property (strong,nonatomic) NSMutableArray *netSourceTIMEArray;
@property (strong,nonatomic) NSMutableArray *netSourceObjArray;
@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) UIView *pickerTopView;
@property (strong,nonatomic) UILabel *noteLab;
@property (strong,nonatomic) UITextField *noteTD;
@property (strong,nonatomic) UIButton *gloBtn;
@end

@implementation YuYueListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registerLJWKeyboardHandler];
    if (self.dataArr.count == 0) {
        
        [self showWithStatus:@"请等待.."];
        [MyDoctorHandler requestDoctorList:^(BaseEntity *object) {
            [self dismissToast];
            UserEntity *entty = (UserEntity *)object;
            if (entty.success) {
                
                self.dataArr = [entty.data mutableCopy];
                [self.tableView reloadData];
            }else{
                
            }
            
        } fail:^(id object) {
            
        }];

    }
    
    [self startRequest];
    self.view.backgroundColor = [UIColor defaultBgColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    [self initDatePickerView];
    
}
- (void)startRequest
{
    NSString *UserName = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:UserName forKey:@"account"];
    
    [[GRNetworkAgent sharedInstance] requestUrl:GetMyBespoke param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        //NSLog(@"--%@",reponeObject);
        NSArray *arrayDate = [reponeObject objectForKey:@"data"];
       
        for (NSDictionary *dic in arrayDate) {
            [self.netSourceIDArray safeAddObject:[dic objectForKey:@"doctor_id"]];
            [self.netSourceTIMEArray safeAddObject:[dic objectForKey:@"time"]];
            [self.netSourceObjArray safeAddObject:dic];
        }

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
    MenZhenYuYueCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    cell.delegate=self;
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MenZhenYuYueCell" owner:nil options:nil];
        cell = [nibs lastObject];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserEntity *entity = [[UserEntity alloc]init];
    
//    if (self.dataArr == nil || self.dataArr.count == 0)
//    {
//        entity = self.dataEntity;
//    }
//    else
//    {
        entity = [self.dataArr safeObjectAtIndex: indexPath.row];
//    }
    
    NSString *yuYueShiJian = @"";
    NSString *doctor_id = @"";
    NSSet *set=[[NSSet alloc]init];
    for (NSDictionary *dic in self.netSourceObjArray) {
        doctor_id = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"doctor_id"]];
        if ([doctor_id isEqualToString:entity.ID]) {
            if (![set containsObject:entity.ID]) {
                yuYueShiJian = [dic safeObjectForKey:@"time"];
                set=[set setByAddingObject:entity.ID];
            }
        }
    }
    cell.yuYueBtn.tag = 100+indexPath.row;
    BOOL YouCanNot = [self compireDate:yuYueShiJian];
    if (YouCanNot) {
        [self yuYueHou:cell.yuYueBtn];
    }
    else// 可以预约
    {
        [self yuYueQian:cell.yuYueBtn];
        [cell.yuYueBtn addTarget:self action:@selector(yuYueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([entity.REAL_NAME length]) {
         cell.nameLAB.text = entity.REAL_NAME;
    }else{
        cell.nameLAB.text = entity.LOGIN_NAME;
    }
    
    if (entity.docDesc.length == 0) {
        cell.hospitalLab.text = @"医院：";
    }
    else
    {
        cell.hospitalLab.text = entity.docDesc;
    }
    if (entity.major.length == 0) {
        cell.keShiLab.text = @"专科：";
    }
    else
    {
        cell.keShiLab.text = entity.major;
    }
    
    return cell;
}

- (void)initDatePickerView
{
    _controlGround = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _controlGround.backgroundColor = [UIColor clearColor];
    [_controlGround addTarget:self action:@selector(clearScreenView) forControlEvents:UIControlEventTouchUpInside];
    
    self.pickerTopView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT+334, kSCREEN_WIDTH, 334)];
    _pickerTopView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_pickerTopView];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sureBtn.frame = CGRectMake(kSCREEN_WIDTH-80, 0, 80, 44);
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(commitDataSavebespok) forControlEvents:UIControlEventTouchUpInside];
    [_pickerTopView addSubview:_sureBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 80, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(commitCancle) forControlEvents:UIControlEventTouchUpInside];
    [_pickerTopView addSubview:cancelBtn];
    
    self.noteTD = [[UITextField alloc]initWithFrame:CGRectMake(20, 44, kSCREEN_WIDTH-40, 44)];
    _noteTD.borderStyle = UITextBorderStyleRoundedRect;
    _noteTD.placeholder = @"预约内容 注:此预约不代表在医院挂号";
    _noteTD.font = [UIFont systemFontOfSize:15.0];
    [_pickerTopView addSubview:_noteTD];

    self.noteLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 88, kSCREEN_WIDTH, 30)];
    //_noteLab.text = @"请选择时间";
    _noteLab.textAlignment = NSTextAlignmentCenter;
    [_pickerTopView addSubview:_noteLab];
    
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 118, kSCREEN_WIDTH, 216)];
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_pickerTopView addSubview:self.datePicker];
    
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.datePicker.locale = locale;
    //当前时间创建NSDate
    NSDate *localDate = [NSDate date];
    //在当前时间加上的时间：格里高利历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //设置时间
    [offsetComponents setYear:1];
    [offsetComponents setMonth:0];
    [offsetComponents setDay:0];
//    [offsetComponents setHour:20];
//    [offsetComponents setMinute:0];
//    [offsetComponents setSecond:0];
    //设置最大值时间
    NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:localDate options:0];
    //设置属性
    self.datePicker.minimumDate = [localDate initWithTimeIntervalSinceNow: 24*60*60*1 ];
    self.datePicker.maximumDate = maxDate;
    
    NSLog(@"----------%@",self.datePicker.minimumDate);
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker minimumDate];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    
    //打印显示日期时间
    NSLog(@"格式化显示时间：%@",dateString);
    _noteLab.text = dateString;

}

- (void)yuYueClick:(UIButton *)sender
{
    UserEntity *entity = [self.dataArr safeObjectAtIndex: sender.tag-100];
    NSLog(@"%@",entity.ID);
    _doc_id = entity.ID;
    self.noteTD.text = @"";
    [self.view addSubview:_controlGround];
    _controlGround.hidden = NO;
    [self.view bringSubviewToFront:self.pickerTopView];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.pickerTopView.frame = CGRectMake(0, kSCREEN_HEIGHT-438, kSCREEN_WIDTH, 334);
        
    }];
}
- (void)yuYueQian:(UIButton *)btn
{
    [btn setTitle:@"马上预约" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1]];
    btn.userInteractionEnabled = YES;
}
- (void)yuYueHou:(UIButton *)btn
{
    [btn setTitle:@"已预约" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.userInteractionEnabled = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)clearScreenView
{
    [self commitCancle];
}
- (void)commitCancle
{
    [self.noteTD endEditing:YES];
    self.noteTD.text = @"";
    //self.noteLab.text = @"请选择时间";
    self.datePicker.date = [NSDate date];
    _sureBtn.userInteractionEnabled = YES;
    _controlGround.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerTopView.frame = CGRectMake(0, kSCREEN_HEIGHT+334, kSCREEN_WIDTH, 334);
    }];
}
- (void)commitDataSavebespok
{
    NSLog(@"我点了一次");
    _sureBtn.userInteractionEnabled = NO;
    [self yuYueRequestion];
    self.datePicker.date = [NSDate date];
}
- (void)yuYueRequestion
{
    if([Utils isBlankString:self.noteTD.text]){
       [self showString:@"请填写预约内容"];
        _sureBtn.userInteractionEnabled = YES;
        return;
    }
    if([self.noteLab.text isEqualToString:@"请选择时间"]){
        [self showString:@"请填写预约时间"];
        _sureBtn.userInteractionEnabled = YES;
        return;
    }
    [self.netSourceTIMEArray removeAllObjects];
    [self.netSourceObjArray removeAllObjects];
    [self.netSourceIDArray removeAllObjects];
    
    NSString *UserID = [GlobalConst shareInstance].loginInfo.iD;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    [dic setObject:UserID forKey:@"u_id"];
    [dic setObject:self.noteLab.text forKey:@"time"];
    [dic setObject:self.noteTD.text forKey:@"note"];
    [dic setObject:_doc_id forKey:@"doctor_id"];
    [[GRNetworkAgent sharedInstance] requestUrl:SaveBespoke param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        [self startRequest];
//        [self.tableView reloadData];
        _sureBtn.userInteractionEnabled = YES;
        _controlGround.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerTopView.frame = CGRectMake(0, kSCREEN_HEIGHT+334, kSCREEN_WIDTH, 334);
        }];
    } failure:^(GRBaseRequest *request, NSError *error) {
        _sureBtn.userInteractionEnabled = YES;
        _controlGround.hidden = YES;
    } withTag:0];
    
}
// yes 表示不可选，no 表示可以预约
- (BOOL)compireDate:(NSString *)comeDate
{
    if ([comeDate isEqualToString:@""]) {
        return NO;
    }
    else
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *newDate=[dateFormatter dateFromString:comeDate];
        newDate = [self getNowDateFromatAnDate:newDate];
        [self tDate:newDate];
        
        NSDate*date=[NSDate date];
        date = [self getNowDateFromatAnDate:date];
        [self tDate:date];
        NSDate *r = [newDate earlierDate:date];
        NSLog(@"较早的时间：%@",r);
        
        BOOL rrrr = [r isEqualToDate:date];
        
        return rrrr;
    }
}
- (void)tDate:(NSDate *)anyDate

{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: anyDate];
    
    NSDate *localeDate = [anyDate  dateByAddingTimeInterval: interval];
    
    NSLog(@"localeDate:%@", localeDate);
    
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (NSMutableArray *)netSourceIDArray
{
    if (_netSourceIDArray == nil) {
        _netSourceIDArray = [[NSMutableArray alloc] init];
    }
    return _netSourceIDArray;
}

- (NSMutableArray *)netSourceTIMEArray
{
    if (_netSourceTIMEArray == nil) {
        _netSourceTIMEArray = [[NSMutableArray alloc] init];
    }
    return _netSourceTIMEArray;
}
- (NSMutableArray *)netSourceObjArray
{
    if (_netSourceObjArray == nil) {
        _netSourceObjArray = [[NSMutableArray alloc] init];
    }
    return _netSourceObjArray;
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    //添加你自己响应代码
    NSLog(@"dateChanged响应事件：%@",date);
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    
    //打印显示日期时间
    NSLog(@"格式化显示时间：%@",dateString);
    _noteLab.text = dateString;
    
    
}
-(void)goYuYueBtnAction:(UIButton *) btn{


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    [self.pickerTopView removeFromSuperview];
}

@end
