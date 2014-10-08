//
//  RCMessage.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-6-13.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCStatusDefine.h"

@class RCMessageContent;

@interface RCMessage : NSObject
@property(nonatomic, assign) RCConversationType conversationType;
@property(nonatomic, strong) NSString* targetId;// discussionID, groupID, chatRoomID
@property(nonatomic, assign) long messageId;
@property(nonatomic, assign) RCMessageDirection messageDirection;
@property(nonatomic, strong) NSString* senderUserId;
@property(nonatomic, assign) RCReceivedStatus receivedStatus;
@property(nonatomic, assign) RCSentStatus sentStatus;
@property(nonatomic, assign) long long receivedTime;
@property(nonatomic, assign) long long sentTime;
@property(nonatomic, strong) NSString* objectName;
@property(nonatomic, strong) RCMessageContent* content;
@property(nonatomic, strong) NSString* extra;

-(RCMessage*)initWithType:(RCConversationType)conversationTp targetId:(NSString*)targetId msgDirection:(RCMessageDirection)msgDirection msgId:(long)msgId objName:(NSString*)objName content:(RCMessageContent*)content;

//----Create instance from json-dictionary ----//
-(RCMessage*)createMessageWithJSONValue:(NSDictionary*)jsonDict;
@end
