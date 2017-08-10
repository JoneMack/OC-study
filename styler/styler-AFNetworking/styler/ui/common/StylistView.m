//
//  ExpertListView.m
//  styler
//
//  Created by aypc on 13-10-2.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "StylistView.h"
#import "StylistTableCell.h"
#import "Stylist.h"
#import "LBSUtils.h"
#import "StylistStore.h"
#import "StylistProfileController.h"
#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "UIView+Custom.h"
#import "UserStore.h"

@implementation StylistView
{
    UIView *line;
}
@synthesize reloadBtn;
@synthesize networkLable;
@synthesize stylistes;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"StylistView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

//路径初始化
-(id)initWithRequestUri:(NSString *)requestUri andFrame:(CGRect)frame controller:(UIViewController *)controller
{
    self = [self initWithFrame:frame];
    self.scrollsToTop = NO;
    self.controller = controller;
    self.requestUri = requestUri;
    currentPageNo = 1;
    hasMore = YES;
    loading = YES;
    loadStatus = load_status_waiting_load;
    stylistes = [[NSMutableArray alloc] init];
    [self initFooterView];
    [self initTableView];
    [self loadStylist];
    return self;
}

-(void)updataTableView:(NSNotification *)info{
    currentPageNo = 1;
    hasMore = YES;
    [stylistes removeAllObjects];
    [self loadStylist];
}

-(void)initTableView
{
    CGRect frame = self.stylistTableView.frame;
    frame.origin.y = 0;
    frame.size.height = self.frame.size.height;
    self.stylistTableView.frame = frame;
    self.stylistTableView.scrollsToTop = YES;
    self.stylistTableView.delegate = self;
    self.stylistTableView.dataSource = self;
    [self.stylistTableView registerClass:[StylistTableCell class] forCellReuseIdentifier:@"StylistTableCell"];
}

-(void)loadStylist
{
    BOOL networkConnected = [AppStatus sharedInstance].networkStatus;
    //不通
    if (networkConnected == NotReachable) {
        if (currentPageNo == 1) {
            [self updataStatuas:load_status_first_not_network];
        }else
        {
            [self updataStatuas:load_status_not_network];
        }
    }else//通
    {
        if (hasMore) {
            [self updataStatuas:load_status_loading];
            NSString *url = [self.requestUri stringByAppendingFormat:@"&pageNo=%d",currentPageNo];
            
            StylistStore *stylistStore = [StylistStore sharedStore];
            [stylistStore getStylist:^(Page *page, NSError *err) {
                if (err == nil) {
                    currentPageNo += 1;
                    [stylistes addObjectsFromArray:page.items];
                    if ([page isLastPage]) {
                        [self updataStatuas:load_status_no_more];
                    }else{
                        [self updataStatuas:load_status_waiting_load];
                    }
                    [self.stylistTableView reloadData];
                }else//网络异常
                {
                    if (currentPageNo == 1) {
                        [self updataStatuas:load_status_request_first_fail];
                    }else{
                        [self updataStatuas:load_status_request_fail];
                    }
                }
            } uriStr:url refresh:NO];
        }
    }
}

-(void)updataStatuas:(int)theLoadStatus
{
    footerView.hidden = YES;
    reloadBtn.hidden = YES;
    loadStatus = theLoadStatus;
    switch (loadStatus) {
        case load_status_first_not_network://1
            //显示大icon
            if (reloadBtn == nil) {
                [self unConnectionNetwork];
            }
            [reloadBtn setHidden:NO];
            break;
        case load_status_not_network:  //2
            [footerView setHidden:NO];
            //状态行提示网络不通，稍后尝试
            [self updateFooterViewLayout:network_unconnect_note indicatorHide:NO animating:NO];
            break;
        case load_status_request_fail: //3
            [footerView setHidden:NO];
            [self updateFooterViewLayout:network_request_fail indicatorHide:NO animating:NO];
            break;
        case load_status_no_more:  //4
            hasMore = NO;
            [footerView setHidden:NO];
            [self updateFooterViewLayout:network_status_no_more indicatorHide:YES animating:NO];
            break;
        case load_status_loading:  //5
            [footerView setHidden:NO];
            [self updateFooterViewLayout:network_status_loading indicatorHide:NO animating:YES];
            break;
        case load_status_request_first_fail://6
            if (reloadBtn == nil) {
                [self unConnectionNetwork];
            }
            reloadBtn.hidden = NO;
            break;
        default:
            break;
    }
}

