//
//  GpersonTZViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//个人中心 通知vc
#import <UIKit/UIKit.h>

#import "GmPrepareNetData.h"

@interface GpersonTZViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>

{
    RefreshTableView *_tableView;
    
}

@property(nonatomic,strong)NSString *userId;//用户id





@end
