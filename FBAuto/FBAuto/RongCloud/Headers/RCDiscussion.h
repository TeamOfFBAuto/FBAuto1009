//
//  RCDiscussion.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-6-23.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDiscussion : NSObject
@property(nonatomic, strong) NSString* discussionId;
@property(nonatomic, strong) NSString* discussionName;
@property(nonatomic, strong) NSString* creatorId;
@property(nonatomic, assign) int conversationType;
@property(nonatomic, strong) NSArray* memberIdList;
@property(nonatomic, assign) int inviteStatus; //0 -open ; 1 - close;
@property(nonatomic, assign) int pushMessageNotificationStatus; // 0 --open ; 1 - close;

-(RCDiscussion*)initWithDiscussionId:(NSString*)discussionId discussionName:(NSString*)discussionName creatorId:(NSString*)creatorId conversationType:(int)conversationType memberIdList:(NSArray*)memberIdList inviteStatus:(int)inviteStatus msgNotificationStatus:(int)pushMessageNotificationStatus;
@end
