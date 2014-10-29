//
//  FBCityData.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCityData : NSObject

+ (NSArray *)getAllProvince;
+ (NSArray *)getSubCityWithProvinceId:(int)privinceId;//根据省份获取城市

+ (NSString *)cityNameForId:(int)cityId;//根据id获取城市名
+ (int)cityIdForName:(NSString *)cityName;//根据城市名获取id

#pragma - mark insert 车型数据

//数据插入
+ (void)insertCarBrandId:(NSString *)brandId
               brandName:(NSString *)name
             firstLetter:(NSString *)firstLetter;//品牌

+ (void)insertCarTypeId:(NSString *)typeId
               parentId:(NSString *)parentId
               typeName:(NSString *)name
            firstLetter:(NSString *)firstLetter;//车型

+ (void)insertCarStyleId:(NSString *)StyleId
                parentId:(NSString *)parentId
               StyleName:(NSString *)name;//车款

//是否存在
+ (BOOL)existCarBrandId:(NSString *)brandId;//品牌是否存在
+ (BOOL)existCarTypeId:(NSString *)typeId;//车型
+ (BOOL)existCarStyleId:(NSString *)styleId;//车款

//数据更新
+ (void)updateCarBrandId:(NSString *)brandId
               brandName:(NSString *)name
             firstLetter:(NSString *)firstLetter;//品牌

+ (void)updateCarTypeId:(NSString *)codeId
               typeName:(NSString *)name
            firstLetter:(NSString *)firstLetter;//车型

+ (void)updateCarStyleId:(NSString *)codeId
               StyleName:(NSString *)name;//车款

#pragma - mark querty 车型数据

+ (NSArray *)queryAllCarBrand;
+ (NSArray *)queryCarTypeWithParentId:(NSString *)parendId;
+ (NSArray *)queryCarStyleWithParentId:(NSString *)parendId;

+ (BOOL)deleteAllCarData;//清空数据

#pragma - mark xmpp消息未读条数

+ (void)updateCurrentUserPhone:(NSString *)currentPhone fromUserPhone:(NSString *)FromPhone fromName:(NSString *)fromName fromId:(NSString *)fromId newestMessage:(NSString *)message time:(NSString *)time clearReadSum:(BOOL)clearSum;//有更新、没有时插入,clearReadSum 判断是未读 +1，还是置0

+ (int)numberOfUnreadMessage:(NSString *)currentUser;

+ (NSArray *)queryAllNewestMessageForUser:(NSString *)currentUser;//查询历史数据,只有最新一条

@end
