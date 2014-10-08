//
//  CarType.h
//  FBAuto
//
//  Created by lichaowei on 14-7-15.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//车型

@interface CarType : NSManagedObject

@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * firstLetter;

@end
