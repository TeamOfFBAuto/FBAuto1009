//
//  RCConversation.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-6-13.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCMessageContent.h"
#import "RCStatusDefine.h"


@interface RCConversation : NSObject
@property(nonatomic, assign) RCConversationType conversationType;
@property(nonatomic, strong) NSString* targetId;
@property(nonatomic, strong) NSString* conversationTitle;
@property(nonatomic, assign) int unreadMessageCount;
@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, assign) RCReceivedStatus receivedStatus;
@property(nonatomic, assign) RCSentStatus sentStatus;
@property(nonatomic, assign) long long receivedTime;
@property(nonatomic, assign) long long sentTime;
@property(nonatomic, strong) NSString* draft;
@property(nonatomic, strong) NSString* objectName;
@property(nonatomic, strong) NSString* senderUserId;
@property(nonatomic, strong) NSString* senderUserName;
@property(nonatomic, strong) NSString* lastestMessageId;
@property(nonatomic, strong) RCMessageContent* lastestMessage;

-(RCConversation*)createConversationWithJSONDict:(NSDictionary*)jsonDict;
@end
