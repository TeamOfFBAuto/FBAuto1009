//
//  ZSNApi.h
//  FBCircle
//
//  Created by soulnear on 14-5-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define PERSONAL_DEFAULTS_IMAGE [UIImage imageNamed:@"gtouxiangHolderImage.png"]



@interface ZSNApi : NSObject


+(NSArray *)exChangeFriendListByOrder:(NSMutableArray *)theArray;


+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;

+(NSString *)returnUrl:(NSString *)theUrl;
+(NSString *)returnMiddleUrl:(NSString *)theUrl;

+(NSString *)timechange:(NSString *)placetime;

+(NSString *)timechangeByAll:(NSString *)placetime;

+(NSString *)timechange1:(NSString *)placetime;

+(NSString *)timechangeToDateline;

+(NSArray *)stringExchange:(NSString *)string;

+(float)calculateheight:(NSArray *)array;

+(CGPoint)LinesWidth:(NSString *)string Label:(UILabel *)label font:(UIFont *)thefont;

+ (float)theHeight:(NSString *)content withHeight:(CGFloat)theheight WidthFont:(UIFont *)font;

+(NSString*)timestamp:(NSString*)myTime;

+(UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;


+ (NSString*)FBImageChange:(NSString*)imgSrc;

+ (NSString*)FBEximgreplace:(NSString*)imgSrc;


//保存图片到沙盒

+(void)saveImageToDocWith:(NSString *)path WithImage:(UIImage *)image;

//删除沙盒文件

+(void)deleteDocFileWith:(NSMutableArray *)fileNames;

//保存图片沙盒地址

+(NSString *)docImagePath;


@end







