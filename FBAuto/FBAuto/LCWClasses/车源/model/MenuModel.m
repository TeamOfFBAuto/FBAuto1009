//
//  MenuModel.m
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

- (id)initWithTitle:(NSString *)title haveSub:(BOOL)isHave
{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.haveSub = isHave;
    }
    return self;
}

@end
