//
//  BasicViewController.h
//  TestNOARC
//
//  Created by xugang on 6/9/14.
//  Copyright (c) 2014 RongCloud. All rights reserved.
//
//所有工程UIViewController的基类，使用代码初始化view

#import <UIKit/UIKit.h>
#import "RCThemeDefine.h"
@interface RCBasicViewController : UIViewController
- (void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;
@end
