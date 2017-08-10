//
//  GoodDoctorSecondViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/11/16.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "GoodDoctorSecondViewController.h"

@interface GoodDoctorSecondViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSouceArray;
@property (nonatomic,strong) NSMutableArray *dataImageArray;
@end

@implementation GoodDoctorSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
    
    if ([self.indexclick isEqualToString:@"0"]) {
        NSArray *temp = @[@"西医临床执业医师(含助理)资格证",@"中医中西医执业医师(含助理)资格证",@"心理咨询师",@"国家执业药师",@"营养师",@"健康管理师"];
        self.dataImageArray = [[NSMutableArray alloc]initWithObjects:@"tub1.png",@"tub2.png",@"tub3.png",@"tub4.png",@"tub5.png",@"tub6.png", nil];
        [self.dataSouceArray addObjectsFromArray:temp];
    }
    if ([self.indexclick isEqualToString:@"1"]) {
        NSArray *temp = @[@"专升本",@"高级本",@"高起专",@"在职研究生"];
        self.dataImageArray = [[NSMutableArray alloc]initWithObjects:@"zhuan1.png",@"zhuan2.png",@"zhuan3.png",@"zhuan4.png", nil];
        [self.dataSouceArray addObjectsFromArray:temp];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenty = @"goodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.dataSouceArray safeObjectAtIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.dataImageArray safeObjectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
