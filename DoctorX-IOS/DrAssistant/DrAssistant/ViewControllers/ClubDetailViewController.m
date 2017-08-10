//
//  ClubDetailViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ClubDetailViewController.h"
#import "SegmentContainerController.h"
#import "SchoolIntroDuceController.h"
#import "ZhuanJiaListViewController.h"
#import "HealthStateViewController.h"
#import "AddHeahthDataController.h"
#import "RecordViewController.h"
#import "CaseDetailViewController.h"
@interface ClubDetailViewController ()<YSLContainerViewControllerDelegate>
@property (strong, nonatomic) SegmentContainerController *containerVC;
@end

@implementation ClubDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Key_AddHeathDataSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.ClubInfo.clubName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumbToHeathDataVC) name:Key_AddHeathDataSuccess object:nil];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addHealthDataBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewHealthDataAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;

    
    // ContainerView
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    SchoolIntroDuceController *sVC = [SchoolIntroDuceController simpleInstance];
    sVC.ClubInfo = self.ClubInfo;
    sVC.title = @"中心介绍";
    ZhuanJiaListViewController *zVC = [ZhuanJiaListViewController simpleInstance];
    zVC.ClubInfo = self.ClubInfo;
    zVC.title = @"中心专家";
    HealthStateViewController *hVC = [HealthStateViewController simpleInstance];
    hVC.ClubInfo = self.ClubInfo;
    NSArray *vcs=[[NSArray alloc]init];
    if([self.ClubInfo.ID isEqualToString:@"1"]){
        hVC.title = @"我的血压";
        vcs = @[sVC, zVC,hVC];
    }else if([self.ClubInfo.ID isEqualToString:@"2"]){
        hVC.title = @"我的血糖";
        vcs = @[sVC, zVC,hVC];
    }else if ([self.ClubInfo.ID isEqualToString:@"3"]){
        hVC.title = @"我的血氧";
        vcs = @[sVC, zVC,hVC];
    }else if ([self.ClubInfo.ID isEqualToString:@"4"]){
        RecordViewController * rVC=[RecordViewController simpleInstance];
        rVC.title = @"我的病历";
        vcs = @[sVC, zVC,rVC];
    }
    _containerVC = [[SegmentContainerController alloc]initWithControllers:vcs
                                
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    _containerVC.delegate = self;
    
    UIColor *nor_color = COLOR(0, 174, 191, 1.0);
    _containerVC.menuIndicatorColor = nor_color;
    _containerVC.menuItemTitleColor = [UIColor blackColor];
    _containerVC.menuItemSelectedTitleColor = nor_color;
    
    [self.view addSubview:_containerVC.view];
    
}

- (void)jumbToHeathDataVC
{
    NSLog(@"jumbToHeathDataVC:");
//    HealthStateViewController *hV = [_containerVC.childControllers safeObjectAtIndex: 2];
//    
//    if (hV) {
//        [hV getUserData];
//    }
}


- (void)addNewHealthDataAction
{
    if (![self.ClubInfo.ID isEqualToString:@"4"]) {
        AddHeahthDataController *addVC =  [AddHeahthDataController simpleInstance];
        addVC.myClub = self.ClubInfo;
        [self.navigationController pushViewController: addVC animated:YES];
    }else{
        CaseDetailViewController *addVC =  [CaseDetailViewController simpleInstance];
        addVC.ClubInfo= self.ClubInfo;
        [self.navigationController pushViewController: addVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
        
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
