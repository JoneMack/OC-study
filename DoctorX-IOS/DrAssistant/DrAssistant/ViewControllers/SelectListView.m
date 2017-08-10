//
//  SelectListView.m
//  DrAssistant
//
//  Created by hi on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "SelectListView.h"

@implementation SelectListView

+ (instancetype)selectListView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SelectListView" owner:nil options:nil] lastObject];
}

- (void)showOnView:(UIView*)spView withArr:(NSArray *)arr didSelctAtIndex:(didSelectBlock)block
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
        
        [_delegate didSelectAtIndex: indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 35;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
