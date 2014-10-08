//
//  SzkAPI.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SzkAPI : NSObject

//获取通讯录，放到一个数组中
+(NSMutableArray *)AccesstoAddressBookAndGetDetail;

+(NSString *) fileSizeAtPath:(NSString*) filePath;
+ (long long) _folderSizeAtPath: (const char*)folderPath;

//获取用户的devicetoken

+(NSString *)getDeviceToken;

//切图
+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;

//索引排序

//+(NSArray *)exChangeFriendListByOrder:(NSMutableArray *)theArray;


@end
