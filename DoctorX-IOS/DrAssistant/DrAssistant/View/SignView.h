//
//  SignView.h
//  TableviewController
//
//  Created by 刘亮 on 19/5/15.
//  Copyright (c) 2015年 liuliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapProtocol <NSObject>

- (void)customBtnAction:(NSInteger)index;

@end

typedef NSInteger(^tapAction)(NSInteger);

@interface SignView : UIView

@property (nonatomic,copy) tapAction customButtonAction;
@property (nonatomic,strong)NSString *infoText;
@property (nonatomic,strong)NSString *imageName;
@property (nonatomic,assign)id<tapProtocol> delegete;

@end
