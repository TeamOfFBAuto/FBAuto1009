//
//  GuserZyViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-29.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GyhzyTableViewCell;
@class GuserModel;
@interface GuserZyViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UIAlertViewDelegate>

{
    RefreshTableView *_tableView;//主tableview
    
    GyhzyTableViewCell *_tmpCell;//临时用来获取高度的cell
    
    
    int _page;//第几页
    NSArray *_dataArray;
    
}

@property(nonatomic,retain)NSString *title;

@property(nonatomic,strong)NSString *userId;//用于获取数据的用户id

@property(nonatomic,strong)GuserModel *guserModel;







@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *saleTypeBtn;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomBgView;


- (IBAction)clickToDial:(UIButton *)sender;//打电话

- (IBAction)clickToChat:(UIButton *)sender;//聊天

- (IBAction)clickToPersonal:(UIButton *)sender;//个人信息页

@end
