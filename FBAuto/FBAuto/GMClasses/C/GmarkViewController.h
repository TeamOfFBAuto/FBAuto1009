//
//  GmarkViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//个人中心 我的收藏界面
#import <UIKit/UIKit.h>



@class LoadingIndicatorView;
@class GmarkTableViewCell;


@interface GmarkViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    RefreshTableView *_tableview;//主tableview
    UIView *_dview;//下面删除view
    
    GmarkTableViewCell *_tmpCell;//用于计算高度
    
}




@property(nonatomic,assign)BOOL delClicked;//点击删除按钮
@property(nonatomic,assign)int delType;//是否为删除 2是正常 3为删除

@property(nonatomic,strong)UILabel *numLabel;//记录删除时选中了多少个





//记录点击要删除的收藏的数组
@property(nonatomic,strong)NSMutableArray *indexes;

@end
