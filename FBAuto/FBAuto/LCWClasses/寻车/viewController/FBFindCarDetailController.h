//
//  FBFindCarDetailController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

@interface FBFindCarDetailController : FBBaseViewController<MFMessageComposeViewControllerDelegate>

//商家信息
@property (strong, nonatomic) IBOutlet UIImageView *headImage;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *saleTypeBtn;//商家类型
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomBgView;

@property (nonatomic,retain)NSString *infoId;//车源信息id
@property (nonatomic,retain)NSString *carId;//车型编码(001002003)

- (IBAction)clickToDial:(id)sender;//打电话
- (IBAction)clickToChat:(id)sender;//聊天
- (IBAction)clickToPersonal:(id)sender;//个人信息页

@end
