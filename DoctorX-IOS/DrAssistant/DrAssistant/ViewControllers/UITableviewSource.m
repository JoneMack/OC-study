//
//  UITableviewSource.m
//  DrAssistant
//
//  Created by 刘亮 on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "UITableviewSource.h"

@implementation UITableviewSource

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"en"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"en"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - delegete
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex(indexPath.row);
}

@end
