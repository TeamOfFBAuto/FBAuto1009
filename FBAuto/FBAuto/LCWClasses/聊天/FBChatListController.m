//
//  FBChatListController.m
//  FBAuto
//
//  Created by lichaowei on 14-10-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBChatListController.h"

#import "FBChatViewController.h"

@implementation FBChatListController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //自定义导航标题颜色
    [self setNavigationTitle:@"会话" textColor:[UIColor whiteColor]];
    //自定义导航左右按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
    [leftButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftButton;
    //自定义导航左右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nil;
    
}


-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
}

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender <#sender description#>
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    //跳转好友列表界面，可是是融云提供的UI组件，也可以是自己实现的UI
    RCSelectPersonViewController *temp = [[RCSelectPersonViewController alloc]init];
    //控制多选
    temp.isMultiSelect = YES;
    temp.portaitStyle = UIPortraitViewRound;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:temp];
    //导航和的配色保持一直
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    temp.delegate = self;
    [self presentModalViewController:nav animated:YES];
}

-(void)didSelectedPersons:(NSArray*)selectedArray viewController:(RCSelectPersonViewController *)viewController
{
    if(selectedArray == nil || selectedArray.count == 0)
    {
        NSLog(@"Select person array is nil");
        return;
    }
    int count = (int)selectedArray.count;
    
    
    //只选择一个人得时候,创建单人聊天
    if (1 == count) {
        RCUserInfo* userInfo = [selectedArray objectAtIndex:0];
        [self startPrivateChat:userInfo];
    }
    //选择多个人得时候
    else if(count  > 1){
        
        [self startDiscussionChat:selectedArray];
        
    }
    
}

/**
 *  启动一对一聊天
 *
 *  @param userInfo
 */
-(void)startPrivateChat:(RCUserInfo*)userInfo{
    
    FBChatViewController* chat = [self getChatController:userInfo.userId conversationType:ConversationType_PRIVATE];
    if (nil == chat) {
        chat =[[FBChatViewController alloc]init];
        chat.portraitStyle = UIPortraitViewRound;
        [self addChatController:chat];
    }
    
    chat.currentTarget = userInfo.userId;
    chat.currentTargetName = userInfo.name;
    chat.conversationType = ConversationType_PRIVATE;
    [self.navigationController pushViewController:chat animated:YES];
}

/**
 *  启动讨论组
 *
 *  @param userInfos
 */
-(void)startDiscussionChat:(NSArray*)userInfos{
//    
//    NSMutableString *discussionName = [NSMutableString string] ;
//    NSMutableArray *memberIdArray =[NSMutableArray array];
//    NSInteger count = userInfos.count ;
//    for (int i=0; i<count; i++) {
//        RCUserInfo *userinfo = [userInfos objectAtIndex:i];
//        //NSString *name = userinfo.name;
//        if (i == userInfos.count - 1) {
//            [discussionName appendString:userinfo.name];
//        }else{
//            [discussionName  appendString:[NSString stringWithFormat:@"%@%@",userinfo.name,@","]];
//        }
//        [memberIdArray addObject:userinfo.userId];
//        
//    }
//    //创建讨论组
//    [[RCIMClient sharedRCIMClient]createDiscussion:discussionName userIdList:memberIdArray completion:^(RCDiscussion *discussInfo) {
//        NSLog(@"create discussion ssucceed!");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            DemoChatViewController* chat = [self getChatController:discussInfo.discussionId conversationType:ConversationType_PRIVATE];
//            if (nil == chat) {
//                chat =[[DemoChatViewController alloc]init];
//                chat.portraitStyle = UIPortraitViewRound;
//                [self addChatController:chat];
//            }
//            
//            chat.currentTarget = discussInfo.discussionId;
//            chat.currentTargetName = discussInfo.discussionName;
//            chat.conversationType = ConversationType_DISCUSSION;
//            [self.navigationController pushViewController:chat animated:YES];
//        });
//    } error:^(RCErrorCode status) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSLog(@"DISCUSSION_INVITE_FAILED %d",status);
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"" message:@"创建讨论组失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//        });
//    }];
}

/**
 *  重载选择表格事件
 *
 *  @param conversation <#conversation description#>
 */
-(void)onSelectedTableRow:(RCConversation*)conversation{
    
    
    if(conversation.conversationType == ConversationType_GROUP)
    {
//        DemoGroupListViewController* groupVC = [[DemoGroupListViewController alloc] init];
//        self.currentGroupListView = groupVC;
//        groupVC.portraitStyle = UIPortraitViewRound;
//        [self.navigationController pushViewController:groupVC animated:YES];
        return;
    }
    //该方法目的延长会话聊天UI的生命周期
    FBChatViewController* chat = [self getChatController:conversation.targetId conversationType:conversation.conversationType];
    if (nil == chat) {
        chat =[[FBChatViewController alloc]init];
        chat.portraitStyle = UIPortraitViewRound;
        [self addChatController:chat];
    }
    chat.currentTarget = conversation.targetId;
    chat.conversationType = conversation.conversationType;
    chat.currentTargetName = conversation.conversationTitle;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}


@end