-(void)initFooterView
{
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, tableviewcellheight)];
    footerView.backgroundColor = [UIColor clearColor];
    
    loadStatusLabel = [[UILabel alloc] init];
    loadStatusLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    loadStatusLabel.font = [UIFont systemFontOfSize:default_font_size];
    [footerView addSubview:loadStatusLabel];
    
    loadStatusIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadStatusIndicator setHidesWhenStopped:NO];
    [footerView addSubview:loadStatusIndicator];
    
    [self updateFooterViewLayout:network_status_loading indicatorHide:NO animating:YES];
}

-(void)updateFooterViewLayout:(NSString *)labelTxt
                indicatorHide:(BOOL)indicatorHide animating:(BOOL)animating
{
    [loadStatusIndicator setHidden:indicatorHide];
    if (animating) {
        [loadStatusIndicator startAnimating];
    }else{
        [loadStatusIndicator stopAnimating];
    }
    
    float indicatorWidth = loadStatusIndicator.frame.size.width;
    float space = 5.0;
    loadStatusLabel.text = labelTxt;
    
    CGSize labelSize = [loadStatusLabel.text sizeWithFont:loadStatusLabel.font constrainedToSize:CGSizeMake(300, indicatorWidth) lineBreakMode:NSLineBreakByCharWrapping];
    float labelWidth = labelSize.width;
    
    
    if(!indicatorHide){
        float totalWidth = labelWidth + indicatorWidth + space;
        float y = (tableviewcellheight - indicatorWidth)/2;
        float x = (screen_width - totalWidth)/2;
    
        CGRect frame = loadStatusIndicator.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        loadStatusIndicator.frame = frame;
    
        x = frame.origin.x + indicatorWidth + space;
        frame.origin.x = x;
        frame.size.width = labelWidth;
        frame.size.height = indicatorWidth;
        loadStatusLabel.frame = frame;
    }else{
        float totalWidth = labelWidth;
        float y = (tableviewcellheight - indicatorWidth)/2;
        float x = (screen_width - totalWidth)/2;
        CGRect frame = loadStatusLabel.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        frame.size.width = labelWidth;
        frame.size.height = indicatorWidth;
        loadStatusLabel.frame = frame;
    }
}

-(void)unConnectionNetwork
{
    reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.frame = CGRectMake((self.frame.size.width-220)/2, 130 - self.frame.origin.y, 220, 156);
    [reloadBtn setImage:[UIImage imageNamed:@"network_disconnect_icon"] forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(loadStylist) forControlEvents:UIControlEventTouchUpInside];
    
    networkLable = [[UILabel alloc]initWithFrame:CGRectMake(20, reloadBtn.frame.origin.y + 10, reloadBtn.frame.size.width, 100)];
    networkLable.textColor = [ColorUtils colorWithHexString:gray_text_color];
    networkLable.font = [UIFont systemFontOfSize:default_font_size];
    networkLable.text = network_request_fail;
    [reloadBtn addSubview:networkLable];
    [self addSubview:reloadBtn];
}

