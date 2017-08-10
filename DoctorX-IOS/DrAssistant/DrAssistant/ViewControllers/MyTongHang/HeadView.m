//
//  HeadView.m
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "HeadView.h"

@interface HeadView()
{
    UIButton *_bgButton;
    UILabel *_numLabel;
}
@end

@implementation HeadView

+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"header";
    
    HeadView *headView = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
    if (headView == nil) {
        headView = [[HeadView alloc] initWithReuseIdentifier:headIdentifier];
    }
    
    return headView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [bgButton setImage:[UIImage imageNamed:@"group_arrow_down"] forState:UIControlStateNormal];
        bgButton.backgroundColor = [UIColor whiteColor];
        [bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgButton.imageView.contentMode = UIViewContentModeCenter;
        bgButton.imageView.clipsToBounds = NO;
        bgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        _bgButton = bgButton;
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-20-10, 10, 20, 20)];
        self.arrowImageView.image = [UIImage imageNamed:@"peer_left"];
        [bgButton addSubview:self.arrowImageView];
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = 1;
        numLabel.textColor = [UIColor lightGrayColor];
        numLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        [self addSubview:numLabel];
        _numLabel = numLabel;
    }
    return self;
}

- (void)headBtnClick
{
    _friendGroup.opened = !_friendGroup.isOpened;
    if ([_delegate respondsToSelector:@selector(clickHeadView)]) {
        [_delegate clickHeadView];
    }
}

- (void)setFriendGroup:(GroupInfoEntity *)friendGroup
{
    _friendGroup = friendGroup;
    
    [_bgButton setTitle:friendGroup.groupname forState:UIControlStateNormal];
    _numLabel.text = [NSString stringWithFormat:@"(%ld)",  friendGroup.friends.count];//friendGroup.online,
}

- (void)didMoveToSuperview
{
//    _bgButton.imageView.transform = _friendGroup.isOpened ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    self.arrowImageView.transform = _friendGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame = self.bounds;
    _numLabel.frame = CGRectMake(self.frame.size.width - 70, 0, 60, self.frame.size.height);
}

@end
