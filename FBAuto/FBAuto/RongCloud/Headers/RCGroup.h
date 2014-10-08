//
//  RCGroup.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-9-6.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCGroup : NSObject
@property(nonatomic, strong) NSString* groupId;
@property(nonatomic, strong) NSString* groupName;
@property(nonatomic, strong) NSString* portraitUri;

-(RCGroup*)initWithGroupId:(NSString*)groupID groupName:(NSString*)groupName portraitUri:(NSString*)portraitUri;
@end
