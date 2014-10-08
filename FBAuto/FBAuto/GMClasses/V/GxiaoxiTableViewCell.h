//
//  GxiaoxiTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//站内消息
#import <UIKit/UIKit.h>
#import "XMPPMessageModel.h"
@class GxiaoxiViewController;

@interface GxiaoxiTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImageView;//头像
@property(nonatomic,strong)UILabel *nameLabel;//姓名label
@property(nonatomic,strong)UILabel *timeLabel;//时间
@property(nonatomic,strong)NSString *userId;//用户id
@property(nonatomic,strong)UILabel *contentLabel;//内容


@property(nonatomic,assign)GxiaoxiViewController *delegate;

-(void)configWithData:(XMPPMessageModel*)model;

@end
