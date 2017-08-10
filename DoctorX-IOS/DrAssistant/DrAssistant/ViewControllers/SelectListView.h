//
//  SelectListView.h
//  DrAssistant
//
//  Created by hi on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectBlock)(NSInteger index);

@protocol SelectListViewDelegate <NSObject>

- (void)didSelectAtIndex:(NSInteger)index;

@end

@interface SelectListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, assign) id<SelectListViewDelegate>delegate;

+ (instancetype)selectListView;

@end
