//
//  CarSourceClass.h
//  FBAuto
//
//  Created by lichaowei on 14-7-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarSourceClass : NSObject

@property(nonatomic,retain)NSString *id;//车源信息id
@property(nonatomic,retain)NSString *uid;//发布的用户id
@property(nonatomic,retain)NSString *username;//发布的用户名
@property(nonatomic,retain)NSString *usertype;//用户类型
@property(nonatomic,retain)NSString *car;//车型编码
@property(nonatomic,retain)NSString *car_name;//车型名称
@property(nonatomic,retain)NSString *province;//省份名称
@property(nonatomic,retain)NSString *city;//城市名称
@property(nonatomic,retain)NSString *spot_future;//现货或者期货
@property(nonatomic,retain)NSString *color_out;//外观颜色
@property(nonatomic,retain)NSString *color_in;//内饰颜色
@property(nonatomic,retain)NSString *carfrom;//汽车版本
@property(nonatomic,retain)NSString *dateline;//发布时间
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *uptime;//上传时间

@property(nonatomic,retain)NSString *deposit;//定金

@property(nonatomic,retain)NSString *sid;//收藏信息id

@property(nonatomic,strong)NSString *stype_name;//收藏的内容种类
-(id)initWithDictionary:(NSDictionary *)dic;

@end
