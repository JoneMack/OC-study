//
//  SelectAreaViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "CircleStore.h"
#import "AreaFindHousesViewController.h"

@interface SelectAreaViewController ()

@end

@implementation SelectAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    
    [self initBodyLeftView];
    [self initBodyRightView];
    [self setRightSwipeGestureAndAdaptive];
    
    [self.middleLineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    if(self.currentQuyu == nil){
        self.currentQuyu = @"东城区";
    }
    [self loadData];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"选择区域" navigationController:self.navigationController];
    [self.headerBlock addSubview:self.headerView];
}

-(void) initBodyLeftView
{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    
    [self.leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

-(void) initBodyRightView
{
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


-(void) loadData
{
    [[CircleStore sharedStore] getCircles:^(Circle *circle, NSError *err) {
        self.circle = circle;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.leftTableView]){
        if(self.circle != nil){
            return [self.circle getChildren].count;
        }
    }else{
        
        if(self.circle != nil){
            
            NSArray<Circle *> *circles = [self.circle getChildren];
            for(int i=0 ; i<circles.count ; i++){
                Circle *circle = circles[i];
                if( [circle.text isEqualToString:self.currentQuyu]){
                    return [circle getChildren].count;
                }
                
            }
            
        }
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.leftTableView]){
        UITableViewCell *cell = [UITableViewCell new];
        
        NSArray<Circle *> *circles = [self.circle getChildren];
        Circle *circle = circles[indexPath.row];
        
        [cell.textLabel setText:circle.text];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        
        if([circle.text isEqualToString:self.currentQuyu]){
            UIView *lineView = [UIView new];
            [lineView setBackgroundColor:[ColorUtils colorWithHexString:bg_purple ]];
            lineView.frame = CGRectMake(screen_width/4-62/2, 38, 62, 3);
            [cell.contentView addSubview:lineView];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [UITableViewCell new];
        NSArray<Circle *> *circles = [self.circle getChildren];
        for(int i=0 ; i<circles.count ; i++){
            Circle *circle = circles[i];
            if( [circle.text isEqualToString:self.currentQuyu]){
                NSArray<Circle *> *shangquans = [circle getChildren];
                Circle *shangquan = shangquans[indexPath.row];
                [cell.textLabel setText:shangquan.text];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
                
                if([shangquan.text isEqualToString:self.currentShangquan]){
                    UIView *lineView = [UIView new];
                    [lineView setBackgroundColor:[ColorUtils colorWithHexString:bg_purple ]];
                    lineView.frame = CGRectMake(screen_width/4-62/2, 38, 62, 3);
                    [cell.contentView addSubview:lineView];
                }
            }
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.leftTableView]){
        
        NSArray<Circle *> *circles = [self.circle getChildren];
        Circle *circle = circles[indexPath.row];
        self.currentQuyu = circle.text;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        
    }else{
        NSArray<Circle *> *circles = [self.circle getChildren];
        for(int i=0 ; i<circles.count ; i++){
        
            Circle *circle = circles[i];
            if( [circle.text isEqualToString:self.currentQuyu]){
            
                
                NSArray<Circle *> *shangquans = [circle getChildren];
                Circle *shangquan = shangquans[indexPath.row];
                
                AreaFindHousesViewController *areaFindHousesViewController = (AreaFindHousesViewController *)[self getLastViewController];
                
                areaFindHousesViewController.quyu = self.currentQuyu;
                areaFindHousesViewController.shangquan = shangquan.text;
                areaFindHousesViewController.customSegmentView.quyu = self.currentQuyu;
                areaFindHousesViewController.customSegmentView.shangquan = shangquan.text;
                
                [areaFindHousesViewController loadData];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }   
    }
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
