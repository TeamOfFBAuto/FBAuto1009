//
//  GPersonTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//个人中心自定义cell
#import <UIKit/UIKit.h>

static int viewTag;

typedef void (^kuangBlock)(NSInteger index);

@interface GPersonTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titileLabel;//标题
@property(nonatomic,strong)UIView *kuang;//框

@property(nonatomic,copy)kuangBlock kuangBlock;//点击单元格中每个view的block

-(void)dataWithTitleLableWithIndexPath:(NSIndexPath*)theIndexPatch;//给titileLabel赋值


//block的set方法
-(void)setKuangBlock:(kuangBlock)kuangBlock;

//加载控件
-(void)loadViewWithIndexPath:(NSIndexPath *)theIndexPatch;


@end
