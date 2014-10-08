//
//  GfindPasswViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//找回密码界面VC
#import <UIKit/UIKit.h>

@interface GfindPasswViewController : FBBaseViewController<UIAlertViewDelegate>
{
    NSTimer *_timer;
    UIButton * _yanzhengBtn;
    int _timeNum;
}
@property(nonatomic,strong)UITextField *phonetf;//手机号
@property(nonatomic,strong)UITextField *yanzhengtf;//验证码
@property(nonatomic,strong)UITextField *passWordtf;//新密码

@end
