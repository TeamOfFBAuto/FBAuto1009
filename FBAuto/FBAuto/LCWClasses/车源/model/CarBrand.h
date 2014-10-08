//
//  CarBrand.h
//  FBAuto
//
//  Created by lichaowei on 14-7-15.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarBrand : NSManagedObject

@property (nonatomic, retain) NSString * brandId;
@property (nonatomic, retain) NSString * brandName;
@property (nonatomic, retain) NSString * brandFirstLetter;

@end
