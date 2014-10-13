//
//  FBChatTool.m
//  FBAuto
//
//  Created by lichaowei on 14-10-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBChatTool.h"
#import "FBChatViewController.h"

@implementation FBChatTool


+ (void)chatWithUserId:(NSString *)userId userName:(NSString *)userName target:(UIViewController *)target
{
    
//    userId = [NSString stringWithFormat:@"%@@fbauto",userId];//加标识
    
    FBChatViewController *chat =[[FBChatViewController alloc]init];
    chat.portraitStyle = UIPortraitViewRound;
    chat.currentTarget = userId;
    chat.currentTargetName = userName;
    chat.conversationType = ConversationType_PRIVATE;
    [target.navigationController pushViewController:chat animated:YES];
}

//存储用户name 对应id
+ (void)cacheUserName:(NSString *)name forUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults]setObject:name forKey:[NSString stringWithFormat:@"chat:%@",userId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//根据id来获取name
+ (NSString *)getUserNameForUserId:(NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults]stringForKey:[NSString stringWithFormat:@"chat:%@",userId]];
}

@end
