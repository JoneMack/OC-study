//
//  MyAsNullHeader.m
//  DrAssistant
//
//  Created by taller on 15/9/26.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "MyAsNullHeader.h"

@implementation MyAsNullHeader

+ (instancetype)asNullHeader
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyAsNullHeader" owner:nil options:nil] lastObject];
}

@end
