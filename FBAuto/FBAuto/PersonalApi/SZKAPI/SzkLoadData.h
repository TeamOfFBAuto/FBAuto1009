//
//  SzkLoadData.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
typedef void(^myBlock)(NSArray *arrayinfo,NSString *errorindo,NSInteger errcode);






@interface SzkLoadData : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property(nonatomic,strong)NSString *string_url;

-(void)SeturlStr:(NSString *)str block:(myBlock)block;
@property(nonatomic,copy)myBlock testBlocksbl;
@property(nonatomic,strong)NSDictionary *mydicinfo;


@end
