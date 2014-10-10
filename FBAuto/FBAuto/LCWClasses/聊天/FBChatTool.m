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

    FBChatViewController *chat =[[FBChatViewController alloc]init];
    chat.portraitStyle = UIPortraitViewRound;
    chat.currentTarget = userId;
    chat.currentTargetName = userName;
    chat.conversationType = ConversationType_PRIVATE;
    [target.navigationController pushViewController:chat animated:YES];
}

@end
