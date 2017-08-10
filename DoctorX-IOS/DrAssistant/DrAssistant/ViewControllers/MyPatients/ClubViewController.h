//
//  ClubViewController.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/21.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ClubViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) NSMutableArray *tmpArray;

@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSMutableArray *sortUserArray;
@property (strong, nonatomic)  NSArray * sortArray;
@property (nonatomic, strong) NSMutableArray *onlyPhoneArray;

@property (strong, nonatomic)  NSMutableDictionary * resultSortDict;
@property (nonatomic, strong) NSMutableDictionary *friendNameDic;
@property (nonatomic, strong) NSMutableDictionary *friendIdDic;

@property (nonatomic, strong) NSMutableDictionary *friendThumbDic;
@end
