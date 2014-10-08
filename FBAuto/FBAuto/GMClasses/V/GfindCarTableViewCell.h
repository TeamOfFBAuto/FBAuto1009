//
//  GfindCarTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//


// 个人中心 寻车自定义cell
#import <UIKit/UIKit.h>
@class GfindCarViewController;

typedef void (^addViewBlock)();//点击箭头添加选项菜单view
typedef void (^caozuoBtnBlock)(NSInteger btnTag);

@interface GfindCarTableViewCell : UITableViewCell
{
    UIView *_shanchuView;//点击箭头出来的删除view
}
@property(nonatomic,assign)BOOL ischoose;//是否添加了视图
@property(nonatomic,copy)addViewBlock addviewBlock;
@property(nonatomic,assign)GfindCarViewController *delegate;//代理
@property(nonatomic,strong)UIButton *addBtn;//右边的箭头
@property(nonatomic,copy)caozuoBtnBlock caozuoBtnBlock;

@property(nonatomic,retain)UILabel *ciLable;
@property(nonatomic,retain)UILabel *cLabel;
@property(nonatomic,retain)UILabel *tLabel;



-(void)setAddviewBlock:(addViewBlock)addviewBlock;
-(void)setCaozuoBtnBlock:(caozuoBtnBlock)caozuoBtnBlock;

-(CGFloat)loadView:(NSIndexPath*)theIndexPath;//加载控件并返回高度


@end
