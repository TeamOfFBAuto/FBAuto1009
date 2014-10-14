//
//  RCConversationSettingViewController.h
//  RCIM
//
//  Created by xugang on 6/16/14.
//  Copyright (c) 2014 RongCloud. All rights reserved.
//

#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"
#import "RCRenameViewController.h"
#import "RCSelectPersonViewController.h"
//@class RCBasicViewController;

@interface RCChatSettingViewController : RCBasicViewController<RenameViewControllerDelegate,RCSelectPersonViewControllerDelegate>{
    
    NSInteger __count;
}
@property (nonatomic,strong) UITableView *tableView;

//用于表格
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *HeadsPadView;
@property (nonatomic,strong) UIView *OuterHeadPadView;
@property (nonatomic,strong) NSMutableArray *iconArray;
//对方ID或者群ID
@property (nonatomic,strong) NSString *targetId;
@property (nonatomic,assign) RCConversationType conversationType;

@property (nonatomic,strong)  RCDiscussion* discussionInfo;

//功能列表
@property (nonatomic,strong) NSMutableArray *cellArray;
@property (nonatomic) UIPortraitViewStyle portraitStyle;

//成员信息--》废弃
@property (nonatomic,strong) NSMutableArray *memberInfos;

//讨论组IDs
@property (nonatomic,strong) NSArray *memberUserIds;

//成员数目
@property (nonatomic,assign) NSInteger  memberCount;

@property (nonatomic,assign) UILabel *discussionNameLabel;

@property (nonatomic,strong) UISwitch *TopControl;
@property (nonatomic,strong) UISwitch *messageControl;
@property (nonatomic,strong) UISwitch *inviteControl;


- (void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;

/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  重命名讨论组的名字
 *
 *  @param conversationType
 *  @param targetId
 *  @param oldName          
 */
-(void)renameDiscussionName:(RCConversationType)conversationType targetId:(NSString*)targetId oldName:(NSString*)oldName;

/**
 *  重载：点击添加按钮时间
 *
 *  @param conversationType
 */
-(void)onAddButtonClicked:(RCConversationType)conversationType;

/**
 *  更新讨论组信息
 *
 *  @param discussionInfo
 */
-(void)needUpdateDiscussionInfo:(RCDiscussion*)discussionInfo;

/**
 *  根据用户id获取用户信息
 *
 *  @param userId
 *
 *  @return
 */
-(RCUserInfo*)getUserInfoWithUserId:(NSString*)userId;


/**
 *  获取当前用户ID
 *
 *  @return 获取当前用户ID
 */
-(NSString*)getCurrentUserId;



@end