#pragma mark --- dataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stylistes.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableviewcellheight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == stylistes.count){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell addSubview:footerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString * cellIndentifier = @"StylistTableCell";
    StylistTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    Stylist *stylist = [stylistes objectAtIndex:indexPath.row];
    [cell renderStylistInfo:stylist];
    
    if (stylist.dataStatus == stylist_data_status_open) {
        if (stylist.jobTitle == nil) {
            stylist.jobTitle = @"";
        }
        cell.gotoNext.hidden = NO;
        cell.scoreView.hidden = NO;
        cell.haircutPriceAndWorkNum.hidden = NO;
        cell.line.hidden = NO;
        cell.workCount.hidden = NO;
        cell.outOfStack.hidden = YES;
        cell.deleteBtn.hidden = YES;
        float alpha = 1.0;
        cell.stylistName.alpha = alpha;
        cell.stylistAvatar.alpha = alpha;
    }else if(stylist.dataStatus == stylist_data_status_out_of_stack){
        cell.gotoNext.hidden = YES;
        cell.scoreView.hidden = YES;
        cell.haircutPriceAndWorkNum.hidden = YES;
        cell.line.hidden = YES;
        cell.workCount.hidden = YES;
        cell.outOfStack.hidden = NO;
        cell.deleteBtn.hidden = NO;
        
        currentRow = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        float alpha = 0.6;
        cell.stylistName.alpha = alpha;
        cell.stylistAvatar.alpha = alpha;
    }
    
    CGRect separatorFrame =  cell.grayLine.frame;
    if (indexPath.row == (stylistes.count-1)) {
        separatorFrame.origin.x = 0;
    }
    else
    {
        separatorFrame.origin.x = 10;
    }
    cell.grayLine.frame = separatorFrame;
    
    return cell;
}
//删除下架发型师
-(void)deleteBtnClick{
    
    Stylist *stylist = [stylistes objectAtIndex:currentRow];
    AppStatus *appStatus = [AppStatus sharedInstance];
    [[UserStore sharedStore] removeFavstylist:^(NSError *err){
        if (err == nil) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功" duration:1.0];
            [appStatus.user removeFavStylist:stylist.id];
            [stylistes removeObjectAtIndex:currentRow];
            [ self.stylistTableView setEditing: NO animated: YES ];
            [ self.stylistTableView reloadData];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @(stylist.id), @"发型师id", nil];
            [MobClick event:log_event_name_remove_fav_stylist attributes:dict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remove_out_of_stack_stylist" object:nil];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"删除失败" duration:1.0];
        }
    }userId:[appStatus.user.idStr intValue] stylistId:stylist.id];
    
}
/*
//左滑删除下架发型师
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Stylist *stylist = [stylistes objectAtIndex:indexPath.row];
        AppStatus *appStatus = [AppStatus sharedInstance];
        [[UserStore sharedStore] removeFavstylist:^(NSError *err){
             if (err == nil) {
                 [SVProgressHUD showSuccessWithStatus:@"删除成功" duration:1.0];
                 [appStatus.user removeFavStylist:stylist.id];
                 [stylistes removeObjectAtIndex:indexPath.row];
                 [tableView setEditing: NO animated: YES ];
                 [tableView reloadData];
                 
                 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @(stylist.id), @"发型师id", nil];
                 [MobClick event:log_event_name_remove_fav_stylist attributes:dict];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"remove_out_of_stack_stylist" object:nil];
             }else
             {
                 [SVProgressHUD showErrorWithStatus:@"删除失败" duration:1.0];
             }
         }userId:[appStatus.user.idStr intValue] stylistId:stylist.id];
    }
}
*/
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == stylistes.count) {
//        return UITableViewCellEditingStyleNone;
//    }
//    Stylist *stylist = [stylistes objectAtIndex:indexPath.row];
//    if (self.stylerType == my_fav_styler_type && stylist.dataStatus == stylist_data_status_out_of_stack){
//        return UITableViewCellEditingStyleDelete;
//    }
//    
//    return UITableViewCellEditingStyleNone;
//}

#pragma mark -----delegate-  --
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != stylistes.count) {
        Stylist * stylist = [stylistes objectAtIndex:[indexPath row]];
        if (stylist.dataStatus != stylist_data_status_open) {
            [SVProgressHUD showWithStatus:@"此发型师已下架，请点击删除此发型师" maskType:SVProgressHUDMaskTypeNone duration:2];
            self.stylistTableView.userInteractionEnabled = NO;
            return ;
        }

        StylistProfileController *stylistProfileController = [[StylistProfileController alloc]init];
        stylistProfileController.stylist = stylist;
        [self.controller.navigationController pushViewController:stylistProfileController animated:YES];
        
        [MobClick event:log_event_name_goto_stylist_profile attributes:[NSDictionary dictionaryWithObjectsAndKeys:stylist.name, @"发型师名字",nil]];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height){
        if (hasMore && loadStatus != load_status_loading) {
            [self loadStylist];
        }
    }
}


@end
