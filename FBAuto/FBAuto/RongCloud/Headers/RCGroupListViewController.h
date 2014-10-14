//
//  RCGroupListViewController.h
//  iOS-IMKit
//
//  Created by Heq.Shinoda on 14-9-7.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCIMClientHeader.h"
#import "RCBasicViewController.h"


typedef enum{
    TableIsScrollEx = 0,
    TableIsForbiddenScrollEx
}IsAllowScrollEx;

@interface RCGroupListViewController : RCBasicViewController

@property(nonatomic, strong) NSMutableArray* allGroupItemData;//----全部群组消息
@property (strong, nonatomic) UITableView *conversationListView;//----群组列表视图
@property (nonatomic, assign) IsAllowScrollEx isAllowScroll;//----是否可滑动判断
@property (nonatomic, assign) NSInteger editingCellNum;//----当前滑动cell对应数组中的位置。
@property (nonatomic) UIPortraitViewStyle portraitStyle;

- (void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;

/**
 *  刷新群组列表
 */
-(void)refreshGroupList;

/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;

/**
 *  会话列表选中调用
 *
 *  @param conversation 选中单元的会话信息；
 */
-(void)onSelectedTableRow:(RCConversation*)conversation;

/**
 *  把chatController的生命周期加入到ChatList管理中
 *
 *  @param controller
 */
-(void)addChatController:(UIViewController*)controller;
/**
 *  获取chatController
 *
 *  @param targetId
 *  @param conversationType
 *
 *  @return chatController
 */
-(id)getChatController:(NSString*)targetId conversationType:(RCConversationType)conversationType;
@end
