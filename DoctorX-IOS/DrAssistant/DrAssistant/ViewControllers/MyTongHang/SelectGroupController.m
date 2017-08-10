//
//  SelectGroupController.m
//  DrAssistant
//
//  Created by xubojoy on 15/10/21.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "SelectGroupController.h"
#import "MyPatientHandler.h"
@interface SelectGroupController ()

@end

@implementation SelectGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"移动到分组";
    [self initTableView];
    [self loadGroupData];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

}

-(void)loadGroupData{

    [self showWithStatus:@"请等待.."];
    [MyPatientHandler getAllGroupWithType:self.friendType success:^(BaseEntity *object) {
        
        if (object.success) {
            [self dismissToast];
            
            GroupListEntity *entity = (GroupListEntity *)object;
            NSLog(@">>>>>>>>>获取分组>>>>>>>>>>>>%@",entity.data);
            self.dataSource = [entity.data mutableCopy];
            
            [self.tableView reloadData];
        }else{
            
        }
    } fail:^(id object) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.dataSource != nil) {
        GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = entity.groupname;
        //实现单选
        if ([self.currentIndexPath isEqual:indexPath])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex:indexPath.row];
    //实现单选
    NSLog(@">>>>>>>>>>>>>>>分组id>>>>>>>>>>>>>>>>>%@",entity.ID);
    self.lastIndexPath=self.currentIndexPath;
    self.currentIndexPath = indexPath;
    
    if (self.lastIndexPath)
    {
        [tableView reloadRowsAtIndexPaths:@[self.lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@">>>>>>>>>>>>>self.friendId>>>>>>>>>>>>%@",self.friendId);
    [MyPatientHandler changeGroupByAccount:[GlobalConst shareInstance].loginInfo.iD friendLoginName:self.friendId groupId:entity.ID success:^(BaseEntity *object) {
        if (object.success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"移动分组" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(id object) {
        if ([object isKindOfClass:[EMError class]])
        {
            EMError *error = (EMError *)object;
            [self showString:error.description];
        }

    }];
    
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
