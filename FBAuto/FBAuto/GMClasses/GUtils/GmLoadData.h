//
//  GmLoadData.h
//  FBAuto
//
//  Created by gaomeng on 14-7-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"
typedef void(^myBlock)(NSDictionary *dataInfo,NSString *errorinfo,NSInteger errcode);


@interface GmLoadData : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(nonatomic,strong)NSString *string_url;//请求地址url
@property(nonatomic,strong)NSDictionary *mydicinfo;//解析的字典数据

//block
@property(nonatomic,copy)myBlock testBlocksbl;

//block set方法
-(void)SeturlStr:(NSString *)str block:(myBlock)block;//请求完数据之后的block



@end
