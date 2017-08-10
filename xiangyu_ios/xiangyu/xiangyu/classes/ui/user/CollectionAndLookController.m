//
//  MyCollectionController.m
//  xiangyu
//
//  Created by xubojoy on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "CollectionAndLookController.h"

@interface CollectionAndLookController ()

@end

@implementation CollectionAndLookController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    [self initHeaderView];
    self.currentType = @[@"我的收藏"];
    [self initCustomSegmentView];
    [self selectXBSegmentView:0];
}

- (void)initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"收藏约看" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    self.headerView.userInteractionEnabled = YES;
    [self.view addSubview:self.headerView];
//    self.navigationController.navigationBarHidden = NO;
//     self.navigationController.navigationBar.barTintColor = [ColorUtils colorWithHexString:bg_purple];
//    
//    self.title = @"收藏约看";
//     NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    
//    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backBtn.frame = CGRectMake(0, 20, 44, 44);
//    [self.backBtn setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
////    self.backBtn.backgroundColor = [UIColor orangeColor];
//    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
//    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    //选择按钮
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.editButtonItem.title = @"编辑";
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedBtn.frame = CGRectMake(screen_width-60-10, 20, 60, 44);
    [self.selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.selectedBtn setTitleColor:[ColorUtils colorWithHexString:@"#c48ccc"] forState:UIControlStateNormal];
    [self.view addSubview:self.selectedBtn];
}

-(void)initCustomSegmentView
{
    NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"我的收藏",@"我的约看", nil];
    self.xbSegmentView = [[XBSegmentView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 45)];
    [self.xbSegmentView render:btnTitleArray currentIndex:[self getSelectIndex]];
    self.xbSegmentView.delegate = self;
    self.xbSegmentView.backgroundColor = [ColorUtils colorWithHexString:white_text_color];
    
    UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45-splite_line_height, screen_width, splite_line_height)];
    downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.xbSegmentView addSubview:downSpeliteLine];
    [self.view addSubview:self.xbSegmentView];
}

-(int)getSelectIndex{
    if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"我的收藏", nil]]) {
        NSLog(@">>>>>>>>>>>我的收藏>>>>>>>>>>");
        return 0;
        
    }else if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"我的约看", nil]]) {
        NSLog(@">>>>>>>>>>>>我的约看>>>>>>>>>>>>>");
        return 1;
    }
    return 0;
}

-(void)selectXBSegmentView:(int)inx
{
    NSLog(@">>>>当前选择>>>>>>>%d",inx);
    switch (inx) {
        case 0:{
            [self.myOrderedLookController.view removeFromSuperview];
            self.myCollectionController = [[MyCollectionController alloc] initWithSelectBtn:self.selectedBtn navigationController:self.navigationController];
            self.myCollectionController.view.frame = CGRectMake(0, self.xbSegmentView.frame.origin.y+self.xbSegmentView.frame.size.height, screen_width,screen_height-self.headerView.frame.size.height-45);
            [self.selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.view addSubview:self.myCollectionController.view];
        }
            break;
        case 1:{
            [self.myCollectionController.view removeFromSuperview];
            self.myOrderedLookController = [[MyOrderedLookController alloc] initWithOrderedLookSelectBtn:self.selectedBtn navigationController:self.navigationController];
            
            self.myOrderedLookController.view.frame = CGRectMake(0, self.xbSegmentView.frame.origin.y+self.xbSegmentView.frame.size.height, screen_width,screen_height-self.headerView.frame.size.height-45);
            [self.selectedBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.view addSubview:self.myOrderedLookController.view];
        }
            break;
        default:
            break;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
