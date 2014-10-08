//
//  GtzDetailViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//通知的详细页面
#import <UIKit/UIKit.h>
@class GpersonTZdetailTableViewCell;

@interface GtzDetailViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    GpersonTZdetailTableViewCell *_tmpCell;
}
@property(nonatomic,strong)NSString *uid;

@property(nonatomic,strong)NSString *timeStr;//时间
@property(nonatomic,strong)NSString *contentStr;//内容

@end
