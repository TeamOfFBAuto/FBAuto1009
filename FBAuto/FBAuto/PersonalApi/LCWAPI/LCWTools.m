//
//  LCWTools.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LCWTools.h"
#import <CommonCrypto/CommonDigest.h>

#import "AppDelegate.h"

#import "CarBrand.h"
#import "CarType.h"
#import "CarStyle.h"

#import "FBCityData.h"

#import "CarClass.h"

#import "DXAlertView.h"

@implementation LCWTools

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LCWTools *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[LCWTools alloc]init];
    });
    
    return dataBlock;
}

#pragma - mark MD5 加密

+ (NSString *) md5:(NSString *) text
{
    const char * bytes = [text UTF8String];
    unsigned char md5Binary[16];
    CC_MD5(bytes, (CC_LONG)strlen(bytes), md5Binary);
    
    NSString * md5String = [NSString
                            stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                            md5Binary[0], md5Binary[1], md5Binary[2], md5Binary[3],
                            md5Binary[4], md5Binary[5], md5Binary[6], md5Binary[7],
                            md5Binary[8], md5Binary[9], md5Binary[10], md5Binary[11],
                            md5Binary[12], md5Binary[13], md5Binary[14], md5Binary[15]
                            ];
    return md5String;
}

#pragma - mark 网络数据请求

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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *newStr = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",newStr);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    
    if (isPostRequest) {
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:requestData];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"response :%@",response);
            
            if ([dic isKindOfClass:[NSDictionary class]]) {
                
                int erroCode = [[dic objectForKey:@"errcode"]intValue];
                NSString *erroInfo = [dic objectForKey:@"errinfo"];
                


                if (erroCode != 0) { //0代表无错误,  && erroCode != 1 1代表无结果


                    NSDictionary *failDic = @{ERROR_INFO:erroInfo,ERROR_CODE:[NSString stringWithFormat:@"%d",erroCode]};
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_downUrl]];
    }
}

#pragma mark - 版本更新信息

- (void)versionForAppid:(NSString *)appid Block:(void(^)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent))version//是否有新版本、新版本更新下地址
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //test FBLife 605673005 fbauto 904576362
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
    
    NSString *newStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",newStr);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];
            
            if (results.count == 0) {
                version(NO,@"no",@"没有更新");
                return ;
            }
            
            //appStore 版本
            NSString *newVersion = [[results objectAtIndex:0]objectForKey:@"version"];
            
            NSString *updateContent = [[results objectAtIndex:0]objectForKey:@"releaseNotes"];
            //本地版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            _downUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",appid];
            
//            _downUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/crash-drive-2/id765099329?mt=12"];
            BOOL isNew = NO;
            if (newVersion && ([newVersion compare:currentVersion] == 1)) {
                isNew = YES;
            }
            version(isNew,_downUrl,updateContent);
            
            if (isNew) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新" message:updateContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                [alert show];
            }
            
        }else
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
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
            
            NSLog(@"version erro %@",failDic);
            
        }
        
    }];
    
}



+ (NSString *)headImageForUserId:(NSString *)userId
{
    //头像
    NSString *imageUrlUtf8 = [LCWTools md5:userId];
    NSString *jiequ = [imageUrlUtf8 substringFromIndex:imageUrlUtf8.length-4];
    NSString *str1 = [jiequ substringToIndex:2];
    NSString *str2 = [jiequ substringFromIndex:2];
    
    NSString *headImageUrlStr = [NSString stringWithFormat:@"http://fbautoapp.fblife.com/resource/head/%@/%@/thumb_%@_Thu.jpg",str1,str2,userId];
    
    return headImageUrlStr;
}

#pragma - mark 切图

+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  计算宽度
 */
+ (CGFloat)widthForText:(NSString *)text font:(CGFloat)size
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize aSize = [text sizeWithAttributes:attributes];
    return aSize.width;
}

+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(CGFloat)size
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize aSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:Nil].size;
    return aSize.height;
}

