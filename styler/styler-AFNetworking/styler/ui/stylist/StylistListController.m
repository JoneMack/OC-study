//
//  BusinessCirclesExpertController.m
//  styler
//
//  Created by System Administrator on 14-2-17.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistListController.h"
#import "StylistStore.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"
#import "UserStore.h"

@interface StylistListController ()

@end

@implementation StylistListController
{
    HeaderView *header;
}
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
    [self initStylistListView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataTableView:) name:notification_name_update_fav_stylist object:nil];
}
-(void)updataTableView:(NSNotification *)info{
    [self.stylistView updataTableView:info];
}

-(id)initWithRequestUrl:(NSString *)requestUrl title:(NSString *)title type:(int)stylerType{
    self = [self init];
    if (self) {
        self.requestUrl = requestUrl;
        self.title = title;
        self.stylerType = stylerType;
    }
    return self;
}

-(void)initHeader
{
    header = [[HeaderView alloc]initWithTitle:self.title navigationController:self.navigationController];
    [self.view addSubview:header];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}


-(void)initStylistListView
{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = header.frame.size.height + splite_line_height;
    frame.size.width = screen_width;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    self.stylistView = [[StylistView alloc] initWithRequestUri:self.requestUrl andFrame:frame controller:self];
    self.stylistView.backgroundColor = [UIColor whiteColor];
    self.stylistView.stylerType = self.stylerType;
    [self.view addSubview:self.stylistView];
}

-(NSString *)getPageName{
    return self.title;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
