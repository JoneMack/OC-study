//
//  SignView.m
//  TableviewController
//
//  Created by 刘亮 on 19/5/15.
//  Copyright (c) 2015年 liuliang. All rights reserved.
//

#import "SignView.h"

@interface SignView ()
{
    UIImageView *logoView;
    CGRect selfFrame;
}
@end

@implementation SignView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        selfFrame = frame;
        [self initWithView:frame];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapAction
{
    if (_delegete && [_delegete respondsToSelector:@selector(customBtnAction:)]) {
        [_delegete customBtnAction:self.tag];
    }
}

- (id) init
{
    if (self == [super init]) {
        
    }
    return self;
}

- (void)initWithView:(CGRect)frame
{
    NSInteger width = frame.size.width;
    logoView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 58)/2, 13, 58, 58)];
    
    [self addSubview:logoView];
    
    
}


- (void)setInfoText:(NSString *)text
{
    CGSize textSize = [self getCGRectOfString:text].size;
    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.frame = CGRectMake((selfFrame.size.width - textSize.width)/2, logoView.frame.origin.y + logoView.frame.size.height + 8, textSize.width, 21);
    logoLabel.text = text;
    logoLabel.font = [UIFont fontWithName:@"FZZhunYuan-M02S" size:15.0f];
    logoLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:logoLabel];
    [self setNeedsLayout];
}

- (void)setImageName:(NSString *)imageName
{
    logoView.image = [UIImage imageNamed:imageName];
}


- (CGRect)getCGRectOfString:(NSString *)str
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = CGSizeMake(self.frame.size.width,2000);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect resultRect = [str boundingRectWithSize:size options:options attributes:attributes context:nil];
    return resultRect;
}

@end
