//
//  LCWTools.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshTableView.h"

#import <MessageUI/MessageUI.h>

#import <ShareSDK/ShareSDK.h>

#define FBAUTO_CARSOURCE_TIME @"FBAUTO_CARSOURE_TIME"//车型数据请求时间

#define ERROR_INFO @"erroinfo" //错误信息

#define ERROR_CODE @"errocode" //错误代码

#define NEED_REQUEST_CAR_BRAND @"NEED_REQUEST_CAR_BRAND" //需要请求车型数据

#define UPDATE_CARSOURCE_PARAMS @"UPDATE_CARSOURCE_PARAMS" //更新车源列表筛选条件

#define UPDATE_FINDCAR_PARAMS @"UPDATE_FINDCAR_PARAMS" //更新车源列表筛选条件

#define SHARE_CARSOURCE @"SHARE_CARSOURCE" //车源分享

#define SHARE_FINDCAR @"SHARE_FINDCAR" //寻车分享

#define SHARE_TYPE_KEY @"shareType" //分享key

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

@interface LCWTools : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    urlRequestBlock successBlock;
    urlRequestBlock failBlock;
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
    
    NSString *_downUrl;//更新地址
}
+ (id)shareInstance;


/**
 *  网络请求
 */
- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;//初始化请求

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock;//处理请求结果

- (void)versionForAppid:(NSString *)appid Block:(void(^)(BOOL isNewVersion,NSString *updateUrl,NSString *updateContent))version;

#pragma - mark 获取头像

+ (NSString *)headImageForUserId:(NSString *)userId;

+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;

#pragma - mark 分享

+ (void)shareText:(NSString *)text  title:(NSString *)title image:(UIImage *)aImage linkUrl:(NSString *)linkUrl ShareType:(ShareType)aShareType;


#pragma - mark 小工具

+ (NSString *) md5:(NSString *) text;
+ (void)alertText:(NSString *)text;
+(NSString *)timechange:(NSString *)placetime;
+(NSString *)timechange2:(NSString *)placetime;
+(NSString *)timechange3:(NSString *)placetime;
+(NSString *)timechangeToDateline;

+ (NSString *)currentTime;//当前时间 yyyy-mm-dd

+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

+(void)showDXAlertViewWithText:(NSString *)text;

+ (NSString *)NSStringNotNull:(NSString *)text;

#pragma mark - 计算宽度、高度

+ (CGFloat)widthForText:(NSString *)text font:(CGFloat)size;
+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(CGFloat)size;

/**
 *  验证 邮箱、电话等
 */

+ (BOOL)isValidateInt:(NSString *)digit;
+ (BOOL)isValidateFloat:(NSString *)digit;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateName:(NSString *)userName;
+ (BOOL)isValidatePwd:(NSString *)pwdString;
+ (BOOL)isValidateMobile:(NSString *)mobileNum;

/**
 *  CoreData数据管理
 */

//品牌增、删、查
#define CARSOURCE_BRAND_INSERT @"CAR_BRAND_INSERT"
#define CARSOURCE_BRAND_QUERY @"CAR_BRAND_QUERY"
#define CARSOURCE_BRAND_DELETE @"CAR_BRAND_DELETE"

//车型赠、删、查
#define CARSOURCE_TYPE_INSETT @"CARSOURCE_TYPE_INSETT"
#define CARSOURCE_TYPE_QUERY @"CARSOURCE_TYPE_QUERY"
#define CARSOURCE_TYPE_DELETE @"CARSOURCE_TYPE_DELETE"

//车款赠、删、查
#define CARSOURCE_STYLE_INSETT @"CARSOURCE_STYLE_INSETT"
#define CARSOURCE_STYLE_QUERY @"CARSOURCE_STYLE_QUERY"
#define CARSOURCE_STYLE_DELETE @"CARSOURCE_STYLE_DELETE"

//是否存在
#define CARSOURCE_BRAND_EXIST @"CARSOURCE_BRAND_EXIST"
#define CARSOURCE_TYPE_EXIST @"CARSOURCE_TYPE_EXIST"
#define CARSOURCE_STYLE_EXIST @"CARSOURCE_STYLE_EXIST"

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique;
//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique;

@end
