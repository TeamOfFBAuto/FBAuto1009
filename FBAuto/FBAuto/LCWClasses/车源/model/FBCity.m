//
//  FBCity.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCity.h"

@implementation FBCity

-(id)initProvinceWithName:(NSString *)cityName provinceId:(int)provinceId
{
    self = [super init];
    if (self) {
        self.cityName = cityName;
        self.provinceId = provinceId;
        self.cityId = provinceId;
    }
    return self;
}

-(id)initSubcityWithName:(NSString *)cityName cityId:(int)cityId provinceId:(int)provinceId
{
    self = [super init];
    if (self) {
        self.cityName = cityName;
        self.cityId = cityId;
        self.provinceId = provinceId;
    }
    return self;
}
@end
