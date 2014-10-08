//
//  RCIM.h
//  RCIM
//  ios -IMKit Version 0.9.1005.0900
//  Created by Heq.Shinoda on 14-5-27.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCClientDelegate.h"
#import "RCUserInfo.h"
#import "RCGroup.h"

@class RCChatListViewController;
@class RCChatViewController;

/**
 *  用户信息的获取器。
 *
 *  如果在聊天中遇到的聊天对象是没有登录过的用户（即没有通过融云服务器鉴权过的），RongIM 是不知道用户信息的，RongIM 将调用此 Delegagte 获取用户信息。
 */
@protocol RCIMUserInfoFetcherDelegagte <NSObject>

/**
 *  获取用户信息。
 *
 *  @param userId 用户 Id。
 *
 *  @return 用户信息。
 */
-(RCUserInfo*)getUserInfoWithUserId:(NSString*)userId;
@end

/**
 *  好友列表的获取器。
 *
 *  RongIM 本身不保存 App 的好友关系，如果在聊天中需要使用好友关系时（如：需要选择好友加入群聊），RongIM 将调用此 Delegagte 获取好友列表信息。
 */
@protocol RCIMFriendsFetcherDelegate <NSObject>

/**
 *  获取好友信息列表。
 *
 *  @return 好友信息列表。
 */
-(NSArray*)getFriends;
@end

/**
 *  群组信息的获取器。
 *
 *  RongIM 本身不保存群组信息，如果在聊天中需要使用群组信息，RongIM 将调用此 Delegagte 获取群组信息。
 */
@protocol RCIMGroupInfoFetcherDelegate <NSObject>

/**
 *  获取群组信息。
 *
 *  @param groupId 群组 Id。
 *
 *  @return 群组信息。
 */
-(RCGroup*)getGroupInfoWithGroupId:(NSString*)groupId;
@end


/**
 *  接收消息的监听器。
 */
@protocol RCIMReceiveMessageDelegate <NSObject>

/**
 *  接收消息到消息后执行。
 *
 *  @param message 接收到的消息。
 */
-(void)didReceivedMessage:(RCMessage*)message left:(int)nLeft;
@end

/**
 *  连接状态变化的监听器。
 */
@protocol RCIMConnectionStatusDelegate <NSObject>

/**
 *  IM收到连接变化
 *
 *  @param status 连接状态
 */

-(void)responseConnectionStatus:(RCConnectionStatus)status;
@end
/**
 *  IM 界面组件核心类。
 *
 *  所有 IM 相关界面、功能都由此调用和设置。
 */
@interface RCIM : NSObject

/**
 *  获取界面组件的核心类单例。
 *
 *  @return 界面组件的核心类单例。
 */
+(RCIM*)sharedRCIM;

/**
 *  初始化 SDK。
 *
 *  @param appKey   从开发者平台申请的应用 appKey。
 *  @param deviceToken 用于 Apple Push Notification Service 的设备唯一标识。
 */
+(void)initWithAppKey:(NSString*)appKey deviceToken:(NSData*)deviceToken;

/**
 *  设置DeviceToken
 *
 *  @param deviceToken 从苹果服务器获取的设备唯一标识
 */
-(void)setDeviceToken:(NSData*)deviceToken;

/**
 *  IM 界面组件登录。
 *
 *  @param token      从服务端获取的用户身份令牌（Token）。
 *  @param completion 调用完成的处理。
 *  @param error      调用返回的错误信息。
 */
+(void)connectWithToken:(NSString*)token completion:(void (^)(NSString* userId))completion error:(void (^)(RCConnectErrorCode status))error;

/**
 *  注销当前登录。
 */
-(void)disconnect:(BOOL)isReceivePush;

/**
 *  注销当前登录。
 */
-(void)disconnect;

/**
 *  创建会话列表界面，供应用程序使用。
 *
 *  @param completion 调用完成的处理。
 *
 *  @return return 会话列表的视图控制器。
 */
-(RCChatListViewController*)createConversationList:(void(^)(void))completion;

