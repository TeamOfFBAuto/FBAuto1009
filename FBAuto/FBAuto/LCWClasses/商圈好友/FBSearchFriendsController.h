//
//  FBSearchFriendsController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

/**
 *  搜索好友
 */
@interface FBSearchFriendsController : FBBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *table;

@end
