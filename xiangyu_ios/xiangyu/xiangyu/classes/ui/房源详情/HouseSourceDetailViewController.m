//
//  HouseSourceDetailViewController.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailViewController.h"
#import "HouseSourceDetailHeaderCell.h"
#import "HouseSourceDetailSecondCell.h"
#import "HouseSourceDetailThirdCell.h"
#import "HouseSourceDetailFourthCell.h"
#import "HouseSourceDetailFifthCell.h"
#import "HouseSourceDetailBottomView.h"
#import "MainHouseSourceCell.h"
#import "HouseStore.h"
#import "AppDelegate.h"

#define house_rent_type_zhengzu   @"1"
#define house_rent_type_hezu   @"2"


@interface HouseSourceDetailViewController ()

@end

static NSString *houseSourceDetailFirstCellId = @"houseSourceDetailFirstCellId";
static NSString *houseSourceDetailSecondCellId = @"houseSourceDetailSecondCellId";
static NSString *houseSourceDetailThirdCellId = @"houseSourceDetailThirdCellId";
static NSString *houseSourceDetailFourthCellId = @"houseSourceDetailFourthCellId";
static NSString *houseSourceDetailFifthCellId = @"houseSourceDetailFifthCellId";
static NSString *houseSourceDetailSixCellId = @"houseSourceDetailSixCellId";

@implementation HouseSourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeaderView];
    [self initBodyView];
    [self initBottomView];
    [self loadData];
    [self setRightSwipeGestureAndAdaptive];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"详情" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
}

-(void) initBodyView
{
    self.bodyView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 64 , screen_width, screen_height - 64 - 49 )
                                                 style:UITableViewStylePlain];
    
    self.bodyView.delegate = self;
    self.bodyView.dataSource = self;
    
    [self.bodyView setBackgroundColor:[UIColor whiteColor]];
    
    // 注册nib
    UINib *firstNib = [UINib nibWithNibName:@"HouseSourceDetailHeaderCell" bundle:nil];
    [self.bodyView registerNib:firstNib forCellReuseIdentifier:houseSourceDetailFirstCellId];
    
    [self.bodyView registerClass:[HouseSourceDetailSecondCell class] forCellReuseIdentifier:houseSourceDetailSecondCellId];
    
    UINib *thirdNib = [UINib nibWithNibName:@"HouseSourceDetailThirdCell" bundle:nil];
    [self.bodyView registerNib:thirdNib forCellReuseIdentifier:houseSourceDetailThirdCellId];
    
    
    UINib *fourthNib = [UINib nibWithNibName:@"HouseSourceDetailFourthCell" bundle:nil];
    [self.bodyView registerNib:fourthNib forCellReuseIdentifier:houseSourceDetailFourthCellId];
    
    UINib *fifthNib = [UINib nibWithNibName:@"HouseSourceDetailFifthCell" bundle:nil];
    [self.bodyView registerNib:fifthNib forCellReuseIdentifier:houseSourceDetailFifthCellId];
    
    UINib *sixNib = [UINib nibWithNibName:@"MainHouseSourceCell" bundle:nil];
    [self.bodyView registerNib:sixNib
                  forCellReuseIdentifier:houseSourceDetailSixCellId];
    
    [self.bodyView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:self.bodyView];
    
}

-(void) initBottomView
{
    CGRect frame = CGRectMake(0, screen_height-49 , screen_width, 49);
    self.bottomView = [[HouseSourceDetailBottomView alloc] init];
    self.bottomView.frame = frame;
    self.bottomView.navigationController = self.navigationController;
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    self.bottomView.houseInfo= self.houseInfo;
    self.bottomView.house = self.house;
    [self.view addSubview:self.bottomView];
    
}

-(void) loadData
{
    // 如果是整租，房间号需要传空
    if([self.rentType isEqualToString:@"1"]){
        self.roomId = @"";
        self.houseInfo.roomId = @"";
    }
    
    [[HouseStore sharedStore] getHouseInfo:^(HouseInfo *houseInfo, NSError *err) {
        self.houseInfo = houseInfo;
        [self.bodyView reloadData];
        [self loadRecommendHouses];
        NSLog(@" house info :%@" , houseInfo);
        [self.bottomView renderData:self.houseInfo];
        
    } houseId:self.houseId roomId:self.roomId rentType:self.rentType];
}

