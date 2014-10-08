//
//  GzhuceTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//自定义注册界面tableViewCell
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class GzhuceViewController;


typedef void (^cellBlock)();

typedef void (^tfBlock)(long tt);//根据键盘高度调整控件显示
typedef void (^shouTablevBlock)();//收键盘的时候还原tableivew.frame

typedef void (^chooseAreaBlock)();//选择地区

@interface GzhuceTableViewCell : UITableViewCell<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITableView *_gerenTableView;
    UITableView *_shangjiaTableView;
    NSArray *_titielArray;
    
    UIButton *_yanzhengBtn;//获取验证码的button
    UIButton *_yanzhengBtn1;//商家获取验证码button
    
    int _timeNum;//60s倒计时验证码
    int _timeNum1;
    NSTimer *_timer;
    NSTimer *_timer1;
    
    
    MBProgressHUD *_hud;
}
//个人注册
@property(nonatomic,strong)UIView *zhuceView;//注册view
@property(nonatomic,strong)NSMutableArray *contenTfArray;//输入框数组

//商家注册
@property(nonatomic,strong)UIView *zhuceView1;//注册view
@property(nonatomic,strong)NSMutableArray *contentTfArray1;//输入框数组


//地区
//个人
@property(nonatomic,assign)NSInteger province;//省份
@property(nonatomic,assign)NSInteger city;//城市
//商家
@property(nonatomic,assign)NSInteger province1;
@property(nonatomic,assign)NSInteger city1;

@property(nonatomic,assign)GzhuceViewController *delegate;




//block
@property(nonatomic,copy)tfBlock tfBlock;
@property(nonatomic,copy)cellBlock cellBlock;
@property(nonatomic,copy)shouTablevBlock shouTablevBlock;
@property(nonatomic,copy)chooseAreaBlock chooseAreaBlock;

//block set方法
-(void)setCellBlock:(cellBlock)cellBlock;
-(void)setTfBlock:(tfBlock)tfBlock;
-(void)setShouTablevBlock:(shouTablevBlock)shouTablevBlock;
-(void)setChooseAreaBlock:(chooseAreaBlock)chooseAreaBlock;



//收键盘
-(void)allShou;

//给地区赋值
-(void)areaFuzhi;


@end