/**
 *  启动会话列表界面。
 *
 *  @param viewController 会话列表的视图控制器。
 *  @param completion     调用完成的处理。
 */
-(void)launchConversationList:(UIViewController*)viewController completion:(void(^)(void))completion;

/**
 *  创建单聊界面，供应用程序使用。
 *
 *  @param targetUserId 要与之聊天的用户 Id。
 *  @param title        聊天的标题，如果传入空值，则默认显示与之聊天的用户名称。
 *  @param completion   调用完成的处理。
 *
 *  @return 单聊的视图控制器。
 */

-(RCChatViewController*)createPrivateChat:(NSString*)targetUserId title:(NSString*)title completion:(void(^)(void))completion;

/**
 *  启动单聊界面。
 *
 *  @param viewController 单聊的视图控制器。
 *  @param targetUserId   要与之聊天的用户 Id。
 *  @param title          聊天的标题，如果传入空值，则默认显示与之聊天的用户名称。
 *  @param completion     调用完成的处理。
 */
-(void)launchPrivateChat:(UIViewController*)viewController targetUserId:(NSString*)targetUserId title:(NSString*)title completion:(void(^)(void))completion;

/**
 *  启动群组聊天界面
 *
 *  @param viewController 视图控制器。
 *  @param targetGroupId  群组Id。
 *  @param title          聊天的标题，如果传入空值，则默认显示群组名称。
 *  @param completion     调用完成的处理。
 */
-(void)launchGroupChat:(UIViewController*)viewController targetGroupId:(NSString*)targetGroupId title:(NSString*)title completion:(void(^)(void))completion;

/**
 *  启动群组聊天界面
 *
 *  @param targetGroupId 群组Id。
 *  @param title         聊天的标题，如果传入空值，则默认显示群组名称。
 *  @param completion    调用完成的处理。
 *
 *  @return 群组聊天的视图控制器。
 */
-(RCChatViewController*)createGroupChat:(NSString*)targetGroupId title:(NSString*)title completion:(void(^)(void))completion;


/**
 *  创建客户服聊天界面。
 *
 *  @param customerServiceUserId 要与之聊天的客服 Id。
 *  @param title                 聊天的标题，如果传入空值，则默认显示与之聊天的客服名称。
 *  @param completion            调用完成的处理。
 */
-(RCChatViewController*)createCustomerService:(NSString *)customerServiceUserId title:(NSString *)title completion:(void(^)(void))completion;

/**
 *  启动客户服聊天界面。
 *
 *  @param viewController        客服聊天的视图控制器。
 *  @param customerServiceUserId 要与之聊天的客服 Id。
 *  @param title                 聊天的标题，如果传入空值，则默认显示与之聊天的客服名称。
 *  @param completion            调用完成的处理。
 */
-(void)launchCustomerServiceChat:(UIViewController*)viewController customerServiceUserId:(NSString*)customerServiceUserId title:(NSString*)title completion:(void(^)(void))completion;

/**
 *  以当前用户的身份发送一条消息。
 *  
 *  此处仅为扩展功能提供，默认可以不做实现。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param content          消息内容。
 *  @param delegate         发送消息的回调。
 *
 *  @return 发送的消息实体。
 */
-(RCMessage*)sendMessage:(RCConversationType)conversationType targetId:(NSString*)targetId content:(RCMessageContent*)content delegate:(id<RCSendMessageDelegate>)delegate;

/**
 *  获取会话列表。
 *
 *  会话列表按照时间从前往后排列，如果有置顶会话，则置顶会话在前。
 *
 *  @return 会话列表，返回 RCConversation 数组。
 */
-(NSArray*)getConversationList;

/**
 *  获取所有未读消息数。
 *
 *  @return 未读消息数。
 */
-(int)getTotalUnreadCount;

/**
 *  获取来自某用户（某会话）的未读消息数。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *
 *  @return 未读消息数。
 */
-(int)getUnreadCount:(RCConversationType)conversationType targetId:(NSString*)targetId;