-(void) loadRecommendHouses
{
    [[HouseStore sharedStore] getRecommendHouses:^(NSArray<House *> *houses, NSError *err) {
        
        self.recommendHouses = houses;
        [self.bodyView reloadData];
        
    } houseId:self.houseInfo.houseId roomId:self.houseInfo.roomId rentType:self.houseInfo.rentType];
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 5){
        return [self.recommendHouses count];
    }
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1 || section == 2 || section == 4 || section == 5){
        return 26;
    }
    if(section == 3){
        if([self.houseInfo.rentType isEqualToString:house_rent_type_hezu]){
            return 26;
        }
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 258;
    }else if(indexPath.section == 1){
        return 112;
    }else if(indexPath.section == 2){
        NSLog(@"+++++++++++++%@",self.houseInfo);
        if(self.houseInfo != nil &&
           ([NSStringUtils isNotBlank:self.houseInfo.indoorsNames] || [NSStringUtils isNotBlank:self.houseInfo.indoorsJJNames])){
            NSArray *icons1 = [self.houseInfo.indoorsNames componentsSeparatedByString:@","];
            NSArray *icons2 = [self.houseInfo.indoorsJJNames componentsSeparatedByString:@","];
            NSMutableArray *totalIcons = [[NSMutableArray alloc] init];
            [totalIcons addObjectsFromArray:icons1];
            [totalIcons addObjectsFromArray:icons2];
            int row = 0;
            int zhengshu = (int)totalIcons.count/5;
            int zhengshuRemind = (int)totalIcons.count%5;
            if (zhengshuRemind == 0) {
                row = zhengshu;
            }else{
                row = zhengshu+1;
            }
            return 74+row*50+(row-1)*10+30;
        }else{
            return 74;
        }
    }else if(indexPath.section == 3){
        if( [self.rentType isEqualToString:house_rent_type_zhengzu]){
            return 0;
        }else{
            return 41.5*[self.houseInfo.roomShip count]+15;
        }
    }else if(indexPath.section == 4){
        return 268;
    }else if(indexPath.section == 5){
        return 130;
    }
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [UITableViewHeaderFooterView new];
    
    if(section == 1){
        UILabel *houseNo = [UILabel new];
        [houseNo setText:[NSString stringWithFormat:@"房源编号 : %@" , self.houseInfo.houseId]];
        [houseNo setFont:[UIFont systemFontOfSize:10]];
        [houseNo setTextColor:[ColorUtils colorWithHexString:text_color_gray]];
        houseNo.frame = CGRectMake(10, 0, 180, 26);
        [view addSubview:houseNo];
        
        UILabel *publishTime = [UILabel new];
        [publishTime setText:[NSString stringWithFormat:@"发布时间 : %@" , self.houseInfo.createTime]];
        [publishTime setFont:[UIFont systemFontOfSize:10]];
        [publishTime setTextColor:[ColorUtils colorWithHexString:text_color_gray]];
        publishTime.frame = CGRectMake(screen_width - 112-5, 0, 112, 26);
        [view addSubview:publishTime];
        [view.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_gray"]]];
        
    }else{
        UILabel *title = [UILabel new];
        [view.contentView setBackgroundColor:[ColorUtils colorWithHexString:bg_gray2]];
        [title setFont:[UIFont systemFontOfSize:11]];
        [title setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray]];
        title.frame = CGRectMake(10, 0, 45, 26);
        
        if(section == 2){
            [title setText:@"房屋信息"];
        }else if(section == 3){
            [title setText:@"合租信息"];
        }else if(section == 4){
            [title setText:@"地理位置"];
        }else if(section == 5){
            [title setText:@"推荐房源"];
        }
        [view addSubview:title];
    }
    
    return view;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        HouseSourceDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailFirstCellId forIndexPath:indexPath];
        [cell renderData:self.houseInfo];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 1){
        HouseSourceDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailSecondCellId forIndexPath:indexPath];
        [cell renderData:self.houseInfo];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 2){
        
        HouseSourceDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailThirdCellId forIndexPath:indexPath];
        [cell renderData:self.houseInfo];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 3){
        HouseSourceDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailFourthCellId forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([self.houseInfo.rentType isEqualToString:house_rent_type_hezu]){
            [cell renderData:self.houseInfo];
        }
        return cell;
    }else if(indexPath.section == 4){
        HouseSourceDetailFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailFifthCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initSearchViewWithHouseInfo:self.houseInfo];
        return cell;
    }else if(indexPath.section == 5){
        MainHouseSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:houseSourceDetailSixCellId forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        House *house = self.recommendHouses[indexPath.row];
        [cell renderData:house];
        return cell;
    }
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 5){
        House *house = self.recommendHouses[indexPath.row];
        HouseSourceDetailViewController *detailViewController = [[HouseSourceDetailViewController alloc] init];
        detailViewController.houseId= house.houseId;
        detailViewController.roomId = house.roomsID;
        detailViewController.rentType = house.rentType;
        detailViewController.house = house;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
