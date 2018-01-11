//
//  TimeInViewController.m
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/3.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import "TimeInViewController.h"

@interface TimeInViewController ()

@end

@implementation TimeInViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"我是个1",
                     @"我是个2",
                     @"我是个3",
                     @"我是个4",
                     @"我是个5",
                     @"我是个6",
                     @"我是个7",
                     @"我是个8",
                     @"我是个9",
                     @"我是个10",
                     @"我是个11",
                     @"我是个12",
                     @"我是个13",
                     @"我是个14",
                     @"我是个15",
                     ];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    self.DatNum = -1;
    NSMutableArray *indexPaths = @[].mutableCopy;
    self.indesPaths = indexPaths;
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(charusell) userInfo:nil repeats:YES];
}

-(void)charusell{
    self.DatNum = self.DatNum +1;
    if (self.DatNum < self.dataArr.count) {
        [self.indesPaths addObject:[NSIndexPath indexPathForItem:0 inSection:0]];
        [self.tableView insertRowsAtIndexPaths:self.indesPaths withRowAnimation:UITableViewRowAnimationRight];
        [self.indesPaths removeAllObjects];
    }else{
        [self.timer invalidate];
        //记得当不用这个定时器的时候要销毁.
        self.timer = nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DatNum+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSLog(@"----------self.DatNum----------%d",self.DatNum+1);
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.dataArr[(self.dataArr.count)-(self.DatNum+1)];
    }
    return cell;
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
