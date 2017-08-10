//
//  Organization.m
//  iUser
//
//  Created by System Administrator on 13-5-8.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "Organization.h"
#import "JSONSerializable.h"
#import "LBSUtils.h"
#import "AppStatus.h"
#import "HairDressingCard.h"

@implementation Organization

-(void)tidyHdcSort:(NSArray *)hdcCatalogs{
    if (self.hdcs == nil || self.hdcs.count == 0) {
        return ;
    }
    
    NSArray *newHdcs = [self.hdcs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HairDressingCard *card1 = (HairDressingCard *)obj1;
        HairDressingCard *card2 = (HairDressingCard *)obj2;
        NSComparisonResult result = [card1 compare:card2 hdcTypes:hdcCatalogs];
        return result;
    }];
    
    self.hdcs = [[NSMutableArray alloc] initWithArray:newHdcs];
}

-(BOOL)hasContent{
    return ((NSNull *)self.content != [NSNull null]) && self.content.length > 0;
}
-(double) lat{
    if (self.poi == nil || (NSNull *)self.poi == [NSNull null]) {
        return 0;
    }
    NSArray *arr = [self.poi componentsSeparatedByString:@","];
    return [[arr objectAtIndex:0] doubleValue];
}

-(double) lng{
    if (self.poi == nil || (NSNull *)self.poi == [NSNull null]) {
        return 0;
    }
    NSArray *arr = [self.poi componentsSeparatedByString:@","];
    return [[arr objectAtIndex:1] doubleValue];
}

-(NSString *) simpleInfoStr{
    AppStatus *as = [AppStatus sharedInstance];
    float distance = self.distance;
    if(distance == 0)
        distance = [LBSUtils latLngDist:as.lastLng lat1:as.lastLat lon2:[self lng] lat2:[self lat]]/1000;
   
    if(distance <= 5)
        return [NSString stringWithFormat:@"%@ %.1f公里", self.name, distance];
    else
        return [NSString stringWithFormat:@"%@ >5公里", self.name];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}

-(NSString *) getOrganizationName{
    return [NSString stringWithFormat:@"%@ %@",self.brandName,self.storeName];
}

-(NSString *) getBrandName{
    if ([NSStringUtils isNotBlank:_brandName]) {
        return _brandName;
    }
    return _storeName;
}

-(float) getEvaluationAvgScore{
    if (self.receivedEvaluationCount == 0) {
        return 0;
    }
    float averageScore = (self.trafficScore + self.environmentScore )/(self.receivedEvaluationCount*2);
    if (averageScore >= 4.95) {
        averageScore = 5.0;
    }
    return averageScore;
}

-(NSString *) getDistanceTxt{
    AppStatus *as = [AppStatus sharedInstance];
    float distance = self.distance;
    if(distance == 0 || distance >= 1000000000)
        distance = [LBSUtils latLngDist:as.lastLng lat1:as.lastLat lon2:[self lng] lat2:[self lat]];
    self.distance = distance;
    if(self.distance/1000 < 1){
        return [NSString stringWithFormat:@"%.0f m", self.distance];
    }else if(self.distance/1000 <= 20){
        return [NSString stringWithFormat:@"%.1f km", self.distance/1000];
    }else{
        return [NSString stringWithFormat:@"> 20km"];
    }
}

-(Picture *) getCoverPicture{
    if (self.pictures == nil || self.pictures.count == 0) {
        return nil;
    }
    for (int i=0 ; i<self.pictures.count ; i++) {
        if ([self.pictures[i] coverPictureFlag]){
            return self.pictures[i];
        }
    }
    return nil;
}


-(void) addHairDressingCard:(HairDressingCard *)hairDressingCard{
    if ( self.hdcs == nil) {
        self.hdcs = [[NSMutableArray alloc] init];
    }
    [self.hdcs addObject:hairDressingCard];
}


-(HairDressingCard *) getFistDisplayHairDressingCard{
    if (self.hdcs == nil || self.hdcs.count == 0) {
        return nil;
    }
    
    HairDressingCard *hdc = self.hdcs[0];
    for(HairDressingCard *compareHdc in self.hdcs){
        if(compareHdc.saleRule.recommendStatus){
            return compareHdc; // 该张美发卡是推荐美发卡
        }
        if (hdc.saleCount.realSaleCount < compareHdc.saleCount.realSaleCount) {  // 先比较真实的销售数量
            hdc = compareHdc;
        }else if(hdc.saleCount.realSaleCount == compareHdc.saleCount.realSaleCount
                 && hdc.specialOfferPrice > compareHdc.specialOfferPrice){  // 销售数量相同 则比较优惠价格
            hdc = compareHdc;
        }
    }
    return hdc;
}


-(HairDressingCard *) getNextHairDressingCard:(int) index{
    if (index == 0) {
        return [self getFistDisplayHairDressingCard];
    }
    HairDressingCard *hdc = [self getFistDisplayHairDressingCard];
    int inx = [self.hdcs indexOfObject:hdc];
    if ( index <= inx) {
        return self.hdcs[index-1];
    }else{
        return self.hdcs[index];
    }
}

@end


///////Picture 实现
@implementation Picture

@end