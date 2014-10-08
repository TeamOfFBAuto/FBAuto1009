//
//  CWInputView.h
//  CWProject
//
//  Created by Lichaowei on 14-4-4.
//  Copyright (c) 2014年 Chaowei LI. All rights reserved.
//

/**
 *  1、 根据内容自动调整输入框frame
 *  2、 测试 emoji 表情
 */

#import <UIKit/UIKit.h>
#import "NSString+Emoji.h"

@class CWInputView;

typedef void(^ ToolBlock) (int aTag);//aTag, 0 打电话,1 拍照,2 相册,3 frame变化
typedef void(^ FrameBlock) (CWInputView *inputView,CGRect frame,BOOL isEnd);//frame变化

@class CWInputView;
@protocol CWInputDelegate <NSObject>

- (void)inputView:(CWInputView *)inputView sendBtn:(UIButton*)sendBtn inputText:(NSString*)text;

@end

@interface CWInputView : UIView<UITextFieldDelegate,UITextViewDelegate>
{
    CGFloat initFrameY;//最开始的frame y
    CGFloat current_FrameY;//inputView当前坐标Y
    CGFloat current_KeyBoard_Y;//当前键盘坐标Y
    
    ToolBlock toolBlock;
    FrameBlock frameBlock;
}

@property(assign,nonatomic)id<CWInputDelegate> delegate;
@property(strong,nonatomic)UITextView *textView;
@property(strong,nonatomic)UIButton *sendBtn;
@property(strong,nonatomic)UIButton *toolBtn1;
@property(strong,nonatomic)UIButton *toolBtn2;

//点击btn时候是否清空textfield  默认NO
@property(assign,nonatomic)BOOL clearInputWhenSend;
//点击btn时候是否隐藏键盘  默认NO
@property(assign,nonatomic)BOOL resignFirstResponderWhenSend;

//初始frame
@property(assign,nonatomic)CGRect originalFrame;

//隐藏键盘
- (BOOL)resignFirstResponder;

- (void)setToolBlock:(ToolBlock)aBlock;

- (void)setFrameBlock:(FrameBlock)aFrameBlock;

@end
