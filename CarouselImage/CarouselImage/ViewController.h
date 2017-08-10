//
//  ViewController.h
//  CarouselImage
//
//  Created by xubojoy on 2017/3/8.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);
@property (nonatomic ,strong) NSArray *imagePathsGroup;
@end

