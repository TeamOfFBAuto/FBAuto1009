//
//  FBCity.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCity : NSObject

@property(nonatomic,retain)NSString *cityName;
@property(nonatomic,assign)int cityId;
@property(nonatomic,assign)int provinceId;//省份id

-(id)initProvinceWithName:(NSString *)cityName provinceId:(int)provinceId;
-(id)initSubcityWithName:(NSString *)cityName cityId:(int)cityId provinceId:(int)provinceId;

@end
