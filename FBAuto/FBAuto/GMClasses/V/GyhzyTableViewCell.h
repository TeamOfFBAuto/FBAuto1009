//
//  GyhzyTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//用户主页自定义单元格

#import <UIKit/UIKit.h>
@class GuserModel;
@class CarSourceClass;

@interface GyhzyTableViewCell : UITableViewCell


//用户信息
@property(nonatomic,strong)UILabel *nameLabel;//名称
@property(nonatomic,strong)UILabel *areaLable;//地区
@property(nonatomic,strong)UILabel *phoneLabel;//电话
@property(nonatomic,strong)UILabel *dizhiLabel;//地址
@property(nonatomic,strong)UILabel *jianjieLabel;//简介
@property(nonatomic,strong)UIImageView *touxiangImageView;//头像imageview

//车源
@property(nonatomic,strong)UILabel *carNameLabel;//车源名称
@property(nonatomic,strong)UILabel *carPriceLabel;//价钱
@property(nonatomic,strong)UILabel *carClabel1;//描述1
@property(nonatomic,strong)UILabel *carClale2;//描述2
@property(nonatomic,strong)UILabel *carUserNameLabel;//车源商家label
@property(nonatomic,strong)UILabel *carTimeLabel;//时间



//加载控件 并 返回高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath *)theIndexPath model:(GuserModel*)userModel;


//填充数据 用户
-(void)configWithUserModel:(GuserModel*)userModel;


//填充数据 车源
-(void)configWithCarModel:(CarSourceClass *)car userModel:(GuserModel*)userModel;



@end