/**
 *  设置获取用户信息的获取器，供 RongIM 调用获取用户名称和头像信息。
 *
 *  @param delegate        用户信息获取器。
 *  @param isCacheUserInfo 设置是否由 IMKit 来缓存用户信息。<br>
 *            如果 App 提供的 RCIMUserInfoFetcherDelegagte 每次都需要通过网络请求用户数据，而不是将用户数据缓存到本地，会影响用户信息的加载速度；<br>
 *            此时最好将本参数设置为 true，由 IMKit 来缓存用户信息。
 */
+(void)setUserInfoFetcherWithDelegate:(id<RCIMUserInfoFetcherDelegagte>)delegate isCacheUserInfo:(BOOL)isCacheUserInfo;

/**
 *  设置获取好友列表的获取器，供 RongIM 调用获取好友列表以及好友的名称和头像信息。
 *
 *  @param delegate 获取好友列表的获取器。
 */
+(void)setFriendsFetcherWithDelegate:(id<RCIMFriendsFetcherDelegate>)delegate;

/**
 *  设置获取群组信息的获取器，供 RongIM 调用获取群组名称和头像信息。
 *
 *  @param delegate 群组信息获取器。
 */
+(void)setGroupInfoFetcherWithDelegate:(id<RCIMGroupInfoFetcherDelegate>)delegate;

/**
 *  设置接收消息的监听器。
 *
 *  所有接收到的消息、通知、状态都经由此处设置的监听器处理。包括单聊消息、讨论组消息、群组消息、聊天室消息以及各种状态。<br>
 *  此处仅为扩展功能提供，默认可以不做实现。
 *
 *  @param delegate 接收消息的监听器。
 */
-(void)setReceiveMessageDelegate:(id<RCIMReceiveMessageDelegate>)delegate;

/**
 *  设置连接状态变化的监听器。
 *
 *  @param delegate 连接状态变化的监听器。
 */
-(void)setConnectionStatusDelegate:(id<RCIMConnectionStatusDelegate>)delegate;

/**
 *  获取会话消息提醒状态。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param completion       调用完成的处理。
 *  @param error            调用返回的错误信息。
 */
-(void)getConversationNotificationStatus:(RCConversationType)conversationType targetId:(NSString*)targetId completion:(void (^)(RCConversationNotificationStatus nStatus))completion error:(void (^)(RCErrorCode status))error;

/**
 *  设置会话消息提醒状态。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param isBlocked        是否屏蔽。
 *  @param completion       调用完成的处理。
 *  @param error            调用返回的错误信息。
 */
-(void)setConversationNotificationStatus:(RCConversationType)conversationType targetId:(NSString*)targetId isBlocked:(BOOL)isBlocked completion:(void (^)(RCConversationNotificationStatus nStatus))completion error:(void (^)(RCErrorCode status))error;

/**
 *  设置用户头像点击事件。
 *
 *  @param clickEvent 点击头像的处理。
 */
-(void)setUserPortraitClickEvent:(void(^)(UIViewController *viewController, RCUserInfo *userInfo))clickEvent;

/**
 *  同步当前用户的群组信息。
 *
 *  @param groupList  群组对象列表。
 *  @param completion 调用完成的处理。
 *  @param error      调用返回的错误信息。
 */
-(void)syncGroups:(NSArray*)groupList completion:(void (^)())completion error:(void (^)(RCErrorCode status))error;

/**
 *  加入群组。
 *
 *  @param groupID    群组Id。
 *  @param groupName  群组名称。
 *  @param completion 调用完成的处理。
 *  @param error      调用返回的错误信息。
 */
-(void)joinGroup:(NSString*)groupID groupName:(NSString*)groupName completion:(void (^)())completion error:(void (^)(RCErrorCode status))error;

/**
 *  退出群组。
 *
 *  @param groupID    群组Id。
 *  @param completion 调用完成的处理。
 *  @param error      调用返回的错误信息。
 */
-(void)quitGroup:(NSString*)groupID completion:(void (^)())completion error:(void (^)(RCErrorCode status))error;

/**
 *  获取当前组件的版本号。
 *
 *  @return 当前组件的版本号。
 */
+(NSString*)getLibraryVersion;
@end
