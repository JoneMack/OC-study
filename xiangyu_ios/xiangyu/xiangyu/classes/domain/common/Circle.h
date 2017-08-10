//
//  Circle.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Circle
@end

@interface Circle : JSONModel

@property (strong , nonatomic) NSString *id;

@property (strong , nonatomic) NSString *text;

@property (strong , nonatomic) NSArray<Circle *> *children;

-(NSArray<Circle *> *) getChildren;

@end
