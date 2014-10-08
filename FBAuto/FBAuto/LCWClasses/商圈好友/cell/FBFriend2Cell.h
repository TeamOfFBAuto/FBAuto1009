//
//  FBFriend2Cell.h
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBFriendModel;

@interface FBFriend2Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageV;
@property (strong, nonatomic) IBOutlet UILabel *nameAndTypeL;//(张三(个人))
@property (strong, nonatomic) IBOutlet UILabel *phoneNumAndAddressL;//(186/(北京))

- (void)getCellData:(FBFriendModel *)aModel;

@end
