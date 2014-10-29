//
//  AppDelegate.m
//  FBAuto
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.



#import "AppDelegate.h"


#import "CarResourceViewController.h"//车源类

#import "SendCarViewController.h"//发布

#import "FindCarViewController.h"//寻车

//#import "PersonalViewController.h"//个人中心

#import "GloginViewController.h"//登录页面

#import "ASIHTTPRequest.h"

#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import <JSONKit.h>

#import "MobClick.h"

#import "sys/utsname.h"

#import "FBCityData.h"

#import "DXAlertView.h"

#import "CarBrand.h"
#import "CarStyle.h"
#import "CarType.h"
#import "CarClass.h"

#import "CarUpdateClass.h"

//shareSDK fbauto2014@qq.com 123abc
//新浪 fbauto2014@qq.com  123abc 或者 fbauto2014
// 邮箱 fbauto2014@qq.com
// QQ: 2609534839
// 密码: 123abc

//友盟账号
//112xiangtao@163.com  密码 15194772354

/*********
 shareSDK 和 Umeng
 *********/

//e车是国内专业的针对车商的汽车流通信息平台，销售人员必备的汽车销售利器。

#define UMENG_APPKEY @"540ea323fd98c54048003577" //友盟appkey

#define Appkey @"2831cfc47791"
#define App @"2354df12a6dd38312f3425b39e735d21"

#define SinaAppKey @"2437553400"
#define SinaAppSecret @"7379cf0aa245ba45a66cc7c9ae9b1dba"

#define QQAPPID @"1101950003" //十六进制:41AE6C33; 生成方法:echo 'ibase=10;obase=16;1101950003'|bc
#define QQAPPSECRECT @"JAtVGEGeQWk9icsK"

#define WXAPPID @"wx0ad0d507a8933b9d"

#define RedirectUrl @"http://www.sina.com"

/*********
 融云
 *********/

//#define RCIM_APPKEY @"cpj2xarlj0xdn" //融云appkey
//#define RCIM_APPSECRET @"BJs1fiJAvGtqAy" //appSecret  （）

#define RCIM_APPKEY @"pgyu6atqyd6xu" //融云appkey
#define RCIM_APPSECRET @"K8J5FQ5JS151l" //appSecret  （）


@implementation AppDelegate
{
    NSString *_fromPhone;//消息来源号码
    
    MBProgressHUD *loading;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    sleep(1);
    
    
    NSLog(@"didFinishLaunchingWithOptions");
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //网络监控
    
    [self observeNetwork];

    //注册远程通知
    
    [RCIM initWithAppKey:RCIM_APPKEY deviceToken:nil];
    
#ifdef __IPHONE_8_0
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    
    
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:settings];
        } else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:myTypes];
        }
#else
    // 注册苹果推送，申请推送权限。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
    
    //UIApplicationLaunchOptionsRemoteNotificationKey,判断是通过推送消息启动的
    
    NSDictionary *infoDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (infoDic)
    {
        NSLog(@"infoDic %@",infoDic);
        
        self.pushUserInfo = infoDic;
    }
    
    [self rongCloud]; //融云即时通讯
    
    [ShareSDK registerApp:Appkey]; //ShareSDK 分享
    [self initSharePlat];
    
    [MobClick startWithAppkey:UMENG_APPKEY]; //友盟统计

    
    //版本更新
    
     //test FBLife 605673005 fbauto
    [[LCWTools shareInstance]versionForAppid:@"904576362" Block:^(BOOL isNewVersion, NSString *updateUrl, NSString *updateContent) {
       
        NSLog(@"updateContent %@ %@",updateUrl,updateContent);
        
    }];
    
    //车型数据更新
    [self getCarUpdateState];

    self.window.rootViewController = [self preprareViewControllers];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - 网络请求判断是否需要更新车型数据

- (void)getCarUpdateState
{
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_UPDATESTATE];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
    
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
            if ([dataInfo isKindOfClass:[NSDictionary class]])
            {
                NSString *time = [dataInfo objectForKey:@"time"];
                
                if (time.length == 0) {
                    return ;
                }
                
                NSLog(@"time %@",time);
                
                
                NSString *localTimeline = [LCWTools cacheForKey:CAR_UPDATE_DATE_LOCAL];
                
                localTimeline = localTimeline.length ? localTimeline : @"0";
                
                if (![localTimeline isEqualToString:time]) {
                    
                    //需要更新
                    
                    NSLog(@"需要更新");
                    
                    UIView *window = self.window;
                    
                    loading = [LCWTools MBProgressWithText:@"车型数据更新中..." addToView:window];
                    
                    [self getCarDataFromDateline:localTimeline endTimeline:time];
                }
            }
        }

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
    }];
}


