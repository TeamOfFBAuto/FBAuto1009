//
//  FBChatTool.h
//  FBAuto
//
//  Created by lichaowei on 14-10-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBChatTool : NSObject

//单对单聊天
+ (void)chatWithUserId:(NSString *)userId userName:(NSString *)userName target:(UIViewController *)target;

//存储用户name 对应id
+ (void)cacheUserName:(NSString *)name forUserId:(NSString *)userId;
//根据id来获取name
+ (NSString *)getUserNameForUserId:(NSString *)userId;

@end
