//
//  GlocalUserImage.m
//  FBCircle
//
//  Created by gaomeng on 14-6-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GlocalUserImage.h"

@implementation GlocalUserImage



//写数据=======================================

//把用户bannerImage写到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    
    NSString *userBannerName = @"/guserBannerImage.png";
    
    NSString *path = [pathD stringByAppendingString:userBannerName];
    
    NSLog(@"%@",path);
    
    
    BOOL is = [data writeToFile:path atomically:YES];
    
    NSLog(@"%d",is);
    
    if (is) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
    return is;
}

//把用户头像image写到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    
    NSString *userFaceName = @"/guserFaceImage.png";
    
    NSString *path = [pathD stringByAppendingString:userFaceName];
    
    NSLog(@"%@",path);
    
    BOOL is = [data writeToFile:path atomically:YES];
    NSLog(@"%d",is);
    
    if (is) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
    }
    
    
    return is;
}


+(void)setMessageOnOrOff:(BOOL)onOrOff{
    [[NSUserDefaults standardUserDefaults]setBool:onOrOff forKey:@"switchOnorOff"];
    
}





//读数据=============================================


//获取banner
+(UIImage *)getUserBannerImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    NSString *userBannerName = @"/guserBannerImage.png";
    NSString *path = [pathD stringByAppendingString:userBannerName];
    NSLog(@"%@",path);
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

//获取faceImage
+(UIImage *)getUserFaceImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathD = paths[0];
    NSString *userFaceName = @"/guserFaceImage.png";
    NSString *path = [pathD stringByAppendingString:userFaceName];
    
    NSLog(@"%@",path);
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}




//获取document路径
+ (NSString *)documentFolder{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


//获取开关状态
+(BOOL)getMessageOnOrOff{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"switchOnorOff"];
}



@end
