//
//  BulkViewController.m
//  DrAssistant
//
//  Created by taller on 15/10/12.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BulkViewController.h"
#import "MultistageTableView.h"
#import "ChatViewController.h"
#import "MyPatientHandler.h"
#import "MultistageTableView.h"
#import "FriendSectionHeader.h"
#import "GroupInfoEntity.h"
#import "MyPatientsCell.h"
#import "HeadView.h"

@interface BulkViewController ()<IChatManagerDelegate, UITableViewDataSource,HeadViewDelegate, UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (strong, nonatomic) NSMutableArray *sendGroup_dataArray;

@property (strong, nonatomic)  UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *selectIndexPaths;
@property (nonatomic, strong) NSIndexPath *selectPath;

@end

@implementation BulkViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(commitDataAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.bulkHeader = [BulkHeader bulkHeader];
    self.bulkHeader.textView.delegate = self;
    self.bulkHeader.textView.keyboardType = UIKeyboardTypeDefault;
    self.bulkHeader.textView.returnKeyType = UIReturnKeyDone;
    self.bulkHeader.textView.layer.borderWidth = 0.3;
    self.bulkHeader.textView.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.bulkHeader.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 150);
    self.tableView.tableHeaderView = self.bulkHeader;
    int type;
    if (self.qunFaMsgType == push_from_my_tonghang_vc) {
        type = 1;
    }else if(self.qunFaMsgType == push_from_my_patient_vc){
        type = 0;
    }
    [self showWithStatus:@"请等待.."];
    [MyPatientHandler getAllGroupWithType:type success:^(BaseEntity *object) {
        [self dismissToast];
        if (object.success) {
            
            GroupListEntity *entity = (GroupListEntity *)object;
            self.dataSource = [entity.data mutableCopy];
            [self.tableView reloadData];
            
            self.sendGroup_dataArray = self.dataSource;
            
        }else{
            
        }
    } fail:^(id object) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)commitDataAction{
    self.groupInfoFriendsArray = [NSMutableArray new];
    for (int i = 0; i<self.selectIndexPaths.count; i++) {
        
        self.selectPath = [self.selectIndexPaths objectAtIndex:i];
        GroupInfoEntity *entity = [self.sendGroup_dataArray safeObjectAtIndex: self.selectPath.section];
        UserEntity *friend = [entity.friends safeObjectAtIndex: self.selectPath.row];
        [self.groupInfoFriendsArray safeAddObject:friend];
    }
    NSLog(@"*-*%@",self.groupInfoFriendsArray);
    
    EMChatText *txt = [[EMChatText alloc] initWithText:self.bulkHeader.textView.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txt];
    for (UserEntity *userEntity in self.groupInfoFriendsArray) {
        EMMessage *message = [[EMMessage alloc] initWithReceiver:userEntity.LOGIN_NAME bodies:@[body]];
        message.messageType = eMessageTypeChat; // 设置为单聊消息
        message.requireEncryption = YES;
        //message.messageType = eConversationTypeGroupChat;// 设置为群聊消息
        //message.messageType = eConversationTypeChatRoom;// 设置为聊天室消息
        message.deliveryState = eMessageDeliveryState_Delivered;
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message];
        
        [[EaseMob sharedInstance].chatManager
         asyncSendMessage:message
         progress:nil];
        NSLog(@"----------------%@",message);
        [self showString:@"已发送"];
        [self.bulkHeader.textView endEditing:YES];
        self.bulkHeader.textView.text = @"";
        [self.selectIndexPaths removeAllObjects];
        [self.tableView reloadData];
    }
    
}


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
    
    if ([self.selectIndexPaths containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
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
    if ([self.selectIndexPaths containsObject:indexPath])
    {
        [self.selectIndexPaths removeObject:indexPath];//把这个cell的标记移除
    }
    else
    {
        [self.selectIndexPaths addObject:indexPath];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"%@",indexPath);
}

- (void)clickHeadView
{
    [self.tableView reloadData];
}

#pragma mark - setter getter
- (NSMutableArray *)selectIndexPaths
{
    if (_selectIndexPaths == nil) {
        _selectIndexPaths = [NSMutableArray array];
    }
    return _selectIndexPaths;
}
- (NSMutableArray *)sendGroup_dataArray
{
    if (_sendGroup_dataArray == nil){
        _sendGroup_dataArray = [NSMutableArray array];
    }
    return _sendGroup_dataArray;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)contactsSource
{
    if (_contactsSource == nil){
        _contactsSource = [NSMutableArray array];
    }
    return _contactsSource;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
        NSLog(@" scrollViewDidScroll");
}

//#pragma mark - UITextFieldDelegate
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