#pragma - mark 网络获取车型数据(根据时间间隔获取更新部分数据)

- (void)getCarDataFromDateline:(NSString *)startTimeLine
                   endTimeline:(NSString *)endTimeline
{
    [loading show:YES];
    
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_GETUPDATEDATE,startTimeLine,endTimeline];
    LCWTools *tools = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            
            if (erroCode == 0) {
                
                NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
                if ([dataInfo isKindOfClass:[NSDictionary class]]) {
                    
                    [self updateLocalCarData:dataInfo endTime:endTimeline];
                }
            }
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        [loading hide:YES];
    }];
}

//更新本地车型数据(需要更改或添加)

- (void)updateLocalCarData:(NSDictionary *)result endTime:(NSString *)endTime
{
    NSArray *brand = [result objectForKey:@"brand"];
    if (brand.count > 0) {
        
        //更新或者添加
        
        for (NSDictionary *aDic in brand) {
            
            CarUpdateClass *update = [[CarUpdateClass alloc]initWithDictionary:aDic];
            
            NSString *brandId = [self carCodeForIndex:[update.list_index intValue]];
            
            if ([FBCityData existCarBrandId:brandId]) {
                
                [FBCityData updateCarBrandId:brandId brandName:update.name firstLetter:update.eindex];
            }else
            {
                [FBCityData insertCarBrandId:brandId brandName:update.name firstLetter:update.eindex];
            }
            
            NSLog(@"brand--->");
        }
        
    }
    
    NSArray *series = [result objectForKey:@"series"];
    if (series.count > 0) {
        
        for (NSDictionary *aDic in series) {
            
            CarUpdateClass *update = [[CarUpdateClass alloc]initWithDictionary:aDic];
            NSString *parentId = [self carCodeForIndex:[update.pid intValue]];
            NSString *typeId = [self carCodeForIndex:[update.list_index intValue]];
            NSString *codeId = [NSString stringWithFormat:@"%@%@",parentId,typeId];
            
            if ([FBCityData existCarTypeId:codeId]) {
                
                [FBCityData updateCarTypeId:codeId typeName:update.name firstLetter:update.eindex];
            }else
            {
                [FBCityData insertCarTypeId:typeId parentId:parentId typeName:update.name firstLetter:update.eindex];
            }
            NSLog(@"type--->");
        }
    }
    
    NSArray *models = [result objectForKey:@"models"];
    
    if (models.count > 0) {
        
        for (NSDictionary *aDic in models) {
            
            CarUpdateClass *update = [[CarUpdateClass alloc]initWithDictionary:aDic];
            NSString *parentId_p = [self carCodeForIndex:[update.ppid intValue]];
            NSString *parentId = [self carCodeForIndex:[update.pid intValue]];
            NSString *styleId = [self carCodeForIndex:[update.list_index intValue]];
            NSString *codeId = [NSString stringWithFormat:@"%@%@%@",parentId_p,parentId,styleId];
            
            if ([FBCityData existCarStyleId:codeId]) {
                
                [FBCityData updateCarStyleId:codeId StyleName:update.name];
            }else
            {
                
                NSString *p_id = [NSString stringWithFormat:@"%@%@",parentId_p,parentId];
                [FBCityData insertCarStyleId:styleId parentId:p_id StyleName:update.name];
            }
            NSLog(@"style--->");
        }
    }
    
    [LCWTools cache:endTime ForKey:CAR_UPDATE_DATE_LOCAL];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CARSOURCE_PARAMS object:nil];//通知更新
    
    [loading hide:YES];
}

/**
 *  一位数补两个0，两位数补一个0，三个数不用补
 *
 *  @param index 数组下标
 */
- (NSString *)carCodeForIndex:(int)index
{
    NSString *code = @"";
    if (index < 10)
    {
        code = [NSString stringWithFormat:@"00%d",index];
        
    }else if (index < 100)
    {
        code = [NSString stringWithFormat:@"0%d",index];
        
    }else
    {
        code = [NSString stringWithFormat:@"0%d",index];
    }
    return code;
}


#pragma mark - 获取通知

