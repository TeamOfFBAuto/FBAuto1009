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
    FBChatViewController *chat = (FBChatViewController *)[[RCIM sharedRCIM]createPrivateChat:userId title:nil completion:^(){
        // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
    }];
    
//    chat.currentTarget = userId;
//    chat.currentTargetName = userName;
    
    if ([[GMAPI getUid] isEqualToString:@"1"]) {
        
        chat.currentTarget = @"2";
        chat.currentTargetName = @"test";
        
    }else
    {
        chat.currentTarget = @"1";
        chat.currentTargetName = @"Rnai";
    }
    
    
    chat.conversationType = ConversationType_PRIVATE;
    
    [target.navigationController pushViewController:chat animated:YES];
}

@end
