//
//  DataBase.h
//  TuanProject
//
//  Created by 李朝伟 on 13-8-27.
//  Copyright (c) 2013年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBase : NSObject
{
    
}
//打开数据库
+(sqlite3 *)openDB;
//关闭数据库
+(void)closeDB;

+ (BOOL)removeDb;//直接移除数据库,不用删除表了，呵呵

@end
