//
//  XMPPMessageModel.m
//  FBAuto
//
//  Created by lichaowei on 14-7-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "XMPPMessageModel.h"

@implementation XMPPMessageModel

- (id)initWithFromPhone:(NSString *)phoneName
               fromName:(NSString *)fromName
                 fromId:(NSString *)fromId
          newestMessage:(NSString *)newestMessage
                   time:(NSString *)time
{
    self = [super init];
    if (self) {
        self.fromPhone = phoneName;
        self.fromName = fromName;
        self.fromId = fromId;
        self.newestMessage = newestMessage;
        self.time = time;
    }
    return self;
}

@end
