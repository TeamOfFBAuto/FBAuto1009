//
//  City.m
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "City.h"

@implementation City

-(id)initWithTitle:(NSString *)title subCities:(NSArray *)subCities
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subCities = subCities;
    }
    return self;
}

@end
