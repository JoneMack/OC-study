//
//  MyOrderedLookController.m
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MyOrderedLookController.h"
#import "MyCollectionCell.h"
@interface MyOrderedLookController ()

@end
static NSString *myCollectionCellIdentifier = @"unFnishLookCell";
@implementation MyOrderedLookController
-(instancetype)initWithOrderedLookSelectBtn:(UIButton *)btn navigationController:(UINavigationController *)navigationController{
    self = [super init];
    if (self) {
        self.selectBtn = btn;
        self.navigationController = navigationController;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initTopSegView];
    self.view.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
}

- (void)initTopSegView{
    self.topSegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    self.topSegView.backgroundColor = [ColorUtils colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:self.topSegView];
    
    UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50-splite_line_height, screen_width, splite_line_height)];
    downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self.topSegView addSubview:downSpeliteLine];
    
    self.currentType = @[@"进行中的约看"];
    [self initCustomSegmentView];
    [self selectMyOrderedLookSegmentView:0];
}

-(void)initCustomSegmentView
{
    NSArray *btnTitleArray = [[NSArray alloc] initWithObjects:@"进行中的约看",@"已完成的约看", nil];
    self.myOrderedLookSegmentView = [[MyOrderedLookSegmentView alloc] initWithFrame:CGRectMake((75)/2, 10, screen_width-75, 30)];
    self.myOrderedLookSegmentView.layer.cornerRadius = 5;
    self.myOrderedLookSegmentView.layer.masksToBounds = YES;
    self.myOrderedLookSegmentView.layer.borderWidth = splite_line_height;
    self.myOrderedLookSegmentView.layer.borderColor = [ColorUtils colorWithHexString:splite_line_color].CGColor;
    [self.myOrderedLookSegmentView render:btnTitleArray currentIndex:[self getSelectIndex]];
    self.myOrderedLookSegmentView.delegate = self;
    self.myOrderedLookSegmentView.backgroundColor = [ColorUtils colorWithHexString:white_text_color];
    [self.topSegView addSubview:self.myOrderedLookSegmentView];
}

-(int)getSelectIndex{
    if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"进行中的约看", nil]]) {
        NSLog(@">>>>>>>>>>>进行中的约看>>>>>>>>>>");
        return 0;
        
    }else if ([self.currentType isEqualToArray:[[NSArray alloc] initWithObjects:@"已完成的约看", nil]]) {
        NSLog(@">>>>>>>>>>>>已完成的约看>>>>>>>>>>>>>");
        return 1;
    }
    return 0;
    
}

-(void)selectMyOrderedLookSegmentView:(int)inx
{
    NSLog(@">>>>当前选择>>>>>>>%d",inx);
    switch (inx) {
        case 0:{
            [self.finishLookViewController.view removeFromSuperview];
            self.lookingUnFinishViewController = [[LookingUnFinishViewController alloc] initWithSelectBtn:self.selectBtn navigationController:self.navigationController];
            self.lookingUnFinishViewController.view.frame = CGRectMake(0, self.myOrderedLookSegmentView.frame.origin.y+self.myOrderedLookSegmentView.frame.size.height, screen_width,screen_height-64-45-self.myOrderedLookSegmentView.frame.size.height-10);
            [self.selectBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.view addSubview:self.lookingUnFinishViewController.view];

        }
            break;
        case 1:{
            [self.lookingUnFinishViewController.view removeFromSuperview];
            self.finishLookViewController = [[FinishLookViewController alloc] initWithSelectBtn:self.selectBtn navigationController:self.navigationController];
            self.finishLookViewController.view.frame = CGRectMake(0, self.myOrderedLookSegmentView.frame.origin.y+self.myOrderedLookSegmentView.frame.size.height, screen_width,screen_height-64-45-self.myOrderedLookSegmentView.frame.size.height-10);
            [self.selectBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.view addSubview:self.finishLookViewController.view];

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