#pragma - mark 验证邮箱、电话等有效性

/*匹配正整数*/
+ (BOOL)isValidateInt:(NSString *)digit
{
    NSString * digitalRegex = @"^[1-9]\\d*$";
    NSPredicate * digitalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",digitalRegex];
    return [digitalTest evaluateWithObject:digit];
}

/*匹配整浮点数*/
+ (BOOL)isValidateFloat:(NSString *)digit
{
    NSString * digitalRegex = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    NSPredicate * digitalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",digitalRegex];
    return [digitalTest evaluateWithObject:digit];
}

/*邮箱*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString * emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateName:(NSString *)userName
{
    NSString * emailRegex = @"^[\u4E00-\u9FA5a-zA-Z0-9_]{1,20}$";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:userName];
}

+ (BOOL)isValidatePwd:(NSString *)pwdString
{
    NSString * emailRegex = @"^[a-zA-Z0-9_]{6,20}$";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:pwdString];
}

/*手机及固话*/
+ (BOOL)isValidateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma - mark 小工具

//时间线转化

+(NSString *)timechange:(NSString *)placetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)timechange2:(NSString *)placetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString *)timechange3:(NSString *)placetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//- (NSString *)convertDateToCurrLocalWithFormat:(NSString *)_format
//{
//	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//	[inputFormatter setDateFormat:_format];
//    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Copenhagen"]];//设置源时间时区
//	NSDate *formatterDate = [inputFormatter dateFromString:self];//因为是用category实现，self就是源时间string
//    
//	
//	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    [outputFormatter setDateStyle:NSDateFormatterShortStyle];
//    [outputFormatter setTimeStyle:NSDateFormatterShortStyle];
//	[outputFormatter setDateFormat:_format];
//	NSString *result = [outputFormatter stringFromDate:formatterDate];
//
//    
//    return result;
//}

+ (NSString *)currentTime
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date = [outputFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"时间 === %@",date);
    return date;
}

//alert 提示

+ (void)alertText:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

+(void)showDXAlertViewWithText:(NSString *)text
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:text contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alert show];
    
    alert.leftBlock = ^(){
        NSLog(@"确定");
        
    };
    alert.rightBlock = ^(){
        NSLog(@"取消");
        
    };
}

#pragma - mark 非空字符串

+ (NSString *)NSStringNotNull:(NSString *)text
{
    if (![text isKindOfClass:[NSString class]]) {
        return @"";
    }
    if ([text isEqualToString:@"null"]) {
        return @"";
    }
    return text;
}

#pragma - mark 分享

+ (void)shareText:(NSString *)text  title:(NSString *)title image:(UIImage *)aImage linkUrl:(NSString *)linkUrl ShareType:(ShareType)aShareType{
    
    //创建分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:text
                                       defaultContent:@"e族汽车分享"
                                                image:[ShareSDK pngImageWithImage:aImage]                                                title:title
                                                  url:linkUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //    //在授权页面中添加关注官方微博
    //    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
    //
    //                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:aShareType
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:nil
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(@"分享失败!error code == %d, error code == %@ ", [error errorCode], [error errorDescription]);
                                     
                                 }
                             }];
}


#pragma - mark CoreData数据管理

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FBAuto" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBAuto.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma - mark 插入数据

//插入数据
- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique
{
    NSLog(@"insertDataClassType----> %@",classType);
    
    if([classType isEqualToString:CARSOURCE_BRAND_INSERT])
    {
        [self insertCarBrand:dataArray unique:unique];
        
    }else if ([classType isEqualToString:CARSOURCE_TYPE_INSETT])
    {
        [self insertCarType:dataArray unique:unique];
        
    }else if([classType isEqualToString:CARSOURCE_STYLE_INSETT])
    {
        [self insertCarStyle:dataArray unique:unique];
    }
}

