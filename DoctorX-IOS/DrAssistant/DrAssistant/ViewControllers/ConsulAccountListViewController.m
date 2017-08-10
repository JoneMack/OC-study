//
//  ConsulAccountListViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/14.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "ConsulAccountListViewController.h"
#import "ChineseString.h"

@interface ConsulAccountListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *indexArray;
@property (nonatomic,strong) NSMutableArray *LetterResultArr;

@property(nonatomic,strong)NSMutableArray*selectIndexPaths;
@property(nonatomic,strong)NSIndexPath*selectPath;
@property(nonatomic,strong)NSMutableArray* addObj;
@property(nonatomic,strong)NSArray *chatPeopleName;
@end

@implementation ConsulAccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addRightBtnAction];
    
    NSLog(@"%@",self.reciveAccountArray);
    
    self.selectIndexPaths = [[NSMutableArray alloc]init];
    self.addObj = [[NSMutableArray alloc]init];
    
    self.indexArray = [[NSMutableArray alloc]init];
    self.LetterResultArr = [[NSMutableArray alloc]init];

    
    NSMutableArray *mutiArray = [[NSMutableArray alloc]init];
    
    for (UserEntity *entity in self.reciveAccountArray) {
        if (entity.REAL_NAME.length == 0) {
            [mutiArray safeAddObject:entity.LOGIN_NAME];
        }
        else{
            [mutiArray safeAddObject:entity.REAL_NAME];
        }
        
    }

    NSArray *stringsToSort = mutiArray;
    NSLog(@"%@",stringsToSort);
    
    self.indexArray = [ChineseString IndexArray:stringsToSort];
    self.LetterResultArr = [ChineseString LetterSortArray:stringsToSort];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];

}
- (void) addRightBtnAction
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)saveButtonAction
{
    NSLog(@"@@");
    for (int i = 0; i<self.selectIndexPaths.count; i++) {
        
        self.selectPath = [self.selectIndexPaths objectAtIndex:i];
        [self.addObj addObject:[[self.LetterResultArr objectAtIndex:self.selectPath.section] objectAtIndex:self.selectPath.row]];
    }
    NSLog(@"*-*%@",self.addObj);
    
    NSMutableArray *accountPhoneArr = [[NSMutableArray alloc]init];
    for (UserEntity *entity in self.reciveAccountArray) {
        for (NSString *ns in self.addObj) {
            if ([entity.REAL_NAME isEqualToString:ns]) {
                [accountPhoneArr safeAddObject:entity.LOGIN_NAME];
            }
            if ([entity.LOGIN_NAME isEqualToString:ns]) {
                [accountPhoneArr safeAddObject:entity.LOGIN_NAME];
            }
        }
    }
    self.chatPeopleName = accountPhoneArr;
    NSLog(@"accountPhoneArr--%@",self.chatPeopleName);
    
    NSString *accountName = [GlobalConst shareInstance].loginInfo.real_name;
    NSLog(@"accountName---%@",accountName);
    
//    EMError *error = nil;
//    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
//    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
//    groupStyleSetting.groupStyle = eGroupStyle_PrivateOnlyOwnerInvite; // 创建不同类型的群组，这里需要才传入不同的类型
//    EMGroup *group = [[EaseMob sharedInstance].chatManager createGroupWithSubject:[NSString stringWithFormat:@"%@-的会诊ZZDBDZKJYXGS2",self.huanZheName] description:self.discribeString invitees:self.chatPeopleName initialWelcomeMessage:[NSString stringWithFormat:@"%@邀请您加入会诊",accountName] styleSetting:groupStyleSetting error:&error];
//    if(!error){
//        NSLog(@"创建成功 -- %@",group);
//        [self showHint:NSLocalizedString(@"group.create.success", @"create group success")];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"COMECONSULTLISTTOROOTVIEW" object:nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CREATHUIZHECHATGROUPRELOADDATA" object:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        NSLog(@"创建 -- %@",group);
//        [self.selectIndexPaths removeLastObject];
//        [self.selectIndexPaths removeAllObjects];
//        self.selectIndexPaths = [NSMutableArray array];
//        [self.tableView reloadData];
//        [self showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
//    }
    
    
    NSInteger maxUsersCount = 200;
    if ([self.chatPeopleName count] > (maxUsersCount - 1)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        
        return ;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.create.ongoing", @"create a group...")];
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
    setting.groupMaxUsersCount = maxUsersCount;
    setting.groupStyle = eGroupStyle_PrivateOnlyOwnerInvite;

    
    __weak ConsulAccountListViewController *weakSelf = self;
//:NSLocalizedString(@"group.somebodyInvite", @"%@ 邀请您参加会诊"), accountName
    NSString *messageStr = [NSString stringWithFormat:@"%@ 邀请您参加会诊",accountName];
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:[NSString stringWithFormat:@"%@-的会诊ZZDBDZKJYXGS2",self.huanZheName] description:self.discribeString invitees:self.chatPeopleName initialWelcomeMessage:messageStr styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (group && !error) {
            [weakSelf showHint:NSLocalizedString(@"group.create.success", @"create group success")];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COMECONSULTLISTTOROOTVIEW" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else{
            [weakSelf showHint:NSLocalizedString(@"group.create.fail", @"Failed to create a group, please operate again")];
        }
    } onQueue:nil];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [_indexArray count];
}
//*字母排序搜索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if([_indexArray count]==0)
    {
        
        return @"";
        
    }
    
    return [_indexArray objectAtIndex:section];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger i =  [[_LetterResultArr objectAtIndex:section] count];
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableview
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger sectionMy = [indexPath section];
    
    cell.textLabel.text = [[_LetterResultArr objectAtIndex:sectionMy]objectAtIndex:row]; //每一行显示的文字
    
    if ([self.selectIndexPaths containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }


    return cell;
}
//选中时执行的操作
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectIndexPaths containsObject:indexPath]) {

        
        [self.selectIndexPaths removeObject:indexPath];//把这个cell的标记移除
    }
    else
    {
  
        
        [self.selectIndexPaths addObject:indexPath];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //这里控制值的大小
    return 50.0;  //控制行高
    
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
