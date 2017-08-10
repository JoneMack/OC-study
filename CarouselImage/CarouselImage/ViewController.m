//
//  ViewController.m
//  CarouselImage
//
//  Created by xubojoy on 2017/3/8.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "ViewController.h"
#import "CDCycleView.h"
@interface ViewController ()<CDCycleViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imagePathsGroup = [NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg", nil];

    [self initCDCycleView];
}

- (void)initCDCycleView{
    CDCycleView *cycleScrollView4 = [CDCycleView cycleScrollViewWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 100) delegate:self placeholderImage:nil];
    cycleScrollView4.imagePathsGroup = self.imagePathsGroup;
    
    [self.view addSubview:cycleScrollView4];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