- (void)insertCarBrand:(NSArray *)dataArray unique:(NSString *)unique
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int i = 0; i < dataArray.count; i ++) {
        CarClass *aBrand = [dataArray objectAtIndex:i];
        
        if (i % 100 == 0) {
            
            sleep(0.001);
        }
        
//        if (![self existEntityUnique:aBrand.brandId parentId:nil type:CARSOURCE_BRAND_EXIST]) {
        
            CarBrand *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:context];
            
            aEntityMenu.brandId = aBrand.brandId;
            aEntityMenu.brandName = aBrand.brandName;
            aEntityMenu.brandFirstLetter = aBrand.brandFirstLetter;
            
            NSError *erro;
            if (![context save:&erro]) {
                NSLog(@"CarBrand 保存失败：%@",erro);
            }else
            {
                NSLog(@"CarBrand 保存成功");
            }
            
//        }else
//        {
//            NSLog(@"brand存在");
//        }

    }
    
//    for (CarClass *aBrand in dataArray) {
//        
//        
//        if (![self existEntityUnique:aBrand.brandId type:CARSOURCE_BRAND_EXIST]) {
//            
//            CarBrand *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:context];
//            
//            aEntityMenu.brandId = aBrand.brandId;
//            aEntityMenu.brandName = aBrand.brandName;
//            aEntityMenu.brandFirstLetter = aBrand.brandFirstLetter;
//            
//            NSError *erro;
//            if (![context save:&erro]) {
//                NSLog(@"CarBrand 保存失败：%@",erro);
//            }else
//            {
//                NSLog(@"CarBrand 保存成功");
//            }
//            
//        }else
//        {
//            NSLog(@"brand存在");
//        }
//        
//    }
}

- (void)insertCarType:(NSArray *)dataArray unique:(NSString *)unique
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int i = 0; i < dataArray.count; i ++) {
        
        if (i % 100 == 0) {
            
            sleep(0.001);
        }
        
        CarClass *aBrand = [dataArray objectAtIndex:i];
        
//        if (![self existEntityUnique:aBrand.typeName parentId:nil type:CARSOURCE_TYPE_EXIST]) {
            CarType *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarType class]) inManagedObjectContext:context];
            
            aEntityMenu.typeId = aBrand.typeId;
            aEntityMenu.parentId = aBrand.parentId;
            aEntityMenu.firstLetter = aBrand.typeFirstLetter;
            aEntityMenu.typeName = aBrand.typeName;
            
            NSError *erro;
            if (![context save:&erro]) {
                NSLog(@"CarType 保存失败：%@",erro);
            }else
            {
                NSLog(@"CarType 保存成功");
            }
//        }else
//        {
//            NSLog(@"type存在");
//        }

    }
    
//    for (CarClass *aBrand in dataArray) {
//        
//        if (![self existEntityUnique:aBrand.typeId type:CARSOURCE_TYPE_EXIST]) {
//            CarType *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarType class]) inManagedObjectContext:context];
//            
//            aEntityMenu.typeId = aBrand.typeId;
//            aEntityMenu.parentId = aBrand.parentId;
//            aEntityMenu.firstLetter = aBrand.typeFirstLetter;
//            aEntityMenu.typeName = aBrand.typeName;
//            
//            NSError *erro;
//            if (![context save:&erro]) {
//                NSLog(@"CarType 保存失败：%@",erro);
//            }else
//            {
//                NSLog(@"CarType 保存成功");
//            }
//        }else
//        {
//            NSLog(@"type存在");
//        }
//    }
}

- (void)insertCarStyle:(NSArray *)dataArray unique:(NSString *)unique
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int i = 0; i < dataArray.count; i ++) {
        
        if (i % 100 == 0) {
            
            sleep(0.001);
        }
        
        CarClass *aBrand = [dataArray objectAtIndex:i];
        
//        if (![self existEntityUnique:aBrand.styleName parentId:nil type:CARSOURCE_STYLE_EXIST]) {
        
            CarStyle *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarStyle class]) inManagedObjectContext:context];
            
            aEntityMenu.parentId = aBrand.parentId;
            aEntityMenu.styleId = aBrand.styleId;
            aEntityMenu.styleName = aBrand.styleName;
            
            NSError *erro;
            if (![context save:&erro]) {
                NSLog(@"CarStyle 保存失败：%@",erro);
            }else
            {
                NSLog(@"CarStyle 保存成功");
            }
