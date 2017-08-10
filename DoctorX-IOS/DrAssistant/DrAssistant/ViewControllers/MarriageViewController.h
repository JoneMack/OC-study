//
//  MarriageViewController.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/12.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^marriedButtonBlock)(NSInteger); ;

@interface MarriageViewController : UIViewController

@property (nonatomic,assign)NSInteger marrIndex;
@property (nonatomic,copy)marriedButtonBlock marredBlock;

@end
