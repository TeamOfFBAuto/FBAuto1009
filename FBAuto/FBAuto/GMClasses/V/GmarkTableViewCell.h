//
//  GmarkTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//我的收藏自定义cell
#import <UIKit/UIKit.h>
@class GmarkViewController;

typedef void (^DelImvClickedBlock)(NSInteger gtag);//选择某个收藏删除

@interface GmarkTableViewCell : UITableViewCell
{
    UIView *_noDelWhView;//正常状态下的白竖条
    UIView *_DelWhView;//删除状态下的白竖条
    
}


@property(nonatomic,strong)UILabel *tLabel;//标题label
@property(nonatomic,strong)UILabel *cLabel;//内容label

@property(nonatomic,assign)GmarkViewController *delegate;//拿到vc对象

@property(nonatomic,copy)DelImvClickedBlock delImvClickedBlock;//block 属性

@property(nonatomic,strong)UIImageView *clickImv;//选中对应项删除



//block set方法
-(void)setDelImvClickedBlock:(DelImvClickedBlock)delImvClickedBlock;

//加载视图 填充数据 并返回单元格高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath*)theIndexPatch;

//填充数据
-(void)configWithNetData:(NSArray *)array indexPath:(NSIndexPath*)theIndexPath;

@end
