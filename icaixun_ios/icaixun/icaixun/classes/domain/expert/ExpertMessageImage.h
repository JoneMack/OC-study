//
//  ExpertMessageImage.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 专家发送消息里的图片
 */
@interface ExpertMessageImage : JSONModel
//
@property (nonatomic , assign) int id;
@property (nonatomic , assign) int expertMassageId;
@property (nonatomic , copy) NSString *url;
@property (nonatomic , assign) long long int createTime;;

@end
