//
//  ClubViewController.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/21.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ClubViewController.h"
#import "MyPatientHandler.h"
#import "BATableView.h"
#import "GroupInfoEntity.h"
#import "ChineseString.h"
#import "ClubUserListCell.h"
#import "CustomDialogView.h"
#import "ChatViewController.h"
#import "HealthDataController.h"
#import "NSStringUtils.h"
@interface ClubViewController ()<BATableViewDelegate>

@property (nonatomic, strong) BATableView *contactTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;


@end
static NSString *clubUserListIndetifier = @"clubUserListCell";
@implementation ClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"俱乐部";
    self.tmpArray = [NSMutableArray new];
    self.onlyPhoneArray = [NSMutableArray new];
    self.friendNameDic = [NSMutableDictionary new];
    self.friendIdDic = [NSMutableDictionary new];
    self.friendThumbDic=[NSMutableDictionary new];
    NSLog(@">>>>>>>>>>>>>试着个么>>>>>>>>>>>%@",self.friendsArray);
    
    for (UserEntity *entity in self.friendsArray) {
        
        if ([NSStringUtils isNotBlank:entity.REAL_NAME]) {
            NSLog(@">>>>>>>>>>>>>>>>>>>>>%@",entity.REAL_NAME);
            [self.tmpArray addObject:entity.REAL_NAME];
            [self.friendNameDic setValue:entity.LOGIN_NAME forKey:entity.REAL_NAME];
            [self.friendIdDic setValue:entity.ID forKey:entity.REAL_NAME];
            [self.friendThumbDic setValue:entity.thumb forKey:entity.REAL_NAME];
        }else{
            [self.onlyPhoneArray addObject:entity.LOGIN_NAME];
            [self.friendIdDic setValue:entity.ID forKey:entity.LOGIN_NAME];
            [self.friendThumbDic setValue:entity.thumb forKey:entity.LOGIN_NAME];
            
        }
    }
    
    self.resultSortDict = [NSMutableDictionary new];
    self.sortUserArray = [ChineseString LetterSortArray:self.tmpArray];
    self.indexArray = [ChineseString IndexArray:self.tmpArray];
    //
    for (NSInteger i = 0; i < self.sortUserArray.count; i ++) {
        [self.resultSortDict setValue:self.sortUserArray[i] forKey:self.indexArray[i]];
    }
    self.indexArray=[[NSMutableArray alloc]initWithObjects:@"#", nil];
    self.indexArray= [self.indexArray arrayByAddingObjectsFromArray:[[self.resultSortDict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    
    [self.resultSortDict setObject:self.onlyPhoneArray forKey:@"#"];
    NSLog(@">>>>>>>>>>>>>试着个么>>>>>>>>>>>%@-------%@",self.indexArray,self.resultSortDict);
    //
    //    [self loadClubData];
    [self createTableView];
}

// 创建tableView
- (void) createTableView {
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 63, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
    self.contactTableView.delegate = self;
    self.contactTableView.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"ClubUserListCell" bundle:nil];
    [self.contactTableView.tableView registerNib:nib forCellReuseIdentifier:clubUserListIndetifier];
    [self.view addSubview:self.contactTableView];
}
#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    return @[
             @"#",@"A",@"B",@"C",@"D",@"E",
             @"F",@"G",@"H",@"I",@"J",
             @"K",@"L",@"M",@"N",@"O",
             @"P",@"Q",@"R",@"S",@"T",
             @"U",@"V",@"W",@"X",@"Y",
             @"Z"
             ];
}

-(void)loadClubData{
    [MyPatientHandler getClubDetailDataByDoctorId:[GlobalConst shareInstance].loginInfo.iD success:^(BaseEntity *object) {
        //GroupListEntity *entity = (GroupListEntity *)object;
        //        NSLog(@">>>>>>>>>>>>>>>>>>>这对么——————%@",entity.data);
        //GroupInfoEntity *infoEntity = entity.data[0];
        //        NSLog(@">>>>>>>>>>>>>>>>>>>这对么——————%@",infoEntity.friends);
        //        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        //        [outputFormat setToneType:ToneTypeWithoutTone];
        //        [outputFormat setVCharType:VCharTypeWithV];
        //        [outputFormat setCaseType:CaseTypeLowercase];
        //        [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@" " outputBlock:^(NSString *pinYin) {
        //            _outputTv.text=pinYin;
        //
        //        }];
        
    } fail:^(id object) {
        
    }];
    
}

- (NSString *)titleString:(NSInteger)section {
    return self.indexArray[section];
}
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexArray[section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.resultSortDict objectForKey:self.indexArray[section]]count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:clubUserListIndetifier forIndexPath:indexPath];
    if (self.indexArray.count > 0) {
        NSMutableArray *cellTtitleArray = [self.resultSortDict objectForKey:self.indexArray[indexPath.section]];
        NSString  *thumb=[self.friendThumbDic objectForKey:cellTtitleArray[indexPath.row]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage placeholderAvater]];;
        cell.friendNameLabel.text = cellTtitleArray[indexPath.row];
    }
   
    return cell;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@">>>>>>>当前点击的是>>>>>%ld>>>>>>%ld",indexPath.section,indexPath.row);
    NSMutableArray *cellTtitleArray = [self.resultSortDict objectForKey:self.indexArray[indexPath.section]];
    NSString *chatName = cellTtitleArray[indexPath.row];
    CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"提示" message:@"请选择您的操作？" buttonTitles:@"取消",@"聊天",@"健康数据", nil];
    [dialog showWithCompletion:^(NSInteger selectIndex) {
        if (selectIndex == 1) {
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[self.friendNameDic objectForKey:[NSString stringWithFormat:@"%@",cellTtitleArray[indexPath.row]]] isGroup:NO];
            chatVC.title = chatName;
            [self.navigationController pushViewController:chatVC animated:YES];
        }else if (selectIndex == 2){
            HealthDataController *hdvc = [[HealthDataController alloc] init];
            hdvc.friendId = [self.friendIdDic objectForKey:[NSString stringWithFormat:@"%@",cellTtitleArray[indexPath.row]]];
            [self.navigationController pushViewController:hdvc animated:YES];
        }
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.contactTableView hideFlotage];
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