- (void)getNotice
{
    NSString *url = [NSString stringWithFormat:FBAUTO_NOTICE_TIME];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
            if ([dataInfo isKindOfClass:[NSDictionary class]])
            {
                NSString *time = [dataInfo objectForKey:@"time"];
                
                if (time.length == 0) {
                    return ;
                }
                
                NSLog(@"time %@",time);
                
                NSString *localTimeline = [LCWTools cacheForKey:NOTICE_UPDATE_DATE_LOCAL];
                
                localTimeline = localTimeline.length ? localTimeline : @"0";
                
                if (![localTimeline isEqualToString:time]) {
                    
                    NSLog(@"新通知");
                    
                    [self getNoticeFromDateline:localTimeline endTimeline:time];
                }
            }
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
    }];

}


- (void)getNoticeFromDateline:(NSString *)startTimeLine
                   endTimeline:(NSString *)endTimeline
{
    [loading show:YES];
    
    NSString *url = [NSString stringWithFormat:FBAUTO_NOTICE_NEW_COUNT,startTimeLine,endTimeline];
    LCWTools *tools = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            
            if (erroCode == 0) {
                
                int dataInfo = [[result objectForKey:@"datainfo"]integerValue];
                
                NSLog(@"新通知个数%d",dataInfo);
                
                int number = [[RCIM sharedRCIM] getTotalUnreadCount];
                
                [self updateTabbarNumber:(number + dataInfo)];
                
                [LCWTools cache:[NSString stringWithFormat:@"%d",dataInfo] ForKey:NOTICE_NEW_COUNT];
                
                [LCWTools cache:endTimeline ForKey:NOTICE_UPDATE_DATE_LOCAL];
                
            }
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
    }];
}


#pragma mark - 创建视图

- (UITabBarController *)preprareViewControllers
{
    CarResourceViewController * rootVC = [[CarResourceViewController alloc] init];
    
    SendCarViewController * fabuCarVC = [[SendCarViewController alloc] init];
    fabuCarVC.actionStyle = Action_Add;
    
    FindCarViewController * searchCarVC = [[FindCarViewController alloc] init];
    
    self.perSonalVC = [[PersonalViewController alloc] init];
    
    
    UINavigationController * navc1 = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    UINavigationController * navc2 = [[UINavigationController alloc] initWithRootViewController:fabuCarVC];
    
    UINavigationController * navc3 = [[UINavigationController alloc] initWithRootViewController:searchCarVC];
    
    UINavigationController * navc4 = [[UINavigationController alloc] initWithRootViewController:_perSonalVC];
    
    
    rootVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"车源" image:[UIImage imageNamed:@"cheyuan_down46_46"] tag:0];
    
    fabuCarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发布" image:[UIImage imageNamed:@"fabu_down46_46"] tag:1];
    
    searchCarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"求购" image:[UIImage imageNamed:@"xunche_down46_46"] tag:2];
    
    _perSonalVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"geren_down46_46"] tag:3];
    
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    tabbar.delegate = self;
    tabbar.tabBar.backgroundImage=[UIImage imageNamed:@"testV.png"];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:232.0/255.0f green:128/255.0f blue:24/255.0f alpha:1]];
    
    tabbar.viewControllers = [NSArray arrayWithObjects:navc1,navc2,navc3,navc4,nil];
    
    //将状态栏设置成自定义颜色
    
    if (IOS7_OR_LATER) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    return tabbar;
}

#pragma mark - 消息提示

- (void)initMessageAlert
{
    CGFloat aHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.statusBarBack = [[UIWindow alloc]initWithFrame:CGRectMake(200, 0, 80, aHeight)];
    _statusBarBack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"daohanglan_bg_640_88"]];
    [_statusBarBack setWindowLevel:UIWindowLevelStatusBar];
    [_statusBarBack makeKeyAndVisible];
    
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _statusBarBack.width, _statusBarBack.height)];
    _messageLabel.textColor = [UIColor orangeColor];
    _messageLabel.font = [UIFont systemFontOfSize:12];
    [_statusBarBack addSubview:_messageLabel];
    
    _statusBarBack.hidden = YES;
}

#pragma mark - 更新底部数字
- (void)updateTabbarNumber:(int)number
{
    NSString *number_str = nil;
    if (number > 0) {
        number_str = [NSString stringWithFormat:@"%d",number];
    }
    
    _perSonalVC.tabBarItem.badgeValue = number_str;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [number_str intValue];
}

#pragma mark -  融云即时通讯

