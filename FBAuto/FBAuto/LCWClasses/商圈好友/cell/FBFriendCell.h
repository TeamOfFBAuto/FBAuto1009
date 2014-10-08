//
//  FBFriendCell.h
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBFriendModel;

typedef void(^ CellBlock) (NSString *friendInfo,int aTag);//0 聊天，1 分享
typedef void(^ CellToShare) (NSString *friendInfo);

@interface FBFriendCell : UITableViewCell
{
    CellBlock cellBlock;
    NSString *chatWithUser;//对话对象
    NSString *phoneNum;//电话
}

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *saleTypeLabel;//类型,个人或者商家等
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *chatToolBgView;


- (IBAction)clickToShare:(id)sender;

- (IBAction)clickToDial:(id)sender;//电话
- (IBAction)clickToChat:(id)sender;

- (void)getCellData:(FBFriendModel *)aModel cellBlock:(CellBlock)aCellBlock;

@end