//        }else
//        {
//            NSLog(@"style存在");
//        }
    }
    
//    for (CarClass *aBrand in dataArray) {
//        
//        if (![self existEntityUnique:aBrand.styleId type:CARSOURCE_STYLE_EXIST]) {
//            
//            CarStyle *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarStyle class]) inManagedObjectContext:context];
//            
//            aEntityMenu.parentId = aBrand.parentId;
//            aEntityMenu.styleId = aBrand.styleId;
//            aEntityMenu.styleName = aBrand.styleName;
//            
//            NSError *erro;
//            if (![context save:&erro]) {
//                NSLog(@"CarStyle 保存失败：%@",erro);
//            }else
//            {
//                NSLog(@"CarStyle 保存成功");
//            }
//        }else
//        {
//            NSLog(@"style存在");
//        }
//    }
}

#pragma - mark 查询数据

//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique
{
    if([classType isEqualToString:CARSOURCE_BRAND_QUERY])
    {
//        return [self queryCarBrand];
        
        return [FBCityData queryAllCarBrand];
        
    }else if ([classType isEqualToString:CARSOURCE_TYPE_QUERY])
    {
//        return [self queryCarTypeUnique:unique];
        
        return [FBCityData queryCarTypeWithParentId:unique];
        
    }else if ([classType isEqualToString:CARSOURCE_STYLE_QUERY])
    {
//        return [self queryCarStyleUnique:unique];
        
        return [FBCityData queryCarStyleWithParentId:unique];
        
    }
    return nil;
}

//查询数据的时候使用，不然查出的数据会dealloc

- (NSManagedObjectContext *)context
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

#pragma - mark 查询 车品牌、车型、车款
//车品牌
- (NSArray*)queryCarBrand
{
    NSManagedObjectContext *context = [self context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

//车型
- (NSArray*)queryCarTypeUnique:(NSString *)unique
{
    NSManagedObjectContext *context = [self context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"parentId like[cd] %@",unique];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarType class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

//车款
- (NSArray*)queryCarStyleUnique:(NSString *)unique
{
    NSManagedObjectContext *context = [self context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"parentId like[cd] %@",unique];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarStyle class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

#pragma - mark 判断 车品牌、车型、车款是否已存在

//车品牌是否存在
- (BOOL)brandUnique:(NSString *)unique
{
    NSManagedObjectContext *context = [self context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"brandId like[cd] %@",unique];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma - mark 车品牌、车型、车款是否存在

- (BOOL)existEntityUnique:(NSString *)unique parentId:(NSString *)parentId type:(NSString *)type
{
    NSManagedObjectContext *context = [self context];
    
    unique = (unique != nil) ? unique : @"";
    NSString *entityName = nil;
    NSPredicate *predicate = nil;
    if ([type isEqualToString:CARSOURCE_BRAND_EXIST]) {
        
        predicate = [NSPredicate predicateWithFormat:@"brandId like[cd] %@",unique];
        entityName = NSStringFromClass([CarBrand class]);
        
    }else if ([type isEqualToString:CARSOURCE_TYPE_EXIST])
    {
        predicate = [NSPredicate predicateWithFormat:@"typeName like[cd] %@",unique];
        entityName = NSStringFromClass([CarType class]);
        
    }else if ([type isEqualToString:CARSOURCE_STYLE_EXIST])
    {
        predicate = [NSPredicate predicateWithFormat:@"styleName like[cd] %@",unique];
        entityName = NSStringFromClass([CarStyle class]);
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        return YES;
    }
    
    return NO;
}

@end
