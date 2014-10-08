//
//  GmPrepareNetData.h
//  FBAuto
//
//  Created by gaomeng on 14-8-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GmPrepareNetData : NSObject
{
    urlRequestBlock successBlock;
    urlRequestBlock failBlock;
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
}


- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;


- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock;


@end
