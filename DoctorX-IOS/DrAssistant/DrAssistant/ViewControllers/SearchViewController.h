//
//  SearchViewController.h
//  DrAssistant
//
//  Created by hi on 15/9/14.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SearchType) {

    SearchPatient = 1,
    SearchDoctor = 2,
    searchTongHang = 3,
    
};

@interface SearchViewController : BaseViewController

@property (nonatomic,assign) SearchType searchType;
@property (nonatomic,assign) NSString *isPatOrDoc;

@property (nonatomic,assign) NSString *isFree;

@property (nonatomic,assign) NSMutableArray *reciveGroupArray;
@end
