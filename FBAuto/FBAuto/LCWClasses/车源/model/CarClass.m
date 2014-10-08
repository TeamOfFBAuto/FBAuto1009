//
//  CarClass.m
//  FBAuto
//
//  Created by lichaowei on 14-7-17.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CarClass.h"

@implementation CarClass

//品牌
- (id)initWithBrandId:(NSString *)brandId
            brandName:(NSString *)brandName
       brandFirstName:(NSString *)brandFirstLetter
{
    self = [super init];
    if (self) {
        self.brandId = brandId;
        self.brandName = brandName;
        self.brandFirstLetter = brandFirstLetter;
    }
    return self;
}
//车型
- (id)initWithParentId:(NSString *)parentId
                typeId:(NSString *)typeId
              typeName:(NSString *)typeName
           firstLetter:(NSString *)firstLetter
{
    self = [super init];
    if (self) {
        self.parentId = parentId;
        self.typeId = typeId;
        self.typeName = typeName;
        self.typeFirstLetter = firstLetter;
    }
    return self;
}

//车型
- (id)initWithParentId:(NSString *)parentId
               styleId:(NSString *)styleId
             styleName:(NSString *)styleName
{
    self = [super init];
    if (self) {
        
        self.parentId = parentId;
        self.styleId = styleId;
        self.styleName = styleName;
    }
    return self;

}

@end
