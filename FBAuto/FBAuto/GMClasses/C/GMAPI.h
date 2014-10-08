//
//  GMAPI.h
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface GMAPI : NSObject

+(NSString *)getUsername;


+(NSString *)getDeviceToken;

+(NSString *)getAuthkey;

+(NSString *)getUid;

+(NSString *)getUserPassWord;

+(NSString *)getUserPhoneNumber;

+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;



@end
