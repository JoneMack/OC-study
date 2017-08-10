//
//  UserMainView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMainView : UIView < UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *mainTableView;
@property (nonatomic , strong) UINavigationController *navigationController;

-(id) initWithNavigationController:(UINavigationController *)navigationController frame:(CGRect) frame;

@end


@interface UserMainCellView : UITableViewCell

@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UIView *upSeparatorLine;
@property (nonatomic , strong) UIView *downSeparatorLine;

-(id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

-(void) fillIconAndTitle:(NSString *)iconName title:(NSString *)title firstCell:(BOOL)firstCell lastCell:(BOOL)lastCell;

@end
