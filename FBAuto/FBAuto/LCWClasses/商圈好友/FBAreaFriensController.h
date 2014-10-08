//
//  FBAreaFriensController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"
/**
 *  按地区查找
 */
@interface FBAreaFriensController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *cityDic;//存储分组城市
    
    NSDictionary *provinceDic;//存放省份
    NSArray *firstLetterArray;//分组首字母数据
    
    UITableView *secondTable;//二级table
    NSArray *secondArray;
    
    UITableView *thirdTable;//三级table
    NSArray *thirdArray;

}
@end
