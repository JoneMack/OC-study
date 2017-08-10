//
//  SelectAeraViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/10/26.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "SelectAeraViewController.h"

@interface SelectAeraViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SelectAeraViewController

- (id)initWithDataArray:(NSMutableArray *)dataArray
{
    self = [super init];
    if (self)
    {
        self.dataArray = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdeny = @"cellMark";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdeny];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdeny];
    }
    cell.textLabel.text = [[self.dataArray safeObjectAtIndex:indexPath.row]safeObjectForKey:@"ORG_NAME"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataArray safeObjectAtIndex:indexPath.row];
    NSLog(@"%@",dic);
    //NSString *ORG_NAME = [[self.dataArray safeObjectAtIndex:indexPath.row]safeObjectForKey:@"ORG_NAME"];
    
    NSString *ORG_type = [[self.dataArray safeObjectAtIndex:indexPath.row]safeObjectForKey:@"ORG_TYPE"];
    ORG_type = [NSString stringWithFormat:@"%@",ORG_type];
    
    if ([ORG_type isEqualToString:@"2"] || [ORG_type isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDiQuLab" object:dic];
    }
    if ([ORG_type isEqualToString:@"3"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeYiYuanLab" object:dic];
    }
    if ([ORG_type isEqualToString:@"4"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeKeShiLab" object:dic];        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