- (void)rongCloud
{
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM]setConnectionStatusDelegate:self];
    // 设置用户信息提供者。
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
    
}
- (void)loginRongCloud
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL loginSuccess = [defaults boolForKey:LOGIN_SUCCESS];
    NSString *loginToken = [defaults objectForKey:RONGCLOUD_TOKEN];
    
    if (loginSuccess && loginToken.length > 0)
    {
        
        [RCIM connectWithToken:loginToken completion:^(NSString *userId) {
            
            NSLog(@"登录成功! %@",userId);
            
            
        } error:^(RCConnectErrorCode status) {
            
            NSLog(@"%@",[NSString stringWithFormat:@"登录失败！\n Code: %d！",status]);
            
            [defaults setBool:NO forKey:LOGIN_SUCCESS];
            
            [defaults synchronize];
            
            
            if(status == ConnectErrorCode_TOKEN_INCORRECT){
                
                NSLog(@"令牌有问题");
                
                __weak typeof(_perSonalVC)weakVc = _perSonalVC;
                
                DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"令牌失效,重新登录" contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
                [alert show];
                
                alert.rightBlock = ^(){
                    NSLog(@"取消");
                    [weakVc tuichuDenglu];
                };
            }
            
        }];
    }

}

#pragma mark -  ShareSDK分享

- (void)initSharePlat
{
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:SinaAppKey
                               appSecret:SinaAppSecret
                             redirectUri:RedirectUrl];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:SinaAppKey
                                appSecret:SinaAppSecret
                              redirectUri:RedirectUrl
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQAPPID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:WXAPPID
                           wechatCls:[WXApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQAPPID
                           appSecret:QQAPPSECRECT
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}


#pragma  mark - 监控网络状态

- (void)observeNetwork
{
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostname:FBAUTO_HOST];
    
    //开始监听，会启动一个run loop
    [self.hostReach startNotifier];
}

-(void)reachabilityChanged:(NSNotification *)note
{
    
    Reachability *currReach = [note object];
    
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    
    //如果没有连接到网络就弹出提醒实况
    
    self.isReachable = YES;
    
    if(status == NotReachable)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        
//        [alert show];
        
        self.isReachable = NO;
        
        return;
    }
    
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
//        [alert show];
        
        self.isReachable = YES;
        
    }
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"didSelectViewController %d",tabBarController.selectedIndex);
    
    if (tabBarController.selectedIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CARSOURCE_PARAMS object:nil];
    }else if (tabBarController.selectedIndex == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_FINDCAR_PARAMS object:nil];
    }else if(tabBarController.selectedIndex == 3){
//        viewController.tabBarItem.badgeValue = @"3";
    }
    
    
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    NSLog(@"req %@",req);
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"req %@",resp);
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    [self loginRongCloud];
    
    int number = [[RCIM sharedRCIM] getTotalUnreadCount];
    
    if (number < 0) {
        number = 0;
    }
    
    [self updateTabbarNumber:number];
    
    
    [self getNotice];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

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

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - 上传的代理回调方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传完成");
    
    if (request.tag == 123)//上传用户头像
    {
        NSLog(@"走了555");
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
        NSLog(@"tupiandic==%@",dic);
        
        if ([[dic objectForKey:@"errcode"]intValue] == 0) {
            NSString *str = @"no";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
            
        }else{
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
        }
        //发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
}

#pragma - mark 远程通知

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// 获取苹果推送权限成功。

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
   
    // 设置 deviceToken。
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
    
    NSLog(@"My token is: %@", deviceToken);
    
    
    NSString *string_pushtoken=[NSString stringWithFormat:@"%@",deviceToken];
    
    while ([string_pushtoken rangeOfString:@"<"].length||[string_pushtoken rangeOfString:@">"].length||[string_pushtoken rangeOfString:@" "].length) {
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:string_pushtoken forKey:DEVICETOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    NSLog(@"erro  %@",str);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:str delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@" 收到推送消息： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
//    UIApplicationStateInactive {
//        aps =     {
//            alert = "\U60a8\U6536\U5230\U4e00\U6761\U79bb\U7ebf\U6d88\U606f";
//            badge = 1;
//            headimg = "http://bbs.fblife.com/ucenter/avatar.php?uid=1&type=virtual&size=middle";
//            sound = default;
//            tophone = 18612389982;
//            type = 1;
//        };
//    }
    
    //正在前台,获取推送时，此处可以获取
    //后台，点击进入,此处可以获取
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive){
        NSLog(@"UIApplicationStateInactive %@",userInfo);

        //通过消息进入程序
        
        [self dealOfflineMessage:userInfo];
        
    }
    if (state == UIApplicationStateActive) {
        NSLog(@"UIApplicationStateActive %@",userInfo);
        //程序就在前台
        //弹框
//        [self dealOfflineMessage:userInfo];
    }
    if (state == UIApplicationStateBackground)
    {
        NSLog(@"UIApplicationStateBackground %@",userInfo);
        
        [LCWTools showMBProgressWithText:@"backgroud" addToView:self.window];
    }
}

