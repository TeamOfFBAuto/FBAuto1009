//
//  SendCarParamsController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

/**
 *  发布车源 参数选择页
 */

typedef enum{
    
    Data_Car_Brand = 0,//品牌
    Data_Car_Type, //车型
    Data_Car_Style,//车款
    Data_Standard, //版本
    Data_Price,//价格
    Data_Timelimit, //库存
    Data_Color_Out,//外观颜色
    Data_Color_In,//内饰颜色
    Data_Money,//定金
    Data_Area,//地区 省份
    Data_Area_City, //地区 城市
    
    Data_Car_Type_Custom, //车型 自定义
    Data_Car_Style_Custom //车款 自定义
    
}DATASTYLE;

typedef void(^ SelectParamsBlock) (DATASTYLE style,NSString *paramName,NSString *paramId);

@interface SendCarParamsController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    SelectParamsBlock selectBlock;
}

@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,assign)DATASTYLE dataStyle;
@property(nonatomic,retain)UILabel *selectLabel;//选中label
@property(nonatomic,retain)NSString *lastLevelId;//上一级id
@property(nonatomic,retain)NSString *brandId;
@property(nonatomic,retain)NSString *typeId;//
@property(nonatomic,assign)UIViewController *rootVC;//根视图
@property(nonatomic,assign)BOOL haveLimit;//是否有 不限选择(yes 时 有 不限选择)

@property(nonatomic,retain)NSString *provinceId;//省份
@property(nonatomic,retain)NSString *cityId;//城市

- (void)selectParamBlock:(SelectParamsBlock)aBlock;


@end
