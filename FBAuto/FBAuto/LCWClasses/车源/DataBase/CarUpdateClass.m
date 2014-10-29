//
//  CarUpdateClass.m
//  FBAuto
//
//  Created by lichaowei on 14/10/29.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CarUpdateClass.h"

@implementation CarUpdateClass

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey %@",key);
}

@end
