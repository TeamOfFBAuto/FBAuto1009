//
//  GmLoadData.m
//  FBAuto
//
//  Created by gaomeng on 14-7-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmLoadData.h"

@implementation GmLoadData
{
    
    NSMutableData *_data;
}

-(void)SeturlStr:(NSString *)str block:(myBlock)block{
    
    _testBlocksbl=block;
    _string_url=str;
    
    NSLog(@"urlstr=====%@",_string_url);
    
    NSURL *url = [NSURL URLWithString:_string_url];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
    
    
}
//连接接受响应，表示成功建立连接
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data = [NSMutableData data];
}
//连接接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_data appendData:data];
}
//连接完成

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    // NSArray *dicinfo=[_data objectFromJSONData];
    self.mydicinfo=[_data objectFromJSONData];
    
    if ([[self.mydicinfo objectForKey:@"errcode"] integerValue]==0) {
        NSDictionary *dic_=[self.mydicinfo objectForKey:@"datainfo"];
        
        _testBlocksbl(dic_,@"noerror",0);
        
    }else{
        
        _testBlocksbl([[NSDictionary alloc]init],[self.mydicinfo objectForKey:@"errinfo"],[[self.mydicinfo objectForKey:@"errcode"] integerValue]);
        
    }
    
}

//请求失败的处理
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    _testBlocksbl([[NSDictionary alloc]init],@"网络不稳定，请稍后再试",1);
    
}


@end
