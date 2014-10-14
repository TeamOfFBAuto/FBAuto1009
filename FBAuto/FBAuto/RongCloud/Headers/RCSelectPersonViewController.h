//
//  SelectPersonViewController.h
//  RCIM
//
//  Created by Heq.Shinoda on 14-6-3.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//


#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"


typedef enum {

    NormalMode=0,
    CreateMode,
    InviteMode

}UseMode;



@class RCBasicViewController;
@class RCDiscussion;
@class RCUserInfo;
@protocol RCSelectPersonViewControllerDelegate;

#define MAX_ARRAY_SECTION 30
#define MaX_ARRAY_ROW 5000

@interface RCSelectPersonViewController : RCBasicViewController
{
    BOOL  __selected_flag[MAX_ARRAY_SECTION][MaX_ARRAY_ROW];
}
@property (nonatomic,strong) id<RCSelectPersonViewControllerDelegate> delegate;
@property (nonatomic,retain) UITableView *personTableView;
@property (nonatomic,retain) NSMutableArray *personList;
@property (nonatomic,strong) NSMutableArray *selectedPersonList;
@property (nonatomic,retain) UISearchBar *serachBar;

@property (nonatomic,strong) RCUserInfo *currentUserinfo;

@property (nonatomic) UIPortraitViewStyle portaitStyle;


//邀请模式下，传递讨论组信息
@property (nonatomic,strong) RCDiscussion *discussionInfo_invite;

//设置选择模式
@property (nonatomic,assign) UseMode useMode;

//已经选择过的联系人
@property (nonatomic,strong) NSArray *preSelectedUserIds;

//是否多选
@property (nonatomic,assign) BOOL  isMultiSelect;

/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  导航右面按钮点击事件
 */
-(void)rightBarButtonItemPressed:(id)sender;

- (void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;

@end

@protocol RCSelectPersonViewControllerDelegate <NSObject>
@optional
-(void)didSelectedPersons:(NSArray*)selectedArray viewController:(RCSelectPersonViewController*)viewController;

@end