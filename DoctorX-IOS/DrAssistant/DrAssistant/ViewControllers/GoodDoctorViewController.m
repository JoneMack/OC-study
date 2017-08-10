//
//  GoodDoctorViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/11/16.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "GoodDoctorViewController.h"
#import "GoodDoctorSecondViewController.h"
@interface GoodDoctorViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSouceArray;
@property (nonatomic,strong) NSMutableArray *dataImageArray;
@end

@implementation GoodDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *tempArray = @[@"资格证类（免费课程）",@"学历教育（免费课程）"];
    self.dataImageArray = [[NSMutableArray alloc]initWithObjects:@"zgz.png",@"zgz2.png", nil];
    [self.dataSouceArray addObjectsFromArray:tempArray];
    //NSLog(@"%@",self.dataSouceArray);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenty = @"goodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.dataSouceArray safeObjectAtIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.dataImageArray safeObjectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodDoctorSecondViewController *gdSec = [GoodDoctorSecondViewController simpleInstance];
    gdSec.title = [NSString stringWithFormat:@"%@",[self.dataSouceArray safeObjectAtIndex:indexPath.row]];
    gdSec.indexclick = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.navigationController pushViewController:gdSec animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableArray *)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = [[NSMutableArray alloc]init];
    }
    return _dataSouceArray;
}
@end
