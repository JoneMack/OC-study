//
//  GlobalSearchViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/4.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "GlobalSearchViewController.h"
#import "AreaFindHousesViewController.h"

@interface GlobalSearchViewController ()

@end

@implementation GlobalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self setRightSwipeGestureAndAdaptive];
    
    [self initBodyView];
    
}

-(void) initBodyView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
}

-(void) initView
{
    [self.headerBlock setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    self.searchBg.layer.cornerRadius=14.5;
    
    
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.textField.delegate = self;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0){
        return 1;
    }
    AppStatus *as = [AppStatus sharedInstance];
    return as.searchConditions.count + 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 44;
    }else{
        return 53;
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    UILabel *title = [UILabel new];
    [headerView.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
    [title setFont:[UIFont systemFontOfSize:11]];
    [title setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
    title.frame = CGRectMake(10, 0, 45, 26);
    
    if(section == 0){
        [title setText:@"热门地点"];
    }else if(section == 1){
        [title setText:@"搜索历史"];
    }
    [headerView addSubview:title];
    return headerView;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [UITableViewCell new];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.section == 0){
        if(self.hotCircleCollectionView == nil){
            self.hotCircleCollectionView = [[HotCircleCollectionView alloc] init];
        }
        self.hotCircleCollectionView.navigationController = self.navigationController;
        [cell.contentView addSubview:self.hotCircleCollectionView];
    }else{
        AppStatus *as = [AppStatus sharedInstance];
        NSArray<NSString *> *searchConditions = as.searchConditions;
        if(searchConditions.count == indexPath.row){
            [cell.textLabel setText:@"清空历史记录"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
            [cell.textLabel setTextColor:[ColorUtils colorWithHexString:text_color_purple]];
            
        }else{
            [cell.textLabel setText:searchConditions[indexPath.row]];
            [cell.imageView setImage:[UIImage imageNamed:@"clock"]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
            [cell.textLabel setTextColor:[ColorUtils colorWithHexString:text_color_gray]];
            self.separatorLine = [[UIView alloc] init];
            [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
            self.separatorLine.frame = CGRectMake(0, 52.5, screen_width, splite_line_height);
            [cell.contentView addSubview:self.separatorLine];

        }
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        AppStatus *as = [AppStatus sharedInstance];
        if(as.searchConditions.count == indexPath.row){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空历史记录?" message:@"" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"清空", nil];
            [alert show];

        }else{
            NSString *condition = as.searchConditions[indexPath.row];
            
            AreaFindHousesViewController *areaFindHousesViewController = [[AreaFindHousesViewController alloc] init];
            areaFindHousesViewController.searchStr = condition;
            [self.navigationController pushViewController:areaFindHousesViewController animated:YES];
            
        }
    }
}



- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    
    NSString *searchTxt = self.textField.text;
    
    AppStatus *as = [AppStatus sharedInstance];
    [as addSearchCondition:searchTxt];
    
    [self.tableView reloadData];
    
    AreaFindHousesViewController *areaFindHousesViewController = [[AreaFindHousesViewController alloc] init];
    areaFindHousesViewController.searchStr = searchTxt;
    [self.navigationController pushViewController:areaFindHousesViewController animated:YES];
    
    return YES;
}


- (IBAction)cancelSearch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppStatus *as = [AppStatus sharedInstance];
        [as clearSearchConditions];
        [self.tableView reloadData];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
