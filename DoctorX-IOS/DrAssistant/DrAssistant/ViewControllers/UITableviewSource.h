//
//  UITableviewSource.h
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^didSeletedBlock)(NSInteger);

//@protocol TableviewManagerDelegate <NSObject>
//
//- (NSInteger)numberOfrowsInSection:(NSInteger)section;
//- (UITableViewCell *)tableview:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//
//@optional
//- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
//
//@end

@interface UITableviewSource : NSObject<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic,assign)id<TableviewManagerDelegate> delegete;

@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,copy) didSeletedBlock selectedIndex;

@end
