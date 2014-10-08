//
//  GMAPI.m
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI

//用户名

+(NSString *)getUserPhoneNumber{
    NSString *phoneNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERPHONENUMBER]];
    return phoneNumber;
}


//获取用户的devicetoken

+(NSString *)getDeviceToken{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]];
    return str_devicetoken;
    
    
}

//获取用户名
+(NSString *)getUsername{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERNAME]];
    if ([str_devicetoken isEqualToString:@"(null)"]) {
        str_devicetoken=@"";
    }
    return str_devicetoken;
    
    
}

//获取authkey
+(NSString *)getAuthkey{
    
    NSString *str_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERAUTHKEY]];
    return str_authkey;
    
}


//获取用户id
+(NSString *)getUid{
    
    NSString *str_uid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERID]];
    return str_uid;
    
}


//获取用户密码
+(NSString *)getUserPassWord{
    NSString *str_password = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERPASSWORD]];
    return str_password;
}


#pragma mark - 弹出提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}


@end
