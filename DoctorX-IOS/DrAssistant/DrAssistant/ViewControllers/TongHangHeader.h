//
//  TongHangHeader.h
//  DrAssistant
//
//  Created by hi on 15/9/13.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MyTongHangHeaderBtnTag) {
    
    addTonghangTag = 1000,
    qunFaXIaoXiTag = 1001,
    myQunLiaoTag = 1002,
    addHuiZhenTag = 1003,
    jieZhenTag = 1004,
    goodDocTag = 1005,
};

@protocol MyTongHangHeaderDelegate  <NSObject>

- (void)MyTongHangHeaderAction:(UIButton *)btn;
- (void)creatNewGroup;

@end

typedef void(^BtnActionBlock)(UIButton *btn);

@interface TongHangHeader : UIView
@property (weak, nonatomic) IBOutlet UISearchBar *searchNar;
@property (weak, nonatomic) IBOutlet UIButton *addTonghang;
@property (weak, nonatomic) IBOutlet UIButton *myQunLiao;

@property (weak, nonatomic) IBOutlet UIButton *qunFaXIaoXi;
@property (weak, nonatomic) IBOutlet UIButton *jieZhen;
@property (weak, nonatomic) IBOutlet UIButton *addHuiZhen;
@property (weak, nonatomic) IBOutlet UIButton *goodDoc;

@property (copy, nonatomic) BtnActionBlock block;

@property (weak, nonatomic) id<MyTongHangHeaderDelegate>delegate;


+ (instancetype)tongHangHeader;


@end
