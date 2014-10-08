//
//  FBChatViewController.m
//  TestIMKIt
//
//  Created by lichaowei on 14-9-20.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "FBChatViewController.h"

@interface FBChatViewController ()<RCIMConnectionStatusDelegate>

@end

@implementation FBChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[RCIM sharedRCIM]setConnectionStatusDelegate:self];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [[RCIM sharedRCIM] setConnectionStatusDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.chatListTableView.backgroundColor = [UIColor whiteColor];
    
    //自定义导航标题颜色
//    [self setNavigationTitle:self.currentTargetName textColor:[UIColor whiteColor]];
//    
//    //自定义导航左右按钮
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemPressed:)];
//    [leftButton setTintColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.enableVOIP = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
}

#pragma mark 监控连接状态

-(void)responseConnectionStatus:(RCConnectionStatus)status{
    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"" message:@"您已下线，重新连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
            alert.tag = 2000;
            [alert show];
        });
        
        
    }
}

@end
