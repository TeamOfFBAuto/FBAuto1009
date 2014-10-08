//
//  FBFriendModel.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

////buddyid = 2;
//buddyname = gaoyue;
//city = 0;
//dateline = 1404875287;
//face = "http://fbautoapp.fblife.com/resource/head/default.jpg";
//id = 6;
//phone = 13161553162;
//province = 0;
//status = 0;
//uid = 1;
//uptime = 0;
//usertype = 1;
@interface FBFriendModel : NSObject

@property(nonatomic,retain)NSString *buddyid;
@property(nonatomic,retain)NSString *buddyname;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,retain)NSString *face;
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *phone;
@property(nonatomic,retain)NSString *province;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *uptime;
@property(nonatomic,retain)NSString *usertype;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *isbuddy;

@property(nonatomic,retain)NSString *city_name;//显示用，后台返回的时id,这是转化后的汉子名称


-(id)initWithDictionary:(NSDictionary *)dic;

@end
