//
//  MovieModel.h
//  RuntimeTest
//
//  Created by xubojoy on 2017/11/29.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *title; /**< 电影名 */
@property (nonatomic, copy) NSMutableString *genres; /**< 电影种类 */

@end
