//
//  Circle.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "Circle.h"

@implementation Circle


-(NSArray<Circle *> *) getChildren{
    
    NSArray<Circle *> *children = [Circle arrayOfModelsFromDictionaries:self.children];
    return children;
    
}

@end
