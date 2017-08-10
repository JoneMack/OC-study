//
//  SubwayLineViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/19.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SubwayLineViewController.h"
#import "SubwayStore.h"
#import "SubwayFindHousesViewController.h"

@interface SubwayLineViewController ()

@end

@implementation SubwayLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initHeaderView];
    [self initBodyLeftView];
    [self initBodyRightView];
    [self setRightSwipeGestureAndAdaptive];
    
    [self.middleLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self loadData];
    
}

- (void) initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"地铁线路" navigationController:self.navigationController];
    [self.headerBlockView addSubview:self.headerView];
    
}

-(void) initBodyLeftView
{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    
    [self.leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if([NSStringUtils isBlank:self.currentSelectSubwayLine]){
        self.currentSelectSubwayLine = @"1号线";
    }
}

-(void) initBodyRightView
{
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void) loadData
{
    [[SubwayStore sharedStore] getSubways:^(NSArray<SubwayLine *> *subwayLines, NSError *err) {
        self.subwayLines = subwayLines;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.leftTableView]){
        
        return self.subwayLines.count;
    }else{
        
        if(self.subwayLines != nil){
            SubwayLine *subwayLine = self.subwayLines[self.currentSelectSubwayLineRow];
            NSArray<Station *> *stations = [subwayLine getStationList];
            return [stations count];
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
        
        SubwayLine *subwayLine = self.subwayLines[indexPath.row];
        
        [cell.textLabel setText:subwayLine.lineName];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        
        if([subwayLine.lineName isEqualToString:self.currentSelectSubwayLine]){
            UIView *lineView = [UIView new];
            [lineView setBackgroundColor:[ColorUtils colorWithHexString:bg_purple ]];
            lineView.frame = CGRectMake(screen_width/4-62/2, 38, 62, 3);
            [cell.contentView addSubview:lineView];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [UITableViewCell new];
        
        
        for(int i=0 ; i<self.subwayLines.count ; i++){
            SubwayLine *subwayLine = self.subwayLines[i];
            if([subwayLine.lineName isEqualToString:self.currentSelectSubwayLine]){
                NSArray<Station *> *stations = [subwayLine getStationList];
                Station *station = stations[indexPath.row];
                [cell.textLabel setText:station.stationName];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
                
                if([self.currentSelectStation isEqualToString:station.stationName]){
                    UIView *lineView = [UIView new];
                    [lineView setBackgroundColor:[ColorUtils colorWithHexString:bg_purple ]];
                    lineView.frame = CGRectMake(screen_width/4-62/2, 38, 62, 3);
                    [cell.contentView addSubview:lineView];
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }
        
        return cell;
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.leftTableView]){
        
        SubwayLine *subwayLine = self.subwayLines[indexPath.row];
        self.currentSelectSubwayLineRow = indexPath.row;
        self.currentSelectSubwayLine = subwayLine.lineName;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        
    }else{
        
        for(int i=0 ; i<self.subwayLines.count ; i++){
            SubwayLine *subwayLine = self.subwayLines[i];
            if([subwayLine.lineName isEqualToString:self.currentSelectSubwayLine]){
                NSArray<Station *> *stations = [subwayLine getStationList];
                Station *station = stations[indexPath.row];
                
                SubwayFindHousesViewController *subwayFindHousesViewController = (SubwayFindHousesViewController *)[self getLastViewController];
                subwayFindHousesViewController.subwayLine = self.currentSelectSubwayLine;
                subwayFindHousesViewController.subwayLineId = subwayLine.id;
                subwayFindHousesViewController.station = station.stationName;
                subwayFindHousesViewController.stationId = station.id;
                
                NSLog(@"-----------------------------------------------------------------------------");
                NSLog(@"self.currentSubwayLine : %@" , self.currentSelectSubwayLine);
                NSLog(@"station.stationName : %@" , station.stationName);
                NSLog(@"-----------------------------------------------------------------------------");
                
                subwayFindHousesViewController.customSegmentView.subwayLine = self.currentSelectSubwayLine;
                subwayFindHousesViewController.customSegmentView.station = station.stationName;
                [subwayFindHousesViewController changeConditionReloadData];
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
