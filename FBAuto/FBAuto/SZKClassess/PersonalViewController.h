//
//  PersonalViewController.h
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//个人中心
#import <UIKit/UIKit.h>

@interface PersonalViewController : FBBaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

{
    UITableView *_tableView;//主tableview
    
    UIButton *_shangquanBtn;//商圈btn
    UIButton *_xiaoxiBtn;//消息btn
    UIButton *_tongzhiBtn;//通知btn
    
}

@property(nonatomic,strong)UIImageView *userFaceImv;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *nameLabel1;


//小红点 小红点上数字显示 0为没有小红点
@property(nonatomic,assign)int xiaoxiRedPointNum;//消息按钮右上的小红点需要显示的个数
@property(nonatomic,assign)int tongzhirRedPointNum;//通知按钮右上的小红点需要显示的个数


@property(nonatomic,strong)UIView *xiaoxiRedPointView;//消息 小红点view
@property(nonatomic,strong)UIView *tongzhiRedPointView;//通知 小红点view

@property(nonatomic,strong)UILabel *xiaoxiNumLabel;//显示消息数量的label
@property(nonatomic,strong)UILabel *tongzhiNumLabel;//显示通知数量的label



@end
