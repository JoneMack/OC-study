//
//  SubscribeDescController.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/23.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define subscribe_expert_price_height 40

#import "SubscribeDescController.h"
#import "ExpertPriceCell.h"
#import "SubscribeExpertController.h"
#import "SystemStore.h"
#import "SystemPromptController.h"

@interface SubscribeDescController ()

@end

@implementation SubscribeDescController

-(instancetype) initWithExpert:(Expert *)expert
{
    self = [super init];
    if (self) {
        self.expert = expert;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [[HeaderView alloc] initWithTitle:self.expert.name navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
    
    
    self.bodyView = [[UIView alloc] init];
    self.bodyView.frame = CGRectMake( 0, self.headerView.bottomY, screen_width, screen_height - self.headerView.frame.size.height);
    [self.bodyView setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
    [self.view addSubview:self.bodyView];
    
    self.contentBlockView = [[UIImageView alloc] init];
    self.contentBlockView.frame = CGRectMake(15, 15, screen_width - 15*2, 80);
    [self.contentBlockView setImage:[UIImage imageNamed:@"bg_colorful_small"]];
    self.contentBlockView.layer.borderWidth = 0;
    [self.bodyView addSubview:self.contentBlockView];
    
    // 第一根线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:@"ffffff" alpha:0.5];
    self.separatorLine.frame = CGRectMake(22, 22,
                                          (self.contentBlockView.frame.size.width - 93 - 22*2)/2 ,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    // 订阅说明
    self.commonLabel = [[UILabel alloc] init];
    self.commonLabel.text = @"订阅说明";
    self.commonLabel.font = [UIFont systemFontOfSize:13 weight:3];
    self.commonLabel.textAlignment = NSTextAlignmentCenter;
    self.commonLabel.frame = CGRectMake(self.separatorLine.rightX, 12, 93, 20);
    [self.contentBlockView addSubview:self.commonLabel];
    
    // 第二根线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:@"ffffff" alpha:0.5];
    self.separatorLine.frame = CGRectMake(self.commonLabel.rightX, 22,
                                          (self.contentBlockView.frame.size.width - 93 - 22*2)/2 ,
                                          splite_line_height);
    [self.contentBlockView addSubview:self.separatorLine];
    
    // 时间越长越省钱哦
    self.commonLabel = [[UILabel alloc] init];
    self.commonLabel.text = @"时间越长越省钱哦!";
    self.commonLabel.font = [UIFont systemFontOfSize:13 weight:3];
    self.commonLabel.textAlignment = NSTextAlignmentCenter;
    self.commonLabel.frame = CGRectMake(0, 40, self.contentBlockView.frame.size.width, 20);
    [self.contentBlockView addSubview:self.commonLabel];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(19, self.contentBlockView.bottomY + 20, screen_width -19*2 , 100 );
    
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 8;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.bodyView addSubview:self.tableView];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = subscribe_expert_price_height * self.expert.expertPriceLists.count;
    self.tableView.frame = tableFrame;
    return self.expert.expertPriceLists.count;
}

-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return subscribe_expert_price_height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subscribePriceCellId = @"subscribePriceCellId";
    ExpertPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:subscribePriceCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpertPriceCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.subscribeCycle setTextColor:[ColorUtils colorWithHexString:orange_text_color]];
        [cell.subscribePoint setTextColor:[ColorUtils colorWithHexString:orange_text_low_color]];
        
        UIView *tempSeparatorLine = [UIView new];
        tempSeparatorLine.frame = CGRectMake(0, subscribe_expert_price_height-0.5,
                                              screen_width,
                                              splite_line_height);
        [tempSeparatorLine setBackgroundColor:[ColorUtils colorWithHexString:gray_common_color]];
        
        [cell addSubview:tempSeparatorLine];
    }
    ExpertPriceList *price = self.expert.expertPriceLists[indexPath.row];
    cell.subscribeCycle.text = [NSString stringWithFormat:@"%d" , price.dayCount];
    cell.subscribePoint.text = [NSString stringWithFormat:@"%d" , price.point];
    [cell.pointLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertPriceList *price = self.expert.expertPriceLists[indexPath.row];
    SubscribeExpertController *subscribeExpertController = [[SubscribeExpertController alloc] initWithExpert:self.expert expertPrice:price];
    [self.navigationController pushViewController:subscribeExpertController animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
