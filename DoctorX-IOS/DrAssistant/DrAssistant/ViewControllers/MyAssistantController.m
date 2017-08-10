//
//  MyAssistantController.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyAssistantController.h"
#import "MyAsHeader.h"
#import "AssistantMessageController.h"
#import "AssistantAuthorityController.h"
#import "dutyAssistantController.h"
#import "ApplyAssistantController.h"
#import "BaseHandler.h"
#import "MyAssistantEntity.h"

@interface MyAssistantController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) NSArray *imageArr;
@property (strong, nonatomic) UserEntity *asInfo;
@property (strong, nonatomic) MyAsHeader *header;
@end

@implementation MyAssistantController
BOOL asNull = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getASInfo];
    self.header = [MyAsHeader asHeader];
    self.tableView.tableHeaderView = self.header;
    NSArray *arrima=@[@"quanxian",@"shenqing",@"zhulizhize"];
    NSMutableArray *arrimage = [NSMutableArray array];
    [arrimage safeAddObject:arrima];
    [arrimage safeAddObject:@[@"zhulixinxi"]];
    _imageArr=arrimage;
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arr1 = @[@"申请需知", @"助理职责"];
    [arr safeAddObject: arr1];
    [arr safeAddObject:@[@"助理信息"]];
    self.dataArr = arr;
    
}
-(void)commitAddAction{
    UIStoryboard *stoary=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ApplyAssistantController  *vc=[stoary instantiateViewControllerWithIdentifier:@"ApplyAssistantController"];
    vc.title=@"申请需知";
    [self.navigationController pushViewController: vc animated:YES];
    
}
- (void)getASInfo
{
    NSString *account = [GlobalConst shareInstance].loginInfo.login_name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:account forKey:@"account"];
    [dic addEntriesFromDictionary: [BaseEntity sign:@[account]]];
    
    [[GRNetworkAgent sharedInstance] requestUrl:getAssistantInfo_url param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        MyAssistantEntity *entity = [MyAssistantEntity objectWithKeyValues:reponeObject];
        if (entity.success) {
            self.asInfo = entity.data;
            [self.header.avatar sd_setImageWithURL:[NSURL URLWithString:self.asInfo.thumb] placeholderImage:[UIImage placeholderAvater]];
            self.header.nameLAbel.text = self.asInfo.REAL_NAME;
            if ([self.asInfo.PHONE length]) {
                self.header.phone.text = [@"电话:" stringByAppendingString:self.asInfo.PHONE];
            }
            [self.header.backBtn setHidden:YES];
            asNull=YES;
            [self.tableView reloadData];
        }else{
            [self.header.backBtn addTarget:self action:@selector(commitAddAction) forControlEvents:UIControlEventTouchUpInside];
            self.header.phone.font=[UIFont fontWithName:@"Arial" size:14];
            self.header.phone.text=@"未申请助理，点击申请";
            [self.header.nameLAbel setHidden:TRUE];
            [self.header.dianhuaLianXI setHidden:TRUE];
            [self.header.onlineLianXI setHidden:TRUE];
            [self showString:@"暂无助理"];
        }
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
        
        
    } withTag:0];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSArray *arr = [self.dataArr safeObjectAtIndex: section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *CellIdentiferId = @"myPatientsCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    
    cell.textLabel.text = [[self.dataArr safeObjectAtIndex: indexPath.section] safeObjectAtIndex: indexPath.row];
    NSString *str=[[self.imageArr safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:str];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *myCell = [_tableView cellForRowAtIndexPath:indexPath];
    if([myCell.textLabel.text isEqualToString:@"助理信息"]){
        if(asNull){
            UIStoryboard *stoary=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AssistantMessageController  *vc=[stoary instantiateViewControllerWithIdentifier:@"AssistantMessageController"];
            vc.title=@"助理信息";
            vc.asstantInfo =self.asInfo;
            [self.navigationController pushViewController: vc animated:YES];
        }else{
            [self showString:@"暂无助理"];
        }
    }
//        else if ([myCell.textLabel.text isEqualToString:@"助理权限设置"]){
//        if(asNull){
//            UIStoryboard *stoary=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            AssistantAuthorityController  *vc=[stoary instantiateViewControllerWithIdentifier:@"AssistantAuthorityController"];
//            vc.title=@"助理权限设置";
//            [self.navigationController pushViewController: vc animated:YES];
//        }else{
//            [self showString:@"暂无助理"];
//        }
//    }
        else if ([myCell.textLabel.text isEqualToString:@"申请需知"]){
        UIStoryboard *stoary=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ApplyAssistantController  *vc=[stoary instantiateViewControllerWithIdentifier:@"ApplyAssistantController"];
        vc.title=@"申请需知";
        [self.navigationController pushViewController: vc animated:YES];
    }else if ([myCell.textLabel.text isEqualToString:@"助理职责"]){
        
        dutyAssistantController *vc=[[dutyAssistantController alloc] init];
        vc.title=@"助理职责";
        [self.navigationController pushViewController: vc animated:YES];
    }
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
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
