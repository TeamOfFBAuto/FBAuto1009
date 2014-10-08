//
//  CarSourceClass.m
//  FBAuto
//
//  Created by lichaowei on 14-7-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CarSourceClass.h"

@implementation CarSourceClass

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey %@",key);
}

@end
