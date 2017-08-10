//
//  BindingSocailAccountController.m
//  styler
//
//  Created by aypc on 13-11-22.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "BindingSocailAccountController.h"
#import "ImageUtils.h"
#import "BindingSocailAccountTableViewCell.h"
#import "SocialShareStore.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import "Toast+UIView.h"
#import "ShareSDKProcessor.h"

@interface BindingSocailAccountController ()

@end

@implementation BindingSocailAccountController

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
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initBindingTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:notification_name_social_account_status_changed object:nil];
}

-(void)initHeader
{
    self.header = [[HeaderView alloc]initWithTitle:page_name_bing_socail_account navigationController:self.navigationController];
    [self.view addSubview:self.header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

-(void)initBindingTableView
{
    bindingArray = [[NSArray alloc]initWithObjects:[NSArray arrayWithObjects:@"binding_sina_weibo",@"新浪微博",binding_sina_weibo_key, nil], nil];
    self.tableView.frame = CGRectMake(0, self.header.frame.size.height + general_margin, screen_width, general_cell_height* bindingArray.count);
    self.tableView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.tableView.separatorColor = [ColorUtils colorWithHexString:backgroud_color];
    [self.tableView addStrokeBorderWidth:0.5 cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark --- dataSourse--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bindingArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return general_cell_height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = @"cellIndentifier";
    BindingSocailAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[BindingSocailAccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    int value = [[NSUserDefaults standardUserDefaults] boolForKey:[[bindingArray objectAtIndex:indexPath.row] objectAtIndex:2]];
    if (value) {
        cell.iconImage.image = [UIImage loadImageWithImageName:[NSString stringWithFormat:@"%@_default",[[bindingArray objectAtIndex:indexPath.row] objectAtIndex:0]]];
        cell.title.textColor = [ColorUtils colorWithHexString:gray_text_color];
        text = @"已绑定";
    }else
    {
        cell.iconImage.image = [UIImage loadImageWithImageName:[NSString stringWithFormat:@"%@_selected",[[bindingArray objectAtIndex:indexPath.row] objectAtIndex:0]]];
        cell.title.textColor = [ColorUtils colorWithHexString:gray_text_color];
        text = @"未绑定";
    }

    cell.title.text = [[bindingArray objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.isBingding.text = text;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
    line.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [cell addSubview:line];
    return cell;
}

#pragma mark ---- delegate --- 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self clickWeibo:nil];
            
            [MobClick event:log_event_name_share_to_sina_weibo attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"微博分享", @"分享",nil]];
            break;
        case 1:
//            [self clickTencentWeibo:nil];
            break;
        case 2:    
            break;
        default:
            break;
    }
}

- (void)clickWeibo:(id)sender {
    if ([text isEqualToString:@"已绑定"])
    {
        //取消绑定
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"是否解除绑定" message:Nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        [ShareSDK ssoEnabled:YES];
        [ShareSDK authWithType:ShareTypeSinaWeibo                                   //需要授权的平台类型
                       options:nil                                                  //授权选项，包括视图定制，自动授权
                        result:^(SSAuthState state, id<ICMErrorInfo> error) {       //授权返回后的回调方法
        if (state == SSAuthStateSuccess)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:binding_sina_weibo_key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:binding_sina_weibo_key object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_social_account_status_changed object:nil];
            //绑定新浪微博账号
            [ShareSDKProcessor followSinaWeiBo];
            
        }
        else if (state == SSAuthStateFail)
        {
            NSLog(@"失败");
        }
        }];
    }
    [self.tableView reloadData];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //怎么取消关联？？
        [ShareSDK ssoEnabled:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:binding_sina_weibo_key];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_social_account_status_changed object:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:binding_sina_weibo_key object:nil];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_bing_socail_account;
}

@end
