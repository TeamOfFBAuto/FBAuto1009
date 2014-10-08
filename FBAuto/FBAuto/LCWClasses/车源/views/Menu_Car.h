//
//  Menu_Car.h
//  FBAuto
//
//  Created by lichaowei on 14-7-15.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCarBlock) (NSString *select);
@interface Menu_Car : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *frontV;//需要提前的view
    UIImageView *arrowImage;//箭头
    
    NSMutableDictionary *brandDic;//存储分组brand
    NSArray *firstLetterArray;//分组首字母数据brand
    
    UITableView *table;
    NSArray *dataArray;
    
    NSMutableDictionary *typeDic;//存储分组type
    NSArray *type_firstLetterArr;//分组首字母数据type
    
    UITableView *secondTable;//二级table
    NSArray *secondArray;
    
    UITableView *thirdTable;//三级table
    NSArray *thirdArray;
    
    UITableView *colorTable;//控制颜色相关table
    NSArray *colorArray;
    
    CGFloat sumHeight;//总高度
    SelectCarBlock selectBlock;
    
    NSString *brandId;//当前id
    NSString *typeId;
    
    BOOL _needRefresh;//需要刷新数据
    
    UIButton *footerBtn;//不限 按钮
    
}
@property(nonatomic,assign)NSInteger itemIndex;//第几个item,用于控制箭头位置

- (void)showInView:(UIView *)aView;
- (void)hidden;
- (id)initWithFrontView:(UIView *)frontView;
- (void)selectBlock:(SelectCarBlock)aBlock;

- (void)reloadFirstTable;

@end
