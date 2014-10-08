//
//  City.h
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSArray *subCities;//二级城市

-(id)initWithTitle:(NSString *)title subCities:(NSArray *)subCities;

@end
