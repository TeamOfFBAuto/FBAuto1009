//
//  DataBase.m
//  TuanProject
//
//  Created by 李朝伟 on 13-8-27.
//  Copyright (c) 2013年 lcw. All rights reserved.
//

#import "DataBase.h"
static sqlite3 *db = nil;
@implementation DataBase
{
    
}
//打开数据库
+(sqlite3 *)openDB
{
    if (db) {
        return db;
    }
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];//获取document路径
    NSString *filePath = [documents stringByAppendingPathComponent:@"garea.sqlite"]; //将要存放位置
    NSLog(@"数据库路径 = %@",filePath);
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"garea" ofType:@"sqlite"];//bundle中位置
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        [fm copyItemAtPath:bundlePath toPath:filePath error:nil]; //拷贝数据文件到document下
    }
    sqlite3_open([filePath UTF8String], &db);
    return db;
}
//关闭数据库
+(void)closeDB
{
    sqlite3_close(db);
    db = nil;
}
@end
