//
//  CarUpdateClass.h
//  FBAuto
//
//  Created by lichaowei on 14/10/29.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarUpdateClass : NSObject

//品牌

@property(nonatomic,retain)NSString *list_index;//车型、车系、车款编码id
@property(nonatomic,retain)NSString *name;//车型、车系、车款name
@property(nonatomic,retain)NSString *eindex;//首字母

//车系

@property(nonatomic,retain)NSString *pid;//车系时对应品牌编码id （车款时对应车系编码id）

//车款
@property(nonatomic,retain)NSString *ppid;//对应车系的编码id

-(instancetype)initWithDictionary:(NSDictionary *)dic;


@end
