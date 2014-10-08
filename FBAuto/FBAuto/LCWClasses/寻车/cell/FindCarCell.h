//
//  FindCarCell.h
//  FBAuto
//
//  Created by lichaowei on 14-7-18.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarSourceClass;

@interface FindCarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *toAddressLabel;


- (void)setCellDataWithModel:(CarSourceClass *)aCar;

@end