- (void)dealOfflineMessage:(NSDictionary *)userInfo
{
    //点击消息进入走此处,做相应处理
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *headimg = [aps objectForKey:@"headimg"];
    NSString *fromphone = [aps objectForKey:@"fromphone"];
    NSString *fromId = [aps objectForKey:@"fromuid"];
    NSString *type = [aps objectForKey:@"type"];
    
    
//    [LCWTools alertText:[NSString stringWithFormat:@"%@ %@ %@",fromphone,fromId,type]];
    
    NSLog(@"aps --- >%@ %@ %@",headimg,fromphone,type);
    
    if ([type integerValue] == 1) {
        NSLog(@"聊天离线消息");
    }

}

#pragma mark - RCIM接受消息代理

-(void)didReceivedMessage:(RCMessage *)message left:(int)nLeft
{
    if (0 == nLeft) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"unReadNumber" object:nil];
            
            int number = [[RCIM sharedRCIM] getTotalUnreadCount];
            
            int notice = [[LCWTools cacheForKey:NOTICE_NEW_COUNT]integerValue];
            [self updateTabbarNumber:number + notice];
            
        });
    }
}

#pragma mark - RCIM监控连接状态

-(void)responseConnectionStatus:(RCConnectionStatus)status{
    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"" message:@"您已下线，重新连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
            alert.tag = 2000;
            [alert show];
        });
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (2000 == alertView.tag) {
        
        if (0 == buttonIndex) {
            
            NSLog(@"NO");
            
            //不重新连接直接跳转到登录页面
            
            [_perSonalVC tuichuDenglu];
        }
        
        if (1 == buttonIndex) {
            
            NSLog(@"YES");
            
            [RCIMClient reconnect:nil];
        }
    }
}

#pragma mark - RCIMUserInfoFetcherDelegagte <NSObject>

/**
 *  获取用户信息。
 *
 *  @param userId 用户 Id。
 *
 *  @return 用户信息。
 */
-(RCUserInfo*)getUserInfoWithUserId:(NSString*)userId
{
    NSLog(@"userId %@",userId);
    
    if ([userId isEqualToString:[GMAPI getUid]]) {
        
        NSString *headImage = [FBChatTool getUserHeadImageForUserId:userId];
        RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:[GMAPI getUsername] portrait:headImage];
        
        NSLog(@"user image %@",headImage);
        
        return user;
    }else
    {
       
        
        NSString *userName = [FBChatTool getUserNameForUserId:userId];
        if (userName == nil || userName.length == 0) {
            
            [self getPersonalInfo:userId];//获取个人信息
        }
        
        NSString *headImage = [FBChatTool getUserHeadImageForUserId:userId];
        RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:userName portrait:headImage];
        
        return user;
    }
    
    
    return nil;
}

/**
 *  连接服务器的回调。
 */
#pragma mark -  RCConnectDelegate <NSObject>

/**
 *  回调成功。
 *
 *  @param userId 当前登录的用户 Id，既换取登录 Token 时，App 服务器传递给融云服务器的用户 Id。
 */
- (void)responseConnectSuccess:(NSString*)userId
{
    
}

/**
 *  回调出错。
 *
 *  @param errorCode 连接错误代码。
 */
- (void)responseConnectError:(RCConnectErrorCode)errorCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:LOGIN_SUCCESS];
    
    [defaults synchronize];
    
    if(errorCode == ConnectErrorCode_TOKEN_INCORRECT){
        
        NSLog(@"令牌有问题");
        
        __weak typeof(_perSonalVC)weakVc = _perSonalVC;
        
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"令牌失效,重新登录" contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        
        alert.rightBlock = ^(){
            NSLog(@"取消");
            [weakVc tuichuDenglu];
        };
    }
}

//获取个人信息
-(void)getPersonalInfo:(NSString *)userId
{
    //请求地址str
    NSString *str = [NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION,userId];
    
    NSLog(@"请求用户信息接口 %@",str);
    LCWTools *tool = [[LCWTools alloc]initWithUrl:str isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
            if ([dataInfo isKindOfClass:[NSDictionary class]])
            {
                NSString *name = [dataInfo objectForKey:@"name"];
                
                NSString *headImage = [dataInfo objectForKey:@"headimage"];
                
                [FBChatTool cacheUserName:name forUserId:userId];
                [FBChatTool cacheUserHeadImage:headImage forUserId:userId];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_USERINFO object:nil];
            }
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        ;
    }];
}

@end
