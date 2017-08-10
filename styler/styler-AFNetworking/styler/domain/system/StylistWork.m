//
//  ExpertWork.m
//  styler
//
//  Created by System Administrator on 13-7-20.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "StylistWork.h"
#import "CommonItemTxt.h"
#import "Constant.h"
#import "Tag.h"

@implementation StylistWork

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

-(ServicePicture *)getCover{
    if (self.cover == nil) {
        for (ServicePicture *picture in self.servicePictures) {
            if (picture.id == self.coverPictureId) {
                self.cover = picture;
                break;
            }
        }
    }
    return self.cover;
}

-(NSArray * )tidyComentItemContent:(NSArray *)array
{
    NSMutableArray * result = [[NSMutableArray alloc]init];
    CommonItemTxt * itemDetail = [array objectAtIndex:0];
    NSMutableArray * detailArray = [NSMutableArray arrayWithArray:[itemDetail.content componentsSeparatedByString:@"\n"]];
    [detailArray removeLastObject];
    NSString * serviceTime;
    CommonItemTxt * offers;
    if (array.count >= 3) {
        offers = [array objectAtIndex:1];
    }
    NSMutableString *offersString = [NSMutableString string];
    if (offers) {
        [offersString appendString:offers.content];
    }
    for (int i = 0; i < detailArray.count; i++) {
        if ([[detailArray objectAtIndex:i] hasPrefix:@"服务时长"]) {
            serviceTime = [detailArray objectAtIndex:i];
            [detailArray removeObjectAtIndex:i];
            i -- ;
            continue;
        }
        
        if ([[detailArray objectAtIndex:i] hasPrefix:@"赠送"]) {
            [offersString appendFormat:@"* %@\n",[detailArray objectAtIndex:i]];
            [detailArray removeObjectAtIndex:i];
            i --;
            continue;
        }
    }
    CommonItemTxt *itemsInfo = [[CommonItemTxt alloc] init:work_detail_info_type_service_items title:@"价格说明：" content:[detailArray componentsJoinedByString:@"\n"]];
    [result addObject:itemsInfo];
    
    if (offers != nil || offersString.length > 0) {
        CommonItemTxt *specialOfferItem = [[CommonItemTxt alloc] init:work_detail_info_type_special_offers title:@"优惠说明：" content:offersString];
        [result addObject:specialOfferItem];
    }
    
    [result addObject:[array lastObject]];
    
    CommonItemTxt *serviceTimeItem = [[CommonItemTxt alloc] init:work_detail_info_type_notes title:@"服务时长：" content:[serviceTime substringFromIndex:4]];
    [result addObject:serviceTimeItem];
    return result;
}

-(NSArray *) getWorkDetailCommonItemTxtsFromWorkStylistWork{
    NSMutableArray *detailInfoArray = [[NSMutableArray alloc] init];
    
    CommonItemTxt *itemsInfo = [[CommonItemTxt alloc] init:work_detail_info_type_service_items title:@"详情：" content:self.description];
    [detailInfoArray addObject:itemsInfo];
    
    NSString *noteTxt = special_offer_note;
    CommonItemTxt *noteItem = [[CommonItemTxt alloc] init:work_detail_info_type_notes title:@"提示：" content:noteTxt];
    [detailInfoArray addObject:noteItem];
    return detailInfoArray;
}


@end
