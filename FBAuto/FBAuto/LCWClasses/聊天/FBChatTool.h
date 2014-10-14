//
//  FBChatTool.h
//  FBAuto
//
//  Created by lichaowei on 14-10-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_UPDATE_USERINFO @"UPDATE_USERINFO"//更新用户个人信息通知

@interface FBChatTool : NSObject

//单对单聊天
+ (void)chatWithUserId:(NSString *)userId userName:(NSString *)userName target:(UIViewController *)target;

//存储用户name 对应id
+ (void)cacheUserName:(NSString *)name forUserId:(NSString *)userId;
//根据id来获取name
+ (NSString *)getUserNameForUserId:(NSString *)userId;

+ (void)cacheUserHeadImage:(NSString *)imageUrl forUserId:(NSString *)userId;//存储头像
+ (NSString *)getUserHeadImageForUserId:(NSString *)userId;//获取头像

@end
