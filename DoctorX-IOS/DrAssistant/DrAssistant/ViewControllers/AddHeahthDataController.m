//
//  AddHeahthDataController.m
//  DrAssistant
//
//  Created by hi on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AddHeahthDataController.h"
#import "UIViewController+LJWKeyboardHandlerHelper.h"
#import "AddHealthDataCell.h"
#import "HealthDataEntity.h"
#import "AddHealthInfoEntity.h"



typedef NS_ENUM(NSInteger, TextFieldTag) {
    
    TX_shouSuoYa,
    TX_shuZhangYa,
    TX_XinLV,
    TX_CanHouXueTang,
    TX_KongFuXueTang,
    TX_XueYangBaoHeDu,
};

@interface AddHeahthDataController ()
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *placehoders;
@property (nonatomic, strong) NSArray *txTags;
@property (nonatomic, strong) AddHealthInfoEntity *healthInfo;

@end

@implementation AddHeahthDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerLJWKeyboardHandler];
    
    self.title = @"手工录入";
    //NSLog(@"",self.healthInfo.i);
//    self.titleArr = @[@[@"收缩压:", @"舒张压:", @" 心 率: "],
//                      @[@"餐后血糖:", @"空腹血糖:"],
//                      @[@"血氧饱和度:"]];
//    self.placehoders = @[@[@" 毫米.汞柱", @" 毫米.汞柱", @" 次/分钟"],
//                         @[@" 毫摩尔/升", @" 毫摩尔/升"],
//                         @[@" 0-100之间"]];
//    self.txTags = @[@[@(TX_shouSuoYa), @(TX_shuZhangYa), @(TX_XinLV)],
//                    @[@(TX_CanHouXueTang), @(TX_KongFuXueTang)],
//                    @[@(TX_XueYangBaoHeDu)]];
    NSLog(@"myClub:%@",self.myClub.ID);
    if([self.myClub.ID isEqualToString:@"1"]){
        self.titleArr = @[@"收缩压:", @"舒张压:", @" 心 率: "];
        self.placehoders = @[@" 毫米.汞柱", @" 毫米.汞柱", @" 次/分钟"];
        self.txTags = @[@(TX_shouSuoYa), @(TX_shuZhangYa), @(TX_XinLV)];
    }else if([self.myClub.ID isEqualToString:@"2"]){
        self.titleArr =@[@"餐后血糖:", @"空腹血糖:"];
        self.placehoders = @[@" 毫摩尔/升", @" 毫摩尔/升"];
        self.txTags = @[@(TX_CanHouXueTang), @(TX_KongFuXueTang)];
    }else if ([self.myClub.ID isEqualToString:@"3"]){
        self.titleArr = @[@"血氧饱和度:"];
        self.placehoders = @[@" 0-100之间"];
        self.txTags =@[@(TX_XueYangBaoHeDu)];
    }else{
        
    }
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commitDataAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
//    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
//    footerLabel.text = @"提示：如无需要， 请置空处理";
//    footerLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.tableView.tableFooterView = footerLabel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitDataAction
{
    [self showString:@"请等待.."];
    self.healthInfo.CLUB_ID = self.myClub.ID;
    self.healthInfo.USER_ID = [GlobalConst shareInstance].loginInfo.iD;
    NSMutableDictionary *dic = self.healthInfo.keyValues;
    [dic addEntriesFromDictionary: [BaseEntity sign: nil]];
    [[GRNetworkAgent sharedInstance] requestUrl:uploadClubParam param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        BOOL success = [reponeObject boolValueForKey:@"success"];
        NSString *msg = [reponeObject stringValueForKey:@"msg"];
        if (success) {
            [self dismissToast];
            [[NSNotificationCenter defaultCenter] postNotificationName:Key_AddHeathDataSuccess object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (!msg) {
                msg = @"添加失败";
            }
            
            [self showString:msg];
        }
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"self.titleArr.count%lu",self.titleArr.count);
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static  NSString  *CellIdentiferId = @"zhuanjiaCell";
    AddHealthDataCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AddHealthDataCell" owner:nil options:nil];
        cell = [arr lastObject];
        cell.textFD.layer.cornerRadius = 15;
       [cell.textFD addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    };
    cell.LeftTitleLabel.text = [self.titleArr safeObjectAtIndex: indexPath.row];
    cell.textFD.placeholder = [self.placehoders safeObjectAtIndex: indexPath.row];
    cell.textFD.tag = [[self.txTags safeObjectAtIndex: indexPath.row] integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)textFieldValueChange:(UITextField *)textField
{
    NSString *text = textField.text;
    switch (textField.tag) {
        case TX_shouSuoYa:{
             self.healthInfo.SSY = text;
            break;
        }
        case TX_shuZhangYa:{
            
             self.healthInfo.SZY = text;
            break;
        }
        case TX_XinLV:{
              self.healthInfo.XL = text;
            break;
        }
        case TX_CanHouXueTang:{
             self.healthInfo.CHXT = text;
            break;
        }
        case TX_KongFuXueTang:{
             self.healthInfo.KFXT = text;
            break;
        }
        case TX_XueYangBaoHeDu:{
              self.healthInfo.XYBHD = text;
            break;
        }
            
        default:
            break;
    }
}

- (AddHealthInfoEntity *)healthInfo
{
    if (_healthInfo == nil) {
        _healthInfo = [[AddHealthInfoEntity alloc] init];
    }
    return _healthInfo;
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
