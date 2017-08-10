//
//  SystemNoticeController.m
//  styler
//
//  Created by System Administrator on 13-6-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "SystemNoticeController.h"
#import "SystemNoticeCell.h"
#import "NoticeStore.h"
#import "Notice.h"
#import "PushProcessor.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"

@interface SystemNoticeController ()

@end

@implementation SystemNoticeController
{
    HeaderView *header;
}
static NSString *noticeCellIdentifier = @"noticeCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];

    [self initHeader];
    //[self initNoticeTableView];
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:page_name_notice navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}


-(void) initNoticeTableView{
    int height = self.view.frame.size.height - header.frame.size.height;
    height = (self.notices.count*66 < height)?self.notices.count*66:height;
    CGRect noticeTableFrame = CGRectMake(0, header.frame.size.height, self.view.frame.size.width,height);
    self.systemNoticeTableView.frame = noticeTableFrame;
    self.systemNoticeTableView.delegate = self;
    self.systemNoticeTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"SystemNoticeCell" bundle:nil];
    [self.systemNoticeTableView registerNib:nib forCellReuseIdentifier:noticeCellIdentifier];

    [SVProgressHUD showWithStatus:network_status_loading];
    [[NoticeStore sharedStore] getNotices:^(NSArray *notices, NSError *err) {
        self.notices = notices;
        [self.systemNoticeTableView reloadData];
        [SVProgressHUD dismiss];
        [[PushProcessor sharedInstance] checkUnreadNoticePush];
    } refresh:[[PushProcessor sharedInstance] noticePushNum]>0?YES:NO];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.notices count];
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Notice *notice = [self.notices objectAtIndex:indexPath.row];
    
    UIFont *contentFont = [UIFont systemFontOfSize:15.0];
    CGSize size = CGSizeMake(310, 2000);
    CGSize contentSize = [notice.content sizeWithFont:contentFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize.height+35>81?(contentSize.height+35):81;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:noticeCellIdentifier];
    if(cell == nil){
        cell = [[SystemNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noticeCellIdentifier];
    }
    UIImage *img = [UIImage loadImageWithImageName:@"list_bg"];
    
    UIEdgeInsets keepCorner = UIEdgeInsetsMake(40, 0, 40, 0);
    img = [img resizableImageWithCapInsets:keepCorner];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:img];
    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    Notice *notice = [self.notices objectAtIndex:indexPath.row];
    
    UIFont *contentFont = [UIFont systemFontOfSize:15.0];
    CGSize size = CGSizeMake(310, 2000);
    CGSize contentSize = [notice.content sizeWithFont:contentFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.content.text = notice.content;
    cell.content.numberOfLines = 0;
    cell.content.textColor = [ColorUtils colorWithHexString:gray_text_color];
    cell.content.frame = CGRectMake(5, 5, 310, contentSize.height);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M月dd日 HH:mm"];
    cell.createTime.text = [dateFormatter stringFromDate:notice.createTime];
    cell.createTime.textColor = [ColorUtils colorWithHexString:gray_text_color];
    cell.createTime.frame = CGRectMake(200, contentSize.height+10, 107, 20);
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

-(NSString *)getPageName{
    return page_name_notice;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSystemNoticeTableView:nil];
    [super viewDidUnload];
}

@end
