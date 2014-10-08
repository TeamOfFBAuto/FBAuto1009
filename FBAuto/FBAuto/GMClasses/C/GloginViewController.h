//
//  GloginViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//登录界面VC
#import <UIKit/UIKit.h>
@class GloginView;
#define Frame_row3Down CGRectMake(24, 312, 275, 210)
#define Frame_row3Up CGRectMake(24, 312-180, 275, 210)
@interface GloginViewController : FBBaseViewController

@property(nonatomic,strong)GloginView *gloginView;

@end
