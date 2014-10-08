//
//  GmPrepareNetData.m
//  FBAuto
//
//  Created by gaomeng on 14-8-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmPrepareNetData.h"

@implementation GmPrepareNetData


- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData//post
{
    self = [super init];
    if (self) {
        requestUrl = url;
        
        if (isPost) {
            requestData = postData;
            isPostRequest = isPost;
        }
    }
    return self;
}

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock{
    successBlock = completionBlock;
    failBlock = failedBlock;
    
    NSString *newStr = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",newStr);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    
    
    if (isPostRequest) {
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:requestData];
    }
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data.length > 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"response :%@",response);
            
            if ([dic isKindOfClass:[NSDictionary class]]) {
                
                int erroCode = [[dic objectForKey:@"errcode"]intValue];
                NSString *erroInfo = [dic objectForKey:@"errinfo"];
                
                
                
                if (erroCode != 0) { //0代表无错误,  && erroCode != 1 1代表无结果
                    
                    
                    NSDictionary *failDic = @{ERROR_INFO:erroInfo};
                    failBlock(failDic,connectionError);
                    
                    return ;
                }else
                {
                    successBlock(dic,connectionError);//传递的已经是没有错误的结果
                }
            }
            
        }else
        {
            NSLog(@"data 为空 connectionError %@",connectionError);
            
            NSString *errInfo = @"网络有问题,请检查网络";
            switch (connectionError.code) {
                case NSURLErrorNotConnectedToInternet:
                    
                    errInfo = @"无网络连接";
                    break;
                case NSURLErrorTimedOut:
                    
                    errInfo = @"网络连接超时";
                    break;
                default:
                    break;
            }
            
            NSDictionary *failDic = @{ERROR_INFO: errInfo};
            failBlock(failDic,connectionError);
            
        }
        
    }];
    
}


@end
