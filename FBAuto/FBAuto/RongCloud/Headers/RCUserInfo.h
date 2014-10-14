//
//  RCUserInfo.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-6-16.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCUserInfo : NSObject
@property(nonatomic, strong) NSString* userId;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* portraitUri;

-(RCUserInfo*)initWithUserId:(NSString*)uId name:(NSString*)name portrait:(NSString*)portrait;
@end
