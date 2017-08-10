//
//  MessageListController.m
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MessageListController.h"
#import "MessageLsiCell.h"
#import "ChatViewController.h"
#import "HMBannerView.h"
#import "GRNetworkAgent.h"
#import "AdsEntity.h"

@interface MessageListController ()<ChatViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HMBannerView *headerView;

@property (strong, nonatomic) NSArray *ads;
@end

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self getAds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tableHeaderView = self.headerView;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *CellIdentiferId = @"msgCell";
    MessageLsiCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MessageLsiCell" owner:nil options:nil];
        cell = [nibs lastObject];
    };
    
    cell.nameLabel.text = @"john";
    cell.dateLabel.text = @"2015-12-08";
    cell.detailLabel.text = @"hi....";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"zhf" conversationType:eConversationTypeChat];

    
    ChatViewController *chatController;
  
    NSString *chatter = conversation.chatter;
    
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
    
    chatController.delelgate = self;
    
    [self.tabBarController.navigationController pushViewController: chatController animated:YES];
    
    
}

- (HMBannerView *)headerView
{
    if (_headerView == nil) {
        
        _headerView = [[HMBannerView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150) scrollDirection:ScrollDirectionLandscape images:@[@""]];
        _headerView.rollingDelayTime = 1.5;
    }
    
    return _headerView;
}

- (void)getAds
{
    NSDictionary *dic = [BaseEntity sign: nil];
    [[GRNetworkAgent sharedInstance] requestUrl:ADS_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        AdsEntity *entity = [AdsEntity objectWithKeyValues:reponeObject];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (AdsEntity *info in entity.data) {
            [arr safeAddObject: info.url];
        }
        
        [self.headerView updateCycleScrollView:arr];
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
