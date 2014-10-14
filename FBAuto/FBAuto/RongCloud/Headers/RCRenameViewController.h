//
//  RenameViewController.h
//  iOS-IMKit
//
//  Created by xugang on 8/14/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"

@protocol RenameViewControllerDelegate;

@interface RCRenameViewController : RCBasicViewController

@property (nonatomic,weak) id<RenameViewControllerDelegate> delegate;

@property(nonatomic,strong) UITextField *textField;

@property(nonatomic,strong) NSString *targetId;

@property (nonatomic,strong) NSString* oldName;

@property (nonatomic,assign) RCConversationType conversationType;


/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  导航右面按钮点击事件
 */
-(void)rightBarButtonItemPressed:(id)sender;

-(void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;


@end


@protocol RenameViewControllerDelegate <NSObject>

-(void)didRenameDiscussonName:(NSString*)name;

@end