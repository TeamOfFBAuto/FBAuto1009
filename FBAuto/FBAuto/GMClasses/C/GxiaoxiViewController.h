//
//  GxiaoxiViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//站内消息
#import <UIKit/UIKit.h>
@class GxiaoxiTableViewCell;

@interface GxiaoxiViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;//主tableview
    GxiaoxiTableViewCell *_tmpCell;
    
}





@end
