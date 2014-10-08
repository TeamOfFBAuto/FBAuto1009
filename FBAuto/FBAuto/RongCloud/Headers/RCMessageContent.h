//
//  RCMessageContent.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-6-13.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCStatusDefine.h"

@interface RCMessageContent : NSObject
{
@protected RCConversationType conversationType;
@private NSString* targetId;
}
@property(nonatomic, strong) NSString* jsonData;
-(id)initWithData:(const char*)data;

-(NSString*)getObjectName;
-(int)getObjectFlag;
//----规则编码----//
-(const char*)encode;
@end
