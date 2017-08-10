//
//  SearchHeader.h
//  DrAssistant
//
//  Created by hi on 15/9/14.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SearchHeaderTag)
{
//    chaXunTag = 10,
    QuYuTag = 10,
    YiYuanTag,
    KeShiTag,
};


@protocol SearchHeaderActionDelegate <NSObject>

- (void)searchHeaderclickAtbtn:(SearchHeaderTag )tag;

@end

@interface SearchHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *quYu;
@property (weak, nonatomic) IBOutlet UILabel *yiYuan;
@property (weak, nonatomic) IBOutlet UILabel *keShi;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *chaXunBtn;
@property (weak, nonatomic) IBOutlet UIView *v_QuYU;
@property (weak, nonatomic) IBOutlet UIView *v_KeShi;
@property (weak, nonatomic) IBOutlet UIView *v_YiYuan;
@property (weak, nonatomic) IBOutlet UILabel *listHeaderName;

@property (weak, nonatomic) id<SearchHeaderActionDelegate> delegate;

+ (instancetype)searchHeader;
@end
