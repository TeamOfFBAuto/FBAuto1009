//
//  RCHandShakeMessage.h
//  iOS-IMKit
//
//  Created by Heq.Shinoda on 14-6-30.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import "RCMessageContent.h"

@interface RCHandShakeMessage : RCMessageContent
@property(nonatomic, assign) int type;

-(RCHandShakeMessage*)initWithType:(int)aType;

+(NSString*)getClassObjectName;
+(int)getClassObjectFlag;
+(void)setObjectFlag:(int)objFlag;
@end
