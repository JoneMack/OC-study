//
//  ZhuanJiaListViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ZhuanJiaListViewController.h"
#import "ZhuanjiaCell.h"
#import "ZhuanJiaHandler.h"
#import "ZhuanJiaDetailController.h"
#import "UIImage+PlaceHolderHeader.h"

@interface ZhuanJiaListViewController ()<ZhuanjiaCellDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (strong,nonatomic) NSMutableArray *friendArray;
@end

@implementation ZhuanJiaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.userInteractionEnabled = YES;
    [self showWithStatus:@"请等待.."];
    [ZhuanJiaHandler requestZhuanJiaListWithClubID:self.ClubInfo success:^(BaseEntity *object) {
        if (object.msg) {
            [self dismissToast];
            UserEntity *entity = (UserEntity *)object;
            self.dataArr = entity.data;
            [self getDoctorDriend];
        }else{
            [self showString:@"加载失败"];
        }
    } fail:^(id object) {
        
    }];
}
-(void)getDoctorDriend{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@(YES) forKey:@"needFriend"];
    [dic safeSetObject:account forKey:@"account"];
    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getMyDoctors_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        NSArray *arrayData = [reponeObject objectForKey:@"data"];
        for (NSDictionary *dic in arrayData) {
            [self.friendArray safeAddObject:dic];
        }
        [self.tableView reloadData];
    } failure:^(GRBaseRequest *request, NSError *error) {
    } withTag:0];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *CellIdentiferId = @"zhuanjiaCell";
    ZhuanjiaCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ZhuanjiaCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.delegate = self;
    };
    UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    cell.nameLabel.text = entity.REAL_NAME;
    cell.descLabel.text = entity.docDesc;
    [cell.avtarImageView sd_setImageWithURL:[NSURL URLWithString:entity.thumb] placeholderImage:[UIImage placeholderAvater]];
    for (NSDictionary *dic in self.friendArray) {
        if ([[NSString stringWithFormat:@"%@",[dic safeObjectForKey:@"ID"]] isEqualToString:entity.ID]) {
            [self addFriendHou:cell.addbtn];
        }
    }
    cell.entity=entity;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ZhuanJiaDetailController *zhuanJJiaDetail = [ZhuanJiaDetailController simpleInstance];
    zhuanJJiaDetail.zhuanJiaInfo = [self.dataArr safeObjectAtIndex: indexPath.row];
    [self.navigationController pushViewController: zhuanJJiaDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma  mark delegate
- (void)addFriedAction:(ZhuanjiaCell *)cell
{
    [self showWithStatus:@"请等待.."];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
    NSString *userId = [GlobalConst shareInstance].loginInfo.iD;
    NSLog(@"cell.entity.ID :%@",cell.entity.LOGIN_NAME);
    [dic safeSetObject:userId forKey:@"account"];
    [dic safeSetObject:@"14" forKey:@"group_id"];
    [dic safeSetObject:cell.entity.ID forKey:@"friend_id"];
    [dic safeSetObject:@"1" forKey:@"type"];
    [dic safeSetObject:@"" forKey:@"friend_name"];
    [dic safeSetObject:@"" forKey:@"username"];
    [dic safeSetObject:@"" forKey:@"join_time"];
    [[GRNetworkAgent sharedInstance] requestUrl:addUserToGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        //[self dismissToast];
        NSString *success = [reponeObject objectForKeyedSubscript:@"success"];                                    success = [NSString stringWithFormat:@"%@",success];
        if (success) {
            [self showString:@"好友申请成功,请耐心等待对方同意"];
            [[EaseMob sharedInstance].chatManager addBuddy:cell.entity.LOGIN_NAME message:@"我想加您为好友" error:nil];
            [self addFriendCheck:cell.addbtn];
        }
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        [self showString:@"加好友不成功"];
        
    } withTag:0];
}
- (void)addFriendQian:(UIButton *)btn
{
    [btn setTitle:@"加为好友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:75/255.0 green:168/255.0 blue:183/255.0 alpha:1]];
    btn.userInteractionEnabled = YES;
}
- (void)addFriendHou:(UIButton *)btn
{
    [btn setTitle:@"已关注" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.userInteractionEnabled = NO;
}
- (void)addFriendCheck:(UIButton *)btn
{
    [btn setTitle:@"等待审核中" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.userInteractionEnabled = NO;
}
#pragma mark -  getter
- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSArray alloc] init];
    }
    
    return _dataArr;
}
- (NSMutableArray *)friendArray
{
    if (_friendArray == nil) {
        _friendArray = [[NSMutableArray alloc] init];
    }
    return _friendArray;
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
