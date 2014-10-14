//
//  ChatSessionViewController.h
//  RongCloud
//
//  Created by Heq.Shinoda on 14-4-22.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"

typedef enum
{
    KBottomBarStatusDefault = 0,
    KBottomBarStatusKeyboard,
    KBottomBarStatusMultiAction,
    KBottomBarStatusEmoji,
    KBottomBarStatusAudio
}KBottomBarStatus;

@class MessageDataModel;

@class RCAudioRecord;
@class RCEmojiView;
@class RCConversionDataSource;
@class RCMultiActionView;
@class RCPopupMenu;
@class RCPopupMenuItem;
@class VoiceCaptureControl;
@class RCChatSessionInputBarView;
@class RCConversationTableHeaderView;


@interface RCChatViewController : RCBasicViewController
{
    KBottomBarStatus currentBottomBarStatus;
    BOOL isSendImage;
    //MessageDataModel* imageDataMessage;
    //RCAudioRecord *_myRecorder;
}
@property(nonatomic, strong)UIImagePickerController *curPicker;
@property(nonatomic, strong) RCConversionDataSource* conversionDataSource;
@property(nonatomic, strong)NSString* msgContent;
@property(nonatomic, strong) UITableView* chatListTableView;
@property (strong, nonatomic) RCChatSessionInputBarView *msgInputBar;

@property (strong, nonatomic) RCMultiActionView* multiActionView;
@property (strong, nonatomic) RCEmojiView *emojiView;

@property (strong, nonatomic) RCConversationTableHeaderView *tableHeaderView;

@property (nonatomic) UIPortraitViewStyle portraitStyle;

@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,strong) NSString* currentTarget;
@property (nonatomic,strong) NSString* currentTargetName;

@property (nonatomic,assign,readonly) BOOL SendingCount;
@property (nonatomic,strong) VoiceCaptureControl *voiceCaptureControl;
@property (nonatomic,strong) RCPopupMenu *popupMenu;

/**
 *  是否屏蔽右导航按钮，默认YES
 */
@property (nonatomic ,assign) BOOL enableSettings;
/**
 *  是否开启voip
 */
@property (nonatomic,assign) BOOL enableVOIP;
/**
 *  是否开启右上角未读，默认开启 YES
 */
@property (nonatomic,assign) BOOL enableUnreadBadge;


-(void)reSendMessage:(NSNotification*)notification;

//发送文本消息
-(void)sendTextMessage;
-(void)drag4ResetDefaultBottomBarStatus;

- (void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;
/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  导航右面按钮点击事件
 */
-(void)rightBarButtonItemPressed:(id)sender;
/**
 *  调用查看大图
 *
 *  @param rcMessage 消息体
 */
-(void)showPreviewPictureController:(RCMessage*)rcMessage;
//语音消息开始录音
-(void)onBeginRecordEvent;
//语音消息录音结束
-(void)onEndRecordEvent;

@end
