//
//  RCImageMessage.h
//  iOS-IMLib
//
//  Created by Heq.Shinoda on 14-6-13.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCMessageContent.h"
#import <UIKit/UIKit.h>

@interface RCImageMessage : RCMessageContent
@property(nonatomic, strong) UIImage* thumbnailImage;
//@property(nonatomic, strong) NSString* imageKey;
@property(nonatomic, strong) NSString* imageUrl;
@property(nonatomic, strong) UIImage* originalImage;

-(RCImageMessage*)initWithImagePath:(NSString*)imageUrl;

-(RCImageMessage*)initWithOriginalImage:(UIImage*)oriImage;

+(NSString*)getClassObjectName;
+(RCMessagePersistent)getClassObjectFlag;
+(void)setObjectFlag:(int)objFlag;
@end
