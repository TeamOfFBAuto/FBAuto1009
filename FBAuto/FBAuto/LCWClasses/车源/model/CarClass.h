//
//  CarClass.h
//  FBAuto
//
//  Created by lichaowei on 14-7-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarClass : NSObject

@property (nonatomic, retain) NSString * brandId;
@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSString * brandFirstLetter;

@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * typeFirstLetter;

//@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * styleId;
@property (nonatomic, retain) NSString * styleName;

//品牌
- (id)initWithBrandId:(NSString *)brandId
           brandName:(NSString *)brandName
      brandFirstName:(NSString *)brandFirstLetter;
//车型
- (id)initWithParentId:(NSString *)parentId
            typeId:(NSString *)typeId
              typeName:(NSString *)typeName
           firstLetter:(NSString *)firstLetter;

//车型
- (id)initWithParentId:(NSString *)parentId
               styleId:(NSString *)styleId
              styleName:(NSString *)styleName;

@end
