//
//  GzhuceViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//注册界面的vc

#import <UIKit/UIKit.h>




@interface GzhuceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    UIBarButtonItem * spaceButton;
    
    UITableView *_gerenTableView;
    UITableView *_shangjiaTableView;
    NSArray *_titielArray;
    
    UIButton *_yanzhengBtn;//获取验证码的button
    
    int _timeNum;//60s倒计时验证码
    NSTimer *_timer;
    
    //地区选择
    UIPickerView *_pickeView;
    NSArray *_data;//地区数据
    NSInteger _flagRow;//pickerView地区标志位
    //地区数据字符串拼接
    NSString *_str3;
    NSString *_str1;
    NSString *_str2;
    
    
    BOOL _isChooseArea;//是否修改了地区
    
    
    
    
    UIButton *_btn1;
    UIButton *_btn2;
    
}


@property(nonatomic,strong)UIView *zhuceView;//注册view

@property(nonatomic,strong)NSMutableArray *contenTfArray;//输入框数组

//个人
@property(nonatomic,strong)NSString *province;//省
@property(nonatomic,strong)NSString *city;//城市

//商家
@property(nonatomic,strong)NSString *province1;
@property(nonatomic,strong)NSString *city1;

@property(nonatomic,strong)UIView *backPickView;//地区选择pickerView后面的背景view

//上传参数 int类型
//个人
@property(nonatomic,assign)NSInteger provinceIn;
@property(nonatomic,assign)NSInteger cityIn;
//商家
@property(nonatomic,assign)NSInteger provinceIn1;
@property(nonatomic,assign)NSInteger cityIn1;










@end
