//
//  MessageCenterViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterCell.h"

static NSString *messageCenterCellId = @"messageCenterCellId";

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    [self initBodyView];
    [self setRightSwipeGestureAndAdaptive];
    
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"消息中心" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
}


-(void) initBodyView
{
    self.bodyView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY) style:UITableViewStylePlain];
    [self.view addSubview:self.bodyView];
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"MessageCenterCell" bundle:nil];
    [self.bodyView registerNib:nib forCellReuseIdentifier:messageCenterCellId];
    
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCenterCellId forIndexPath:indexPath];
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
