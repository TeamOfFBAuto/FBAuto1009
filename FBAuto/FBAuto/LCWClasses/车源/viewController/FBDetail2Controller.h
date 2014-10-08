//
//  FBDetail2Controller.h
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

@interface FBDetail2Controller : FBBaseViewController<UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *firstBgView;
@property (strong, nonatomic) IBOutlet UIView *thirdBgView;
@property (strong, nonatomic) IBOutlet UIScrollView *bigBgScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *photosScroll;

//参数
@property (strong, nonatomic) IBOutlet UILabel *car_modle_label;
@property (strong, nonatomic) IBOutlet UILabel *car_realPrice_label;
@property (strong, nonatomic) IBOutlet UILabel *car_guidePrice_label;
@property (strong, nonatomic) IBOutlet UILabel *car_timelimit_label;
@property (strong, nonatomic) IBOutlet UILabel *car_outColor_Label;
@property (strong, nonatomic) IBOutlet UILabel *car_inColor_label;
@property (strong, nonatomic) IBOutlet UILabel *car_standard_label;
@property (strong, nonatomic) IBOutlet UILabel *car_time_label;
@property (strong, nonatomic) IBOutlet UILabel *car_detail_label;
@property (strong, nonatomic) IBOutlet UILabel *build_time_label;

//商家信息
@property (strong, nonatomic) IBOutlet UIImageView *headImage;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *saleTypeBtn;//商家类型
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic,retain)NSString *infoId;//车源信息id
@property (nonatomic,retain)NSString *carId;//车源信息id(如:006005002)

//是否隐藏商家信息页面
@property(nonatomic,assign)BOOL isHiddenUeserInfo;//yes的时候隐藏 

- (IBAction)clickToDial:(id)sender;//打电话
- (IBAction)clickToChat:(id)sender;//聊天
- (IBAction)clickToPersonal:(id)sender;//个人信息页


@end
