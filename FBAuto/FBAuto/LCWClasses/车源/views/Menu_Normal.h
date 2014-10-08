//
//  Menu_Normal.h
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用于版本、来源、库存
 */


typedef enum {
    Menu_Standard = 0,//版本
    Menu_Source,//来源
    Menu_Timelimit,//库存
    Menu_Money,//定金
    Menu_Color_Out,//外观颜色
    Menu_Color_In //内饰颜色
}MenuStyle;

typedef void(^SelectNormalBlock) (MenuStyle style, NSString *selectId);

@interface Menu_Normal : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *frontV;//需要提前的view
    UIImageView *arrowImage;//箭头
    
    UITableView *table;
    NSArray *dataArray;
    
    CGFloat sumHeight;//总高度
    SelectNormalBlock selectBlock;
    
    MenuStyle selectStyle;//类型
}

@property(nonatomic,assign)NSInteger itemIndex;//第几个item,用于控制箭头位置

- (id)initWithFrontView:(UIView *)frontView menuStyle:(MenuStyle)style;
- (void)showInView:(UIView *)aView;
- (void)hidden;

- (void)selectNormalBlock:(SelectNormalBlock)aBlock;

@end
