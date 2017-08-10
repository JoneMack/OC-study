//
//  TabBarItem.h
//  CustomTabbarControllerDemo
//
//  Created by aypc on 13-11-1.
//  Copyright (c) 2013年 aypc. All rights reserved.
//

@protocol TabBarItemDelegate <NSObject>

-(void)clickTabBarItem:(int)index;

@end

#import <UIKit/UIKit.h>

@interface TabBarItem : UIView
{
    UIImage * defaultImage;
    UIImage * selectedImage;
    
}
@property (strong, nonatomic) id<TabBarItemDelegate> delegate;
@property (weak, nonatomic) NSString * title;
@property BOOL isSelected;
@property int index;
@property (weak, nonatomic) IBOutlet UIImageView *tabBarIcon;
@property (weak, nonatomic) IBOutlet UILabel *tabBarTitle;
@property (weak, nonatomic) IBOutlet UIButton *tabBarButton;
-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withIconImages:(NSArray*)imageArray withItemIndex:(int)index;
-(void)addRemindIcon;
-(void)removeRemindIcon;
-(void)setSelect:(BOOL)select;
@end
