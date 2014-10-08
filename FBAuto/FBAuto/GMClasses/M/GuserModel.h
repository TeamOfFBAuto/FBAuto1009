//
//  GuserModel.h
//  FBAuto
//
//  Created by gaomeng on 14-7-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//用户信息
#import <Foundation/Foundation.h>

@interface GuserModel : NSObject

@property(nonatomic,strong)NSString *uid;//用户id
@property(nonatomic,strong)NSString *phone;//电话
@property(nonatomic,strong)NSString *name;//用户名
@property(nonatomic,strong)NSString *fullname;//全称
@property(nonatomic,strong)NSString *province;//省
@property(nonatomic,strong)NSString *city;//市
@property(nonatomic,strong)NSString *intro;//用户简介
@property(nonatomic,strong)NSString *headimage;//头像
@property(nonatomic,strong)NSString *address;//地址
@property(nonatomic,strong)NSString *usertype;//(1:个人；2:商家)
@property(nonatomic,strong)NSString *msg_visible;//(是否接收消息提示1：接收；2：不接受)
@property(nonatomic,strong)NSString *token;//手机token
@property(nonatomic,strong)NSString *imagenum;//图片数
@property(nonatomic,strong)NSString *buddy_num;//好友数
@property(nonatomic,strong)NSString *cheyuan_num;//车源数
@property(nonatomic,strong)NSString *xunche_num;//寻车数
@property(nonatomic,strong)NSString *isdel;//(0:未删除;1:已删除)
@property(nonatomic,strong)NSString *dateline;//:时间



//初始化方法
-(id)initWithDic:(NSDictionary *)dic;


@end
