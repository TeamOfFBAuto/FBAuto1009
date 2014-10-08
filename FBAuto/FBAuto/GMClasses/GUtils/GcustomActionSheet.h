//
//  GcustomActionSheet.h
//  FBCircle
//
//  Created by gaomeng on 14-9-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    GcustomActionSheetLogOut = 0,//退出登录
}GcustomActionSheetEnum;

///普通按钮间隔
#define normalBtnSpacing 10.0f

///取消或按钮和普通按钮之间的间隔
#define cancelBtnSpacing 20.0f

///第一个按钮和上边框的间距
#define firstBtnForTopSpacing 22.0f

///按钮的高度
#define HeightOfNormalBtn 44.0f

@class GcustomActionSheet;
@protocol GcustomActionSheetDelegate <NSObject>

-(void)zactionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface GcustomActionSheet : UIView
///标题
@property(nonatomic,strong)UILabel * title_label;

///内容
@property(nonatomic,strong)UIView * content_view;

///代理
@property(nonatomic,assign)id<GcustomActionSheetDelegate>delegate;


 
///aTitle标题  buttonTitles内容标题  buttonColor内容背景色  canceTitle取消按钮标题  cancelColor取消按钮背景色 actionColor actionSheet背景色
-(GcustomActionSheet *)initWithTitle:(NSString *)aTitle buttonTitles:(NSArray *)buttonTitles buttonColor:(UIColor *)buttonColor CancelTitle:(NSString *)canceTitle CancelColor:(UIColor *)cancelColor actionBackColor:(UIColor *)actionColor;
-(GcustomActionSheet *)initWithTitle:(NSString *)aTitle logOutBtnImageName:(NSString *)imageName logOutBtnTitle:(NSString *)logOutTitle buttonColor:(UIColor *)buttonColor CancelTitle:(NSString *)canceTitle CancelColor:(UIColor *)cancelColor actionBackColor:(UIColor *)actionColor;

-(void)showInView:(UIView *)view WithAnimation:(BOOL)animatio;

@end
