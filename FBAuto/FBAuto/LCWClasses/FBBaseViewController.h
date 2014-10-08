//
//  FBBaseViewController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    Navigation_TitleAndBack = 0,//有标题和title
    Navigation_Special //特殊情况,有特殊按钮
    
}NavigationStyle;

//通知
#define UPDATE_FRIEND_LIST @"UPDATE_FRIEND_LIST" //更新朋友列表

@interface FBBaseViewController : UIViewController

@property (nonatomic,retain)NSString *navigationTitle;//标题
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UIButton *button_back;



@property (nonatomic,assign)NavigationStyle style;

- (IBAction)clickToBack:(id)sender;

-(void)PushToViewController:(UIViewController *)controller animated:(BOOL)animation;

@end
