//
//  CarStyle.h
//  FBAuto
//
//  Created by lichaowei on 14-7-15.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//车款

@interface CarStyle : NSManagedObject

@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * styleId;
@property (nonatomic, retain) NSString * styleName;

@end
