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

@end
