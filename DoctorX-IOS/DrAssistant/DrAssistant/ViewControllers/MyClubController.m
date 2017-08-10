//
//  MyClubController.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyClubController.h"
#import "MyClubCell.h"
#import "MyClubHandler.h"

@interface MyClubController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation MyClubController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MyClubHandler requestMyClubs:^(BaseEntity *object) {
        
        if (object.reqIsSuccess) {
            
            MyClubEntity *enitty = (MyClubEntity *)object;
            self.dataArr = enitty.clubList;
            
            [self.tableView reloadData];
        }else{
            [self showString:object.responeMsg];
        }
        
    } fail:^(id object) {
        
        
    }];
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
    
    
    static  NSString  *CellIdentiferId = @"myClubCell";
    MyClubCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyClubCell" owner:nil options:nil];
        cell = [nibs lastObject];
    };
    
    MyClubEntity *info = [self.dataArr safeObjectAtIndex: indexPath.row];
    
    cell.name.text = info.clubName;
    cell.descLabel.text = info.INTRODUCTION;
    cell.sortLabel.text = [NSString stringWithFormat:@"俱乐部排名:%zi", info.SORT];
    cell.joinBtn.enabled = !info.isJoined;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma  mark - getter

- (NSArray *)dataArr
{
    if (_dataArr == nil)
    {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
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
