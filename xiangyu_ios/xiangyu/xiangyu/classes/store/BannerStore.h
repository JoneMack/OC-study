//
//  BannerStore.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/20.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Banner.h"

@interface BannerStore : NSObject

+ (BannerStore *) sharedStore;


//http://mtest.1zu.com:8080/api/advertMapService/advertMapList?deviceType=ios&deviceID=9205faaa171002410180c680c004a5152bf657af&token=&id=&verion=1.0&locationStr=10100110001

-(void) getBanners:(void(^)(NSArray<Banner *> *banners, NSError *err))completionBlock locationStr:(NSString *)locationStr;





@end
