//
//  GuserZhuce.h
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//注册时的用户对象类
#import <Foundation/Foundation.h>

@interface GuserZhuce : NSObject


@property(nonatomic,strong)NSString *phone;//手机号
@property(nonatomic,strong)NSString *password;//密码
@property(nonatomic,strong)NSString *password1;//重复密码
@property(nonatomic,strong)NSString *name;//用户名/商家公司简介
@property(nonatomic,assign)NSInteger province;//省份
@property(nonatomic,assign)NSInteger city;//城市
@property(nonatomic,strong)NSString *code;//验证码
@property(nonatomic,strong)NSString *token;//用户token
@property(nonatomic,strong)NSString *usertype;//用户类型 1个人 2商家

@property(nonatomic,strong)NSString *fullname;//商家公司全称
@property(nonatomic,strong)NSString *address;//商家详细地址


@end
