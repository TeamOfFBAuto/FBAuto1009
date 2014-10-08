//
//  GlocalUserImage.h
//  FBCircle
//
//  Created by gaomeng on 14-6-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlocalUserImage : NSObject


//写数据=========================

//保存用户banner到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data;

//保存用户头像到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data;



//获取document路径
+ (NSString *)documentFolder;

//设置开关
+(void)setMessageOnOrOff:(BOOL)onOrOff;





//读数据=========================

//获取用户bannerImage
+(UIImage *)getUserBannerImage;

//获取用户头像Image
+(UIImage *)getUserFaceImage;


//获取开关状态
+(BOOL)getMessageOnOrOff;


@end
